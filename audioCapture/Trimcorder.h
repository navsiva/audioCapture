//
//  Trimcorder.h
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-31.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioClip.h"


@protocol TrimcorderDelegate<NSObject>

@end

@class CaptureViewController;


@interface Trimcorder : NSObject<AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) AudioClip *
audioClip;

@property (nonatomic, strong) id<TrimcorderDelegate> controller;

-(instancetype)initWithAudioClip:(AudioClip *)audioClip;


@end