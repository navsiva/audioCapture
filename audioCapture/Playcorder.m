//
//  Playcorder.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-28.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "Playcorder.h"


@interface Playcorder ()

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) AVAudioPlayer *player;


@end


@implementation Playcorder

-(instancetype)initWithAudioClip:(AudioClip *)audioClip
{
    self = [super init];
    if (self) {
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
 
        self.audioClip = audioClip;
        
        [self setupPlayer];
        
        [self setupRecorder];
    
        
    }
    return self;
}

-(void)record {
    
    
    [self stop];
    
    [self.recorder record];
    
    self.shouldLoop = NO;


    
}

-(void)play {
    
    
    self.player.numberOfLoops = 0;
    

    [self.player play];
    
    
}

-(void)stop {
    
    if (self.player.isPlaying){
    
        [self.player stop];
        
        self.player.numberOfLoops = 0;

        
    
    } else if (self.recorder.isRecording){
        
    [self.recorder stop];

        
    //create the parse file
    AudioClip *audioClip = [[AudioClip alloc] init];
    NSData *audioData = [NSData dataWithContentsOfURL:self.recorder.url];
    
    PFFile *audioFile = [PFFile fileWithName:@"MyAudioMemo.m4a" data:audioData];
    audioClip.audioClip = audioFile;
    
    //set parse file to author as cretor
    audioClip.creator = [PFInstallation currentInstallation];
    
    //set playfile location to parse url
    audioClip.localURLString = [self.recorder.url absoluteString];
        
    //save locally to parse
    [audioClip pinInBackground];
    
    self.audioClip = audioClip;
    
    //creating a new player
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
    
    [self.player setDelegate:self];
    
    self.player.meteringEnabled = YES;
    
    }
    
}

-(void)pause {
    
    [self.recorder pause];
    
    [self.player pause];
    
}

-(void)loop {
    
    
    self.player.enableRate = YES;
    
    self.player.numberOfLoops = -1;
    
    self.player.rate = 1.0f;
    
    [self.player play];
}

-(void)canRecord {
    
    if ((self.audioClip.isDataAvailable) || (self.recorder.isRecording)){
        
        self.shouldRecord = NO;
    }
    
    else {
        
        self.shouldRecord = YES;
    
    }
   
}

-(void)canPlay {
    
    

    
    if (self.audioClip.isDataAvailable) {
        
        self.shouldLoop = YES;
    }
    else {
        
        self.shouldLoop = NO;
    }
    
}



-(void)setupRecorder {
    
    if (!self.audioClip.isDataAvailable){

    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"MyAudioMemo.m4a", nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    
    }

}

-(double)getDuration {
    
    NSURL *audioClipLocation = self.player.url;
    NSError *error = nil;
    AVAudioPlayer* avAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:audioClipLocation error:&error];
    
    double duration = avAudioPlayer.duration;
    avAudioPlayer = nil;

    return duration;
    
    
}


-(void)setupPlayer {
    
    if (self.audioClip.isDataAvailable){
        
        [self.audioClip.audioClip getDataInBackgroundWithBlock:^(NSData * data, NSError * error){
            
            self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
            
            [self.player setDelegate:self];
            
            self.player.meteringEnabled= YES;
        }];
        
    }
    
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    
    
}

-(CGFloat)meterValue {
    
    CGFloat normalizedValue;

    
    if ([self.recorder isRecording]) {
        
        [self.recorder updateMeters];
        normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.recorder averagePowerForChannel:0]];

    } else {
        [self.player updateMeters];
        normalizedValue = [self _normalizedPowerLevelFromDecibels:[self.player averagePowerForChannel:0]];
        
    }
    
    return normalizedValue;
    
    
}

- (CGFloat)_normalizedPowerLevelFromDecibels:(CGFloat)decibels
{
    if (decibels < -60.0f || decibels == 0.0f) {
        return 0.0f;
    }
    
    return powf((powf(10.0f, 0.05f * decibels) - powf(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powf(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
}






@end


