//
//  CaptureViewController.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "CaptureViewController.h"

typedef NS_ENUM(NSUInteger, SCSiriWaveformViewInputType) {
    SCSiriWaveformViewInputTypeRecorder,
    SCSiriWaveformViewInputTypePlayer
};

@interface CaptureViewController ()



//declaring instance variables
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;


@property (weak, nonatomic) IBOutlet SCSiriWaveformView *waveFormView;

@property (nonatomic, assign) SCSiriWaveformViewInputType selectedInputType;



@end

@implementation CaptureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Disable Stop/Play button when application launches
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"MyAudioMemo.m4a", nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
    
    //setting up waveform
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.waveFormView setWaveColor:[UIColor whiteColor]];
    [self.waveFormView setPrimaryWaveLineWidth:3.0f];
    [self.waveFormView setSecondaryWaveLineWidth:1.0];
    
    [self setSelectedInputType:SCSiriWaveformViewInputTypeRecorder];
    
}

- (IBAction)recordTapped:(id)sender {
    
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    
    [self.pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.playButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    // Stop the audio player before recording
    if (self.player.playing) {
        [self.player stop];
    }
    
    if (!self.recorder.recording) {AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [self.recorder record];
        [self.recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
        [self.recordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [self.recorder pause];
        [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        

    }
    
    [self.stopButton setEnabled:YES];
    [self.playButton setEnabled:NO];
}

- (IBAction)playTapped:(id)sender {
    
    
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    
    [self.pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [self.stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    
    [self.playButton setTitle:@"Playing" forState:UIControlStateNormal];


    
    if (!self.recorder.recording){
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
        [self.player setDelegate:self];
        self.player.meteringEnabled= YES;
        [self.player play];
        
    }
}
- (IBAction)pauseTapped:(id)sender {
    self.player.numberOfLoops = 0;
    
    [self.player pause];
    [self.pauseButton setTitle:@"Playback Paused" forState:UIControlStateNormal];
    
    [self.pauseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.recorder pause];
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    
}
- (IBAction)loopTapped:(id)sender {
    self.player.enableRate=YES;

    self.player.numberOfLoops = -1;
    self.player.rate = 1.0f;
    [self.player prepareToPlay];
    [self.player play];
}

- (IBAction)loopFaster:(id)sender {
    self.player.enableRate=YES;

    [self.player prepareToPlay];
    self.player.rate = 2.0f;
    self.player.numberOfLoops = -1;
  
    
    
    [self.player play];
    

    
    NSLog(@"%f", self.player.rate);
    
    
}

- (IBAction)loopSlower:(id)sender {
    
    
    self.player.enableRate=YES;
    
    [self.player prepareToPlay];
    self.player.rate = 0.5f;
    self.player.numberOfLoops = -1;
    
    
    
    [self.player play];
    
    
    
    NSLog(@"%f", self.player.rate);
    
}





- (IBAction)stopTapped:(id)sender {
    
    [self.player pause];
    [self.pauseButton setTitle:@"Playback Stopped" forState:UIControlStateNormal];
    
    [self.pauseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.recorder stop];
    
    [self.stopButton setTitle:@"Stopped" forState:UIControlStateNormal];
    
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];


    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];


    
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateMeters
{
    CGFloat normalizedValue;
    
    
    if ([self.recorder isRecording]) {
        
        [self.recorder updateMeters];
        normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.recorder averagePowerForChannel:0]];
        
        
        
        
    } else {
        [self.player updateMeters];
        normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.player averagePowerForChannel:0]];
        
        
    }
    
    
    
    
    [self.waveFormView updateWithLevel:normalizedValue];
}

#pragma mark - Private

- (CGFloat)_normalizedPowerLevelFromDecibels:(CGFloat)decibels
{
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
