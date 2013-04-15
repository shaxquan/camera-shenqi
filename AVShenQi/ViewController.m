//
//  ViewController.m
//  AVShenQi
//
//  Created by shaxquan  on 2/20/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import "ViewController.h"
#import "CaptureViewController.h"

#define kFirstRun @"AVShenQi_FirstRun"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"游戏";
        self.tabBarItem.image = [UIImage imageNamed:@"GAME.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor clearColor];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_captureBtn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCaptureBtn:nil];
    [super viewDidUnload];
}
- (IBAction)capture:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isFirstRun = ![userDefault boolForKey:kFirstRun];
    if (isFirstRun) {
        [userDefault setBool:YES forKey:kFirstRun];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"这是你首次运行本软件，请确认你已经查看了帮助" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    CaptureViewController *viewController = [[CaptureViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
@end
