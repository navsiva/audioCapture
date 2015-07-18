//
//  CaptureViewController.h
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SCSiriWaveformView.h"
#import <Parse/Parse.h>
#import "AudioClip.h"
#import "UploadTableViewController.h"

@interface CaptureViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@property (weak, nonatomic) IBOutlet UIButton *loopButton;
@property (weak, nonatomic) IBOutlet UIButton *fasterLoopButton;
@property (weak, nonatomic) IBOutlet UIButton *slowerLoopButton;
@property (weak, nonatomic) IBOutlet UISlider *lengthSlider;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;

@property (nonatomic, strong) AudioClip *audioClip;

@end
