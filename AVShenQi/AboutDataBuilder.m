//
//  AboutDataBuilder.m
//  AVShenQi
//
//  Created by shaxquan  on 2/27/13.
//  Copyright (c) 2013 shaxquan . All rights reserved.
//

#import "AboutDataBuilder.h"

@implementation AboutDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"设置";
    root.grouped = YES;
    QSection *section1 = [[QSection alloc] init];
    [section1 addElement:[self createHelpRoot]];
    
    
    
    QButtonElement *rateBtn = [[QButtonElement alloc] initWithTitle:@"评价这个软件"];
    rateBtn.controllerAction = @"rateMe:";
    QSection *section2 = [[QSection alloc] init];
    [section2 addElement:rateBtn];

    
    

    
    QSection *section3 = [[QSection alloc] init];
    QLabelElement *label = [[QLabelElement alloc] initWithTitle:@"版本" Value:@"1.0"];
    [section3 addElement:label];
    
    
    [root addSection:section2];
    
    [root addSection:section1];
    
    [root addSection:section3];
    
    
    return root;
}

+ (QRootElement *)createHelpRoot {
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"帮助";
    
    QTextElement *element1 = [[QTextElement alloc] initWithText:
                              @"该软件是用来抓拍图片的,所以在使用前请关闭iPhone的声音,以免发生不愉快的事情.点击开始游戏后可进入游戏，单击界面来移动飞机躲避陨石，双击屏幕可拍摄照片，默认为后置摄像头,照片保存在iPhone的照片库中.向右滑动屏幕手势可退出游戏界面.\n\n\n"
                              "该软件为个人独立完成，如果喜欢请您给个好评，您的支持是对作者最大的鼓励."];//或者点击应用中广告
    
    QTextElement *element2 = [[QTextElement alloc] initWithText:@"请静音"];
    element2.font = [UIFont fontWithName:@"Cochin_Bold" size:18];
    element2.color = [UIColor redColor];

    QTextElement *element3 = [[QTextElement alloc] initWithText:@"               使用帮助!"];
    element3.font = [UIFont fontWithName:@"Cochin-Bold" size:24];
    element3.color = [UIColor blueColor];
    
    QSection *section1 = [[QSection alloc] init];
    [section1 addElement:element3];
    [section1 addElement:element2];
    [section1 addElement:element1];
    [root addSection:section1];
    return root;
}

@end
