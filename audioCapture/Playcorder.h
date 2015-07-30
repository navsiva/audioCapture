//
//  Playcorder.h
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-28.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioClip.h"
#import <Parse/Parse.h>




@interface Playcorder : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AudioClip *
audioClip;



@property (assign) BOOL shouldRecord;

@property (assign) BOOL shouldLoop;

-(void)play;

-(void)record;

-(void)stop;

-(void)pause;

-(void)loop;

-(void)canRecord;

-(void)canPlay;

-(CGFloat)meterValue;

-(instancetype)initWithAudioClip:(AudioClip *)audioClip;


@end


