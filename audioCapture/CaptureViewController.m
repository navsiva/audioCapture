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

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;


@property (weak, nonatomic) IBOutlet SCSiriWaveformView *waveFormView;

@property (nonatomic, assign) SCSiriWaveformViewInputType selectedInputType;




@end

@implementation CaptureViewController


//-(void)recorderPlayer {
//    
//    if (self.player.isPlaying){
//        
//
//        
//    }
//    
//    
//}
//
//

-(void)viewWillDisappear:(BOOL)animated{
    

    [self.player stop];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationItem setHidesBackButton:YES];

    
    [self.player stop];

    
    if (!self.audioClip.isDataAvailable){
    [self.playButton setBackgroundColor:[UIColor darkGrayColor]];
//    [self.loopButton setBackgroundColor:[UIColor darkGrayColor]];
//    [self.stopButton setBackgroundColor:[UIColor darkGrayColor]];
    }
    else {
    [self.playButton setBackgroundColor:[UIColor colorWithRed:0.929 green:0.502 blue:0.553 alpha:1]];
//    [self.stopButton setBackgroundColor:[UIColor colorWithRed:0.929 green:0.502 blue:0.553 alpha:1]];
    }
//
}



-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.audioClip.audioClip getDataInBackgroundWithBlock:^(NSData * data, NSError * error){
        
        self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        
        [self.player setDelegate:self];
        
        self.player.meteringEnabled= YES;
    }];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    
    longPress.minimumPressDuration = .01; //seconds
    longPress.delegate = self;
    [self.recordButton addGestureRecognizer:longPress];
    
    if (!self.audioClip.isDataAvailable){
    self.navigationItem.rightBarButtonItem.enabled = NO;
    }

    // Disable Stop/Play button when application launches

    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"MyAudioMemo.m4a", nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    NSLog(@"%@", outputFileURL);
    
    
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
    
    if (!self.audioClip.isDataAvailable){
    [self.recorder prepareToRecord];
    }
    //setting up waveform
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.waveFormView setWaveColor:[UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0]];
    [self.waveFormView setPrimaryWaveLineWidth:3.0f];
    [self.waveFormView setSecondaryWaveLineWidth:1.0];
    
    [self setSelectedInputType:SCSiriWaveformViewInputTypeRecorder];
    
}


- (IBAction)backToSearch:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}






- (IBAction)lengthSlider:(id)sender {
    



}

- (IBAction)rateSlider:(id)sender {
    
    
}


-(void)handlePress:(UILongPressGestureRecognizer *)gestureRecognizer
{

    self.navigationItem.rightBarButtonItem.enabled = NO;

    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    //        // Pause recording
            [self.recorder stop];

            [self.recordButton setBackgroundColor:[UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0]];
            [self.playButton setBackgroundColor:[UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0]];
            self.navigationItem.rightBarButtonItem.enabled = YES;
    

    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    
    AudioClip *audioClip = [[AudioClip alloc] init];
    NSData *audioData = [NSData dataWithContentsOfURL:self.recorder.url];
    
    PFFile *audioFile = [PFFile fileWithName:@"MyAudioMemo.m4a" data:audioData];
    audioClip.audioClip = audioFile;
    
    
    audioClip.creator = [PFInstallation currentInstallation];
    
    
    audioClip.localURLString = [self.recorder.url absoluteString];
    
    audioClip.audioClipName = nil;
    
    [audioClip pinInBackground];
    
    self.audioClip = audioClip;
    
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
    
    [self.player setDelegate:self];
    
    self.player.meteringEnabled= YES;
    
    
    
}
- (IBAction)recordTappedOff:(id)sender {
    

    
    
    
    if (self.player.playing) {
        [self.player stop];
    }
    
    if (!self.recorder.recording) {AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [self.recorder record];
        
        [self.recordButton setBackgroundColor:[UIColor colorWithRed:0.992 green:0.322 blue:0.251 alpha:1.0]];
        
        
    }
    

    [self.playButton setEnabled:NO];
    
}




- (IBAction)recordTapped:(id)sender {
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    

}

- (IBAction)playTapped:(id)sender {
    
    if (!self.recorder.recording){
       
        [self.playButton setBackgroundColor:[UIColor colorWithRed:0.992 green:0.322 blue:0.251 alpha:1.0]];
        
        //self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
        //[self.player setDelegate:self];
        //self.player.meteringEnabled = YES;
        [self.player play];
        
    }

        
    
}
- (IBAction)stopTapped:(id)sender {
    self.player.numberOfLoops = 0;
    [self.player stop];
    [self.recorder stop];
        
    
}

- (IBAction)loopTapped:(id)sender {
    self.player.enableRate=YES;

    self.player.numberOfLoops = -1;
    self.player.rate = 1.0f;
    [self.player prepareToPlay];
    [self.player play];
}

//- (IBAction)loopFaster:(id)sender {
//    self.player.enableRate=YES;
//
//    [self.player prepareToPlay];
//    self.player.rate = 6.0f;
//    self.player.numberOfLoops = -1;
//  
//    
//    
//    [self.player play];
//    
//
//    
//    NSLog(@"%f", self.player.rate);
//    
//    
//}
//
//- (IBAction)loopSlower:(id)sender {
//    
//    
//    self.player.enableRate=YES;
//    
//    [self.player prepareToPlay];
//    self.player.rate = 0.1f;
//    self.player.numberOfLoops = -1;
//    
//    
//    
//    [self.player play];
//    
//    
//    
//    NSLog(@"%f", self.player.rate);
//    
//}


#pragma mark - THIS IS WHERE THE PFOBJECT IS SENT

//- (IBAction)stopTapped:(id)sender {
//    
//    [self.player pause];
//    [self.pauseButton setTitle:@"Playback Stopped" forState:UIControlStateNormal];
//    
//    [self.pauseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    
//    [self.recorder stop];
//    
//    [self.stopButton setTitle:@"Stopped" forState:UIControlStateNormal];
//    
//    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
//
//
//    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setActive:NO error:nil];
//    
//    AudioClip *audioClip = [[AudioClip alloc] init];
//    NSData *audioData = [NSData dataWithContentsOfURL:self.recorder.url];
//    
//    PFFile *audioFile = [PFFile fileWithName:@"MyAudioMemo.m4a" data:audioData];
//    audioClip.audioClip = audioFile;
//    
//    audioClip.audioClipName = @"First Recording";
//    
//    [audioClip pinInBackground];
//    
//    self.audioClip = audioClip;
//    
//    
//}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self.playButton setBackgroundColor:[UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0]];
    
}



- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.playButton setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
     if ([[segue identifier] isEqualToString:@"showUpload"]) {
         
         [self.player stop];
         
         UploadTableViewController *destination= segue.destinationViewController;
         
         destination.audioClip = self.audioClip;
        
     }
    
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
