//
//  Viper.h
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import <Foundation/Foundation.h>

#define STATE_STOPPED 0
#define STATE_TURNING 1
#define STATE_TRAVELING 2

#import "Actor.h"

@class CaptureViewController;

@interface Viper : Actor


@property CGPoint moveToPoint;
@property int state;
@property BOOL clockwise;

+ (id)viper:(CaptureViewController *)controller;
- (void)doCollision:(Actor *)actor In:(CaptureViewController *)controller;
@end
