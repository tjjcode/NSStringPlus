//
//  ViewController.m
//  NSStringPlus
//
//  Created by ZK on 15/5/27.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Height.h"
#define FRONTWITHSIZE(frontSize) [UIFont fontWithName:@"MicrosoftYaHei" size:frontSize]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * str = [NSString stringWithFormat:@"%@", @"这是一个自定义间距的Label，这是一个自定义间距的Label，这是一个自定义间距的Label。"];
    str = [NSString stringWithFormat:@"%@\n%@", str, str];
    str.characterSpacing = 5;
    NSLog(@"%f", str.characterSpacing);
    str.linesSpacing = 10.0;
    NSLog(@"%f", str.linesSpacing);
    str.paragraphSpacing = 30.0;
    NSLog(@"%f", str.paragraphSpacing);
    CGFloat height = [str getStringHeightByWidth:290 font:FRONTWITHSIZE(16)];
    NSLog(@"%f", height);
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 290, height)];
//    lable.attributedText = [str setupAttributedStringWithFont:FRONTWITHSIZE(16)];
    lable.numberOfLines = 0;
    NSMutableAttributedString *attribSting = str.attributedString;
    lable.attributedText = attribSting;
    lable.backgroundColor = [UIColor greenColor];
    [self.view addSubview:lable];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
