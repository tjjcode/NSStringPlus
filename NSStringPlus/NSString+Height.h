//
//  NSString+Height.h
//  NSStringPlus
//
//  Created by ZK on 15/5/27.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Height)

@property(nonatomic, assign) CGFloat characterSpacing; //字间距
@property(nonatomic, assign) CGFloat    linesSpacing; //行间距
@property(nonatomic, assign) CGFloat paragraphSpacing; //段间距

@property (nonatomic, strong) NSMutableAttributedString *attributedString;

- (CGFloat)getStringHeightByWidth:(CGFloat)width font:(UIFont *)font;
- (NSMutableAttributedString *)setupAttributedStringWithFont:(UIFont *)font;
@end
