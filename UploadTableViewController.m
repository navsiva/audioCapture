//
//  UploadTableViewController.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "UploadTableViewController.h"

typedef NS_ENUM(NSUInteger, SCSiriWaveformViewInputType) {
    SCSiriWaveformViewInputTypeRecorder,
    SCSiriWaveformViewInputTypePlayer
};

@interface UploadTableViewController ()


@property (weak, nonatomic) IBOutlet SCSiriWaveformView *waveFormView;

@property (nonatomic, assign) SCSiriWaveformViewInputType selectedInputType;

@end


@implementation UploadTableViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationItem setHidesBackButton:YES];
}
-(void)viewDidLoad {
    [super viewDidLoad];

    
    self.uploadButton.backgroundColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];
    
    [self.infoTextField becomeFirstResponder];
    
    
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    

    
    
    
    
    [self.mySwitch setOn:self.playCorder.audioClip.isPublic];

    
    self.infoTextField.text = self.playCorder.audioClip.audioClipName;
    
    if (self.playCorder.audioClip.isPublic){
        
            self.shareLabel.text = @"Share";
            self.shareLabel.alpha = 1.0;
            self.shareLabel.textColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];

        }
    
    else {
        
            self.shareLabel.text = @"Share";
            self.shareLabel.alpha = 0.5;
            self.shareLabel.textColor = [UIColor darkGrayColor];

    }
    
    
    
    //setting up waveform
    
    [self setupWaveform];

}




-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(IBAction)play:(id)sender {
    
    [self.playCorder play];
}

-(IBAction)shareSwitch:(id)sender {
    
    if ([self.mySwitch isOn]) {
        
        self.shareLabel.text = @"Share";
        self.shareLabel.alpha = 1.0;
        self.shareLabel.textColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];
    } else {
        self.shareLabel.text = @"Share";
        self.shareLabel.alpha = 0.5;
        self.shareLabel.textColor = [UIColor darkGrayColor];
    }
}

-(IBAction)textCheck:(id)sender {
    
    
    if (self.infoTextField.text.length < 2 ){
       
        self.uploadButton.alpha = 0.25;
        self.uploadButton.enabled = NO;
        self.mySwitch.enabled = NO;
    }
}

-(IBAction)textChanged:(id)sender {
    
    if (self.infoTextField.text.length > 2){

        self.uploadButton.alpha = 1.0;
        self.uploadButton.enabled = YES;
        self.mySwitch.enabled = YES;
        
    } else {
        
        self.uploadButton.alpha = 0.25;
        self.uploadButton.enabled = NO;
        self.mySwitch.enabled = NO;
    }

}
-(IBAction)uploadProgress:(id)sender {
    
    self.uploadButton.backgroundColor = [UIColor colorWithRed:0.992 green:0.322 blue:0.251 alpha:1.0];

}
-(IBAction)backToRecord:(id)sender {
    
    self.playCorder.audioClip.isPublic = self.mySwitch.isOn;
    
    self.playCorder.audioClip.audioClipName = self.infoTextField.text;
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)upload:(id)sender {
    
    self.playCorder.audioClip.isPublic = self.mySwitch.isOn;
    
    self.playCorder.audioClip.audioClipName = self.infoTextField.text;

    [self.playCorder.audioClip saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];

}

-(IBAction)delete:(id)sender {

    [self.playCorder.audioClip deleteInBackgroundWithBlock:^(BOOL succeded, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{

            
         [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}

-(void)setupWaveform {
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.waveFormView setWaveColor:[UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0]];
    [self.waveFormView setPrimaryWaveLineWidth:3.0f];
    [self.waveFormView setSecondaryWaveLineWidth:1.0];
    [self setSelectedInputType:SCSiriWaveformViewInputTypeRecorder];
}

- (void)updateMeters
{
    [self.waveFormView updateWithLevel:[self.playCorder meterValue]];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"goBack"]) {
        
        [self.playCorder stop];
        
        CaptureViewController *destination= segue.destinationViewController;
        
        destination.playCorder = self.playCorder;
        
    }
    
}

@end
