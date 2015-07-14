//
//  CaptureViewController.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "CaptureViewController.h"

@interface CaptureViewController ()


{
    
//declaring instance variables
AVAudioRecorder *recorder;
AVAudioPlayer *player;

}


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
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
}

- (IBAction)recordTapped:(id)sender {
    
    [self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    
    [self.pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.playButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    if (!recorder.recording) {AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        [self.recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
        [self.recordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [recorder pause];
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


    
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
        
}
}
- (IBAction)pauseTapped:(id)sender {
    player.numberOfLoops = 0;
    
    [player pause];
    [self.pauseButton setTitle:@"Playback Paused" forState:UIControlStateNormal];
    
    [self.pauseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [recorder pause];
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    
}
- (IBAction)loopTapped:(id)sender {
    player.enableRate=YES;

    player.numberOfLoops = -1;
    player.rate = 1.0f;
    [player prepareToPlay];
    [player play];
}

- (IBAction)loopFaster:(id)sender {
    player.enableRate=YES;

    [player prepareToPlay];
    player.rate = 2.0f;
    player.numberOfLoops = -1;
  
    
    
    [player play];
    

    
    NSLog(@"%f", player.rate);
    
    
}

- (IBAction)loopSlower:(id)sender {
}





- (IBAction)stopTapped:(id)sender {
    
    [player pause];
    [self.pauseButton setTitle:@"Playback Stopped" forState:UIControlStateNormal];
    
    [self.pauseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [recorder stop];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
