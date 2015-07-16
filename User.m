//
//  User.m
//  audioCapture
//
//  Created by Navaneethan Sivabalaviknarajah on 2015-07-16.
//  Copyright (c) 2015 Navaneethan Sivabalaviknarajah. All rights reserved.
//

#import "User.h"

@implementation User


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"User";
}

@end
