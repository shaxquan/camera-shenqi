//
//  CaptureViewController.m
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import "CaptureViewController.h"
#import "GCDiscreetNotificationView.h"

@interface CaptureViewController ()

@end

@implementation CaptureViewController
@synthesize gameAreaSize;
@synthesize stepNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    UISwipeGestureRecognizer *swipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [swipGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipGestureRecognizer];
    [swipGestureRecognizer release];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(captureStillImage)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    [doubleTapGestureRecognizer release];

    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
//    self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;


    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){
        
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device setFlashMode:AVCaptureFlashModeOff];
        [device unlockForConfiguration];
    }
    
    NSError *error = nil;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (self.videoInput) {
        [self.captureSession addInput:self.videoInput];
    }
    else
    {
        NSLog(@"Input Error: %@", error);
    }

    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *stillImageOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:stillImageOutputSettings];
    [self.captureSession addOutput:self.stillImageOutput];
    [stillImageOutputSettings release];


    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    UIView *aView = self.view;
    previewLayer.frame = self.view.frame;//CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-70);
    [aView.layer addSublayer:previewLayer];


    // Do any additional setup after loading the view from its nib.
    


    [self setGameAreaSize:CGSizeMake(160, 240)];
    actors = [NSMutableArray new];
    actorViews = [NSMutableDictionary new];
    toBeRemoved = [NSMutableArray new];

    Actor* background = [[Actor alloc] initAt:CGPointMake(80, 120) WithRadius:120 AndImage:@"star_field_iphone"];
    [self addActor: background];

    viper = [Viper viper:self];
    [self addActor:viper];

    self.stepNumber = 0;

    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer setNumberOfTouchesRequired:1];

    [actorView addGestureRecognizer:tapRecognizer];
    actorView.backgroundColor = [UIColor clearColor];

    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScene)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    [self.view bringSubviewToFront:actorView];



}

-(void)addActor:(Actor*)actor{
    [actors addObject:actor];
}


-(void)removeActor:(Actor*)actor{
    [toBeRemoved addObject:actor];
}
-(void)doRemove{
    for (Actor* actor in toBeRemoved){
        UIImageView* imageView = [actorViews objectForKey:[actor actorId]];
        [actorViews removeObjectForKey:actor];

        [imageView removeFromSuperview];

        [actors removeObject:actor];
    }
    [toBeRemoved removeAllObjects];
}
-(void)updateScene {
    if (stepNumber % (60*5) == 0){
        [self addActor:[Asteroid asteroid:self]];
    }

    for (Actor* actor in actors){
        [actor step:self];
    }

    for (Actor* actor in actors){
        if ([actor isKindOfClass:[Asteroid class]]){
            if ([viper overlapsWith:actor]){
                [viper doCollision:actor In:self];
                break;
            }
        }
    }

    for (Actor* actor in actors){
        [self updateActorView:actor];
    }
    [self doRemove];
    stepNumber++;
}


-(void)updateActorView:(Actor*)actor{
    UIImageView* imageView = [actorViews objectForKey:[actor actorId]];

    if (imageView == nil){
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[actor imageName]]];
        [actorViews setObject:imageView forKey:[actor actorId]];
        [imageView setFrame:CGRectMake(0, 0, 0, 0)];
        [actorView addSubview:imageView];
    } else {
        if ([actor needsImageUpdated]){
            [imageView setImage:[UIImage imageNamed:[actor imageName]]];
        }

    }

    float xFactor = actorView.frame.size.width/self.gameAreaSize.width;
    float yFactor = actorView.frame.size.height/self.gameAreaSize.height;

    float x = (actor.center.x-actor.radius)*xFactor;
    float y = (actor.center.y-actor.radius)*yFactor;
    float width = actor.radius*xFactor*2;
    float height = actor.radius*yFactor*2;
    CGRect frame = CGRectMake(x, y, width, height);

    imageView.transform = CGAffineTransformIdentity;
    [imageView setFrame:frame];
    imageView.transform = CGAffineTransformRotate(imageView.transform, [actor rotation]);

}

- (void)tapGesture:(UIGestureRecognizer *)gestureRecognizer{
    UITapGestureRecognizer* tapRecognizer = (UITapGestureRecognizer*)gestureRecognizer;

    CGPoint pointOnView = [tapRecognizer locationInView:actorView];

    float xFactor = actorView.frame.size.width/self.gameAreaSize.width;
    float yFactor = actorView.frame.size.height/self.gameAreaSize.height;

    CGPoint pointInGame = CGPointMake(pointOnView.x/xFactor, pointOnView.y/yFactor);

    [viper setMoveToPoint:pointInGame];
    [viper setState:STATE_TURNING];
}


- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

- (void)captureStillImage
{
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput.connections objectAtIndex:0];
    if ([stillImageConnection isVideoOrientationSupported])
    {
        [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }

    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL)
        {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];

            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error) {
                
                NSString *messegeText;
                if (!error)
                {
                    messegeText = [NSString stringWithFormat:@"%@", @"保存成功"];
                }
                else
                {
                    messegeText = [NSString stringWithFormat:@"%@", @"保存错误"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您禁止了爱拍保存相片到iPhone上，您可以在设置中的隐私中开启允许存储相片" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                }
                
                GCDiscreetNotificationView *notificationView = [[[GCDiscreetNotificationView alloc] initWithText:messegeText
                                                                                                   showActivity:NO
                                                                                             inPresentationMode:GCDiscreetNotificationViewPresentationModeTop
                                                                                                         inView:self.view] autorelease];
                [notificationView showAndDismissAfter:10];
                
            }];
            [image release];
            [library release];
        }
        else
        {
            NSLog(@"Error capturing still image: %@", error);
        }
    }];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_captureSession release];
    [_stillImageOutput release];
    NSLog(@"CaptureViewController Dealloc");
    [actorView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [actorView release];
    actorView = nil;
    [super viewDidUnload];
}
@end
