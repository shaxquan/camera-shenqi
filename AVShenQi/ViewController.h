//
//  ViewController.h
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *captureBtn;


- (IBAction)capture:(id)sender;
@end
