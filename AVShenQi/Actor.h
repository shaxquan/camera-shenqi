//
//  Actor.h
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import <Foundation/Foundation.h>

@class CaptureViewController;
long nextId;

@interface Actor : NSObject {

}
@property (nonatomic, strong) NSNumber *actorId;
@property (nonatomic) CGPoint center;
@property float rotation;
@property (nonatomic) float speed;
@property (nonatomic) float radius;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic) BOOL needsImageUpdated;

- (id)initAt:(CGPoint)aPoint WithRadius:(float)aRadius AndImage:(NSString *)anImageName;
- (void)step:(CaptureViewController *)controller;
- (BOOL)overlapsWith:(Actor *)actor;

@end
