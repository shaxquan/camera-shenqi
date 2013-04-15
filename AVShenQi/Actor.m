//
//  Actor.m
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import "Actor.h"

@implementation Actor
@synthesize actorId;
@synthesize center;
@synthesize rotation;
@synthesize speed;
@synthesize radius;
@synthesize imageName;
@synthesize needsImageUpdated;

- (id)initAt:(CGPoint)aPoint WithRadius:(float)aRadius AndImage:(NSString *)anImageName {
    self = [super init];
    if (self != nil) {
        [self setActorId:[NSNumber numberWithLong:nextId++]];
        [self setCenter:aPoint];
        [self setRotation:0];
        [self setRadius:aRadius];
        [self setImageName:anImageName];
    }
    return self;
}

- (void)step:(CaptureViewController *)controller {
    //implemented by subclasses.
}

- (BOOL)overlapsWith:(Actor *)actor {
    float xdist = abs(self.center.x - actor.center.x);
    float ydist = abs(self.center.y - actor.center.y);
    float distance = sqrtf(xdist*xdist + ydist*ydist);
    return distance < self.radius + actor.radius;
}

@end
