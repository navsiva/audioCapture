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




@property (weak, nonatomic) IBOutlet SCSiriWaveformView *waveFormView;

@property (nonatomic, assign) SCSiriWaveformViewInputType selectedInputType;

@end

@implementation CaptureViewController


//-(void)doesRecordingExist {
//    
//    [self.player stop];
//    
//
//
//    
//    if (self.audioClip.isDataAvailable){
//        
//        self.recordButton.enabled = NO;
//        [self.recordButton setBackgroundColor:[UIColor darkGrayColor]];
//
//        self.playButton.enabled = YES;
//        [self.playButton setBackgroundColor:[UIColor colorWithRed:0.929 green:0.502 blue:0.553 alpha:1]];
//        
//    }
//    else {
//
//        }
//        
//}


-(void)viewWillDisappear:(BOOL)animated{
    
    [self.playCorder stop];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationItem setHidesBackButton:YES];

}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    

    
    Playcorder *newRecorder = [[Playcorder alloc] initWithAudioClip:self.audioClip];
    
    self.playCorder = newRecorder;
    

    [self updateUI];


    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    
    longPress.minimumPressDuration = .01; //seconds
    longPress.delegate = self;
    [self.recordButton addGestureRecognizer:longPress];
    
    
    //setting up waveform
    [self setupWaveform];
    
}

-(IBAction)backToSearch:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)handlePress:(UILongPressGestureRecognizer *)gestureRecognizer
{

    self.navigationItem.rightBarButtonItem.enabled = NO;

    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    [self.playCorder stop];

    [self updateUI];
    
//    [self.playCorder getDuration];
    

 
}




-(IBAction)recordTappedOff:(id)sender {

    [self.playCorder record];

    [self updateUI];

}




-(IBAction)recordTapped:(id)sender {
    
    
    

}

-(IBAction)playTapped:(id)sender {
    
    [self.playCorder play];

    [self updateUI];
    
    NSLog(@"%f", self.playCorder.getDuration);

    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.929 green:0.502 blue:0.553 alpha:1];

    

    
}

-(IBAction)stopTapped:(id)sender {
   
    [self.playCorder stop];
    
}


-(IBAction)loopTapped:(id)sender {
    
    [self.playCorder loop];

}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)updateUI {
    
    [self.playCorder canRecord];
    
    
    if (self.playCorder.shouldRecord == NO){
        
        [self.recordButton setEnabled:NO];
        
        [self.recordButton setBackgroundColor:[UIColor darkGrayColor]];
        
        [self.playButton setBackgroundColor:[UIColor colorWithRed:0.929 green:0.502 blue:0.553 alpha:1]];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];


    }
    
    else {
        
        [self.recordButton setEnabled:YES];
        
        [self.playButton setBackgroundColor:[UIColor darkGrayColor]];

        if (self.playCorder)
        
        [self.recordButton setBackgroundColor:[UIColor colorWithRed:0.929 green:0.502 blue:0.553 alpha:1]];
        
        

        
        
        self.navigationItem.rightBarButtonItem.enabled = NO;

        self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];

    }
    
}

-(void)setupWaveform {
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.waveFormView setWaveColor:[UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0]];
    [self.waveFormView setPrimaryWaveLineWidth:3.0f];
    [self.waveFormView setSecondaryWaveLineWidth:1.0];
    [self setSelectedInputType:SCSiriWaveformViewInputTypeRecorder];
}

-(void)updateMeters {
  
    [self.waveFormView updateWithLevel:[self.playCorder meterValue]];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
     if ([[segue identifier] isEqualToString:@"showUpload"]) {
         
         [self.playCorder stop];
         
         UploadTableViewController *destination = segue.destinationViewController;
         
         destination.playCorder = self.playCorder;
        
     }
    
}

@end
