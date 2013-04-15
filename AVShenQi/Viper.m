//
//  Viper.m
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import "Viper.h"
#import "CaptureViewController.h"

@implementation Viper
@synthesize moveToPoint;
@synthesize state;
@synthesize clockwise;

+(id)viper:(CaptureViewController*)controller{

    CGSize gameAreaSize = [controller gameAreaSize];
    CGPoint center = CGPointMake(gameAreaSize.width/2, gameAreaSize.height/2);

    Viper* viper = [[Viper alloc] initAt:center WithRadius:12 AndImage:@"viper"];
    [viper setMoveToPoint:center];
    [viper setState:STATE_STOPPED];
    [viper setSpeed:.8];
    [viper setRotation:M_PI];

    return viper;
}
-(NSString*)imageName{
    if (self.state == STATE_STOPPED){
        return @"viper_stopped";
    } else if (self.state == STATE_TURNING){
        if (self.clockwise){
            return @"viper_clockwise";
        } else {
            return @"viper_counterclockwise";
        }
    } else {//STATE_TRAVELING
        return @"viper_traveling";
    }
}

-(void)step:(CaptureViewController*)controller{
    CGPoint c = [self center];
    if (self.state == STATE_STOPPED){
        if (abs(moveToPoint.x - c.x) < self.speed && abs(moveToPoint.y - c.y) < self.speed){
            c.x = moveToPoint.x;
            c.y = moveToPoint.y;
            [self setCenter:c];
        } else {
            self.state = STATE_TURNING;
            self.needsImageUpdated = YES;
        }
    } else if (self.state == STATE_TURNING){
        float dx = (moveToPoint.x - c.x);
        float dy = (moveToPoint.y - c.y);
        float theta = -atan(dx/dy);

        float targetRotation;

        if (dy > 0){
            targetRotation = theta + M_PI;
        } else {
            targetRotation = theta;
        }

        if ( fabsf(self.rotation - targetRotation) < .1){
            self.rotation = targetRotation;
            self.state = STATE_TRAVELING;
            self.needsImageUpdated = YES;
            return;
        }

        if (self.rotation - targetRotation < 0){
            self.rotation += .1;
            self.clockwise = YES;
            self.needsImageUpdated = YES;
        } else {
            self.rotation -= .1;
            self.clockwise = NO;
            self.needsImageUpdated = YES;
        }

    } else {//STATE_TRAVELING
        float dx = (moveToPoint.x - c.x);
        float dy = (moveToPoint.y - c.y);
        float theta = atan(dy/dx);

        float dxf = cos(theta) * self.speed;
        float dyf = sin(theta) * self.speed;

        if (dx < 0){
            dxf *= -1;
            dyf *= -1;
        }

        c.x += dxf;
        c.y += dyf;

        if (abs(moveToPoint.x - c.x) < self.speed && abs(moveToPoint.y - c.y) < self.speed){
            c.x = moveToPoint.x;
            c.y = moveToPoint.y;
            self.state = STATE_STOPPED;
            self.needsImageUpdated = YES;
        }

        [self setCenter:c];
    }
}

-(void)doCollision:(Actor*)actor In:(CaptureViewController*)controller{
    CGSize gameAreaSize = [controller gameAreaSize];
    CGPoint centerOfGame = CGPointMake(gameAreaSize.width/2, gameAreaSize.height/2);
    self.center = centerOfGame;
    self.moveToPoint = centerOfGame;
    self.state = STATE_STOPPED;
    self.rotation = 0;

    [controller removeActor:actor];
}



@end
