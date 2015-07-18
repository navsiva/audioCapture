//
//  UploadTableViewController.h
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-13.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioClip.h"
#import "CaptureViewController.h"
#import "LogTableViewCell.h"



@interface UploadTableViewController : UITableViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playButton;


@property (weak, nonatomic) IBOutlet UITextField *infoTextField;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) AudioClip *audioClip;

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

@end
