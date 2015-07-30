//
//  AudioClip.h
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-15.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import <Parse/Parse.h>

@interface AudioClip : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (nonatomic, strong) NSString *audioClipName;
@property (nonatomic, strong) NSString *audioClipDetails;
@property (nonatomic, strong) PFFile *audioClip;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *localURLString;
@property (nonatomic, strong) PFInstallation *creator;

@property (assign) BOOL isPublic;
@property (assign) BOOL isEditable;



@end
