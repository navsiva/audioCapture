//
//  UploadTableViewController.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "UploadTableViewController.h"

@interface UploadTableViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;


@end


@implementation UploadTableViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationItem setHidesBackButton:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uploadButton.backgroundColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];
    
    [self.infoTextField becomeFirstResponder];

//    NSString *urlString = self.audioClip.localURLString;
//
//    NSURL *url = [NSURL URLWithString:urlString];
    
    
    [self.audioClip.audioClip getDataInBackgroundWithBlock:^(NSData * data, NSError * error){
    
        self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        
        [self.player setDelegate:self];
        
        self.player.meteringEnabled= YES;
    
    
    }];
    
    
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    

    
    
    
    
    [self.mySwitch setOn:self.audioClip.isPublic];

    
    self.infoTextField.text = self.audioClip.audioClipName;
    
    if (self.audioClip.isPublic){
        
            self.shareLabel.text = @"Share";
            self.shareLabel.alpha = 1.0;
            self.shareLabel.textColor = [UIColor colorWithRed:0.267 green:0.843 blue:0.659 alpha:1.0];

        }
    
    else {
        
            self.shareLabel.text = @"Share";
            self.shareLabel.alpha = 0.5;
            self.shareLabel.textColor = [UIColor darkGrayColor];

    }

}

    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (IBAction)play:(id)sender {
    
    [self.player play];
}

- (IBAction)shareSwitch:(id)sender {
    
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

- (IBAction)textCheck:(id)sender {
    
    
    
    if (self.infoTextField.text.length < 2 ){
       
        self.uploadButton.alpha = 0.25;
        self.uploadButton.enabled = NO;
        self.mySwitch.enabled = NO;
    }
}

- (IBAction)textChanged:(id)sender {
    
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
- (IBAction)uploadProgress:(id)sender {
    
    self.uploadButton.backgroundColor = [UIColor colorWithRed:0.992 green:0.322 blue:0.251 alpha:1.0];

}
- (IBAction)backToRecord:(id)sender {
    
    self.audioClip.isPublic = self.mySwitch.isOn;
    
    self.audioClip.audioClipName = self.infoTextField.text;
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)upload:(id)sender {
    
    self.audioClip.isPublic = self.mySwitch.isOn;
    
    self.audioClip.audioClipName = self.infoTextField.text;

    [self.audioClip saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];

//    sleep(2);
}

- (IBAction)delete:(id)sender {

    [self.audioClip deleteInBackgroundWithBlock:^(BOOL succeded, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"goBack"]) {
        
        [self.player stop];
        
        CaptureViewController *destination= segue.destinationViewController;
        
        destination.audioClip = self.audioClip;
        
    }
    
}

@end
