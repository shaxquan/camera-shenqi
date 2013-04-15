//
//  Asteroid.m
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import "Asteroid.h"
#import "CaptureViewController.h"

@implementation Asteroid
@synthesize imageNumber;
@synthesize imageVariant;

+ (id)asteroid:(CaptureViewController *)controller {
    CGSize gameAreaSize = [controller gameAreaSize];

    float radius = arc4random()%8+8;
    float x = radius + arc4random()%(int)(gameAreaSize.width + radius*2);
    CGPoint center = CGPointMake(x, -radius);

    Asteroid *asteroid = [[Asteroid alloc] initAt:center WithRadius:radius AndImage:nil];

    float speed = (arc4random()%10)/10.0 + .1;
    [asteroid setSpeed:speed];

    NSString *imageVariant = [[Asteroid imageNameVariations] objectAtIndex:arc4random()%3];
    [asteroid setImageVariant:imageVariant];

    return asteroid;
}

+(NSMutableArray*)imageNameVariations{
    if (imageNameVariations == nil){
        imageNameVariations = [NSMutableArray new];
        [imageNameVariations addObject:@"Asteroid_A"];
        [imageNameVariations addObject:@"Asteroid_B"];
        [imageNameVariations addObject:@"Asteroid_C"];
    }
    return imageNameVariations;
}
-(NSString*)imageName{
    return [[imageVariant stringByAppendingString:@"_"] stringByAppendingString:[NSString stringWithFormat:@"%04d", self.imageNumber]];
}

-(void)step:(CaptureViewController*)controller{
    if ([controller stepNumber]%2 == 0){
        self.imageNumber = imageNumber+1;
        if (self.imageNumber > NUMBER_OF_IMAGES) {
            self.imageNumber = 1;
        }
        self.needsImageUpdated = YES;
    } else {
        self.needsImageUpdated = NO;
    }

    CGPoint newCenter = self.center;
    newCenter.y += self.speed;
    self.center = newCenter;

    if (newCenter.y - self.radius > controller.gameAreaSize.height){
        [controller removeActor: self];
    }
}


@end
