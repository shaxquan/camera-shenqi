//
//  CaptureViewController.h
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Viper.h"
#import "Actor.h"
#import "Asteroid.h"

@interface CaptureViewController : UIViewController {
    IBOutlet UIView *actorView;
    CADisplayLink *displayLink;
    
    //Managing Actors
    NSMutableArray *actors;
    NSMutableDictionary *actorViews;
    NSMutableArray *toBeRemoved;

    //Game Logic
    Viper *viper;
}

@property (nonatomic) long stepNumber;
@property (nonatomic) CGSize gameAreaSize;



@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;


-(void)updateScene;
-(void)removeActor:(Actor*)actor;
-(void)addActor:(Actor*)actor;
-(void)updateActorView:(Actor*)actor;
-(void)tapGesture:(UIGestureRecognizer *)gestureRecognizer;
-(void)doRemove;
@end
