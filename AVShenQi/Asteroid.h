//
//  Asteroid.h
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"

@class CaptureViewController;

#define NUMBER_OF_IMAGES 31

NSMutableArray *imageNameVariations;
@interface Asteroid : Actor

@property (nonatomic) int imageNumber;
@property (nonatomic, strong) NSString *imageVariant;

+ (NSMutableArray *)imageNameVariations;
+ (id)asteroid:(CaptureViewController *)controller;
@end
