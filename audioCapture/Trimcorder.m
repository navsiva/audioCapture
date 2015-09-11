//
//  Trimcorder.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-31.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "Trimcorder.h"
#import "CaptureViewController.h"
#import <Parse/Parse.h>

@interface Trimcorder ()

@property (nonatomic, strong) AVAssetTrack *track;

@end

@implementation Trimcorder

-(instancetype)initWithAudioClip:(AudioClip *)audioClip
{
    self = [super init];
    if (self) {
        
//        [self setupAudio];

        
        self.audioClip = audioClip;
        
        
        
    }
    return self;
}

//-(void)setupAudio {
//    
//    if (self.audioClip.isDataAvailable){
//        
//        [self.audioClip.audioClip getDataInBackgroundWithBlock:^(NSData * data, NSError * error){
//            
//            NSData *audioData = data;
//
//            
//        }];
//        
//    } else {
//        
//            NSString *trimAudioURL = self.audioClip.localURLString;
//        
//    }
//    
//}

//- (BOOL)exportAsset:(AVAsset *)avAsset toFilePath:(NSString *)filePath {
//    
////    AVAssetTrack *track = 
//
//    
//    AVAssetExportSession *exportSession = [AVAssetExportSession
//                                           exportSessionWithAsset:avAsset
//                                           presetName:AVAssetExportPresetAppleM4A];
//    if (nil == exportSession) return NO;
//    
//    // create trim time range - 20 seconds starting from 30 seconds into the asset
//    CMTime startTime = CMTimeMake(30, 1);
//    CMTime stopTime = CMTimeMake(50, 1);
//    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
//    
//    // create fade in time range - 10 seconds starting at the beginning of trimmed asset
//    CMTime startFadeInTime = startTime;
//    CMTime endFadeInTime = CMTimeMake(40, 1);
//    CMTimeRange fadeInTimeRange = CMTimeRangeFromTimeToTime(startFadeInTime,
//                                                            endFadeInTime);
//    
//    // setup audio mix
//    AVMutableAudioMix *exportAudioMix = [AVMutableAudioMix audioMix];
//    AVMutableAudioMixInputParameters *exportAudioMixInputParameters =
//    [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:self.track];
//    
//    [exportAudioMixInputParameters setVolumeRampFromStartVolume:0.0 toEndVolume:1.0
//                                                      timeRange:fadeInTimeRange];
//    exportAudioMix.inputParameters = [NSArray
//                                      arrayWithObject:exportAudioMixInputParameters];
//    
//    // configure export session  output with all our parameters
//    exportSession.outputURL = [NSURL fileURLWithPath:filePath]; // output path
//    exportSession.outputFileType = AVFileTypeAppleM4A; // output file type
//    exportSession.timeRange = exportTimeRange; // trim time range
//    exportSession.audioMix = exportAudioMix; // fade in audio mix
//    
//    // perform the export
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//        
//        if (AVAssetExportSessionStatusCompleted == exportSession.status) {
//            NSLog(@"AVAssetExportSessionStatusCompleted");
//        } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
//            // a failure may happen because of an event out of your control
//            // for example, an interruption like a phone call comming in
//            // make sure and handle this case appropriately
//            NSLog(@"AVAssetExportSessionStatusFailed");
//        } else {
//            NSLog(@"Export Session Status: %ld", (long)exportSession.status);
//        }
//    }];
//}

//    
//    PFQuery *query = [PFQuery queryWithClassName:@"poo"];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error){
//        
//        [self.controller trimcorderGOtData:results];
//    
//    }];    
//    
    
//    return YES;
//}




@end


