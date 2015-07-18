//
//  AudioClip.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-15.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "AudioClip.h"
#import <Parse/PFObject+Subclass.h>


@implementation AudioClip

@dynamic audioClip;
@dynamic audioClipDetails;
@dynamic audioClipName;
@dynamic audioClipLocation;
@dynamic audioClipTag;
@dynamic createdAt;
@dynamic objectId;
@dynamic localURLString;
@dynamic creator;
@dynamic isPublic;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"AudioClip";
}
@end
