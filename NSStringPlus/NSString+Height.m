//
//  NSString+Height.m
//  NSStringPlus
//
//  Created by ZK on 15/5/27.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "NSString+Height.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

static void *characterSpacingKey = &characterSpacingKey;
static void *linesSpacingKey = &linesSpacingKey;
static void *paragraphSpacingKey = &paragraphSpacingKey;
static void *attributedStringKey = &attributedStringKey;
const NSString *stringKey = @"stringKey";

@interface NSString ()

//@property (nonatomic, strong) NSMutableAttributedString *attributedString;

@end

@implementation NSString (Height)

- (NSMutableAttributedString *)attributedString
{
    return objc_getAssociatedObject(self, attributedStringKey);
}

- (void)setAttributedString:(NSMutableAttributedString *)attributedString
{
    objc_setAssociatedObject(self, attributedStringKey, attributedString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 使用运行时给NSString添加3个属性
//characterSpacing的set和get方法
- (CGFloat)characterSpacing
{
    NSNumber *characterSpacingNumber = objc_getAssociatedObject(self, characterSpacingKey);
    if (!characterSpacingNumber) {
        return 0;
    } else{
        return [characterSpacingNumber floatValue];
    }
}

- (void)setCharacterSpacing:(CGFloat)characterSpacing
{
    
    objc_setAssociatedObject(self, characterSpacingKey, [NSNumber numberWithFloat:characterSpacing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//linesSpacing的set和get方法
- (CGFloat)linesSpacing
{
    NSNumber *linesSpacingNumber = objc_getAssociatedObject(self, linesSpacingKey);
    if (!linesSpacingKey) {
        return 0;
    } else{
        return [linesSpacingNumber floatValue];
    }
}

- (void)setLinesSpacing:(CGFloat)linesSpacing
{
    objc_setAssociatedObject(self, linesSpacingKey, [NSNumber numberWithFloat:linesSpacing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

//paragraphSpacing的set和get方法
- (CGFloat)paragraphSpacing
{
    NSNumber *paragraphSpacingNumber = objc_getAssociatedObject(self, paragraphSpacingKey);
    if (!paragraphSpacingKey) {
        return 0;
    } else{
        return [paragraphSpacingNumber floatValue];
    }
}

- (void)setParagraphSpacing:(CGFloat)paragraphSpacing
{
    objc_setAssociatedObject(self, paragraphSpacingKey, [NSNumber numberWithFloat:paragraphSpacing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)getStringHeightByWidth:(CGFloat)width font:(UIFont *)font
{
    [self setupAttributedStringWithFont:font];
    
    CGFloat total_height;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    CGRect drawingRect = CGRectMake(0, 0, width, 10000);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *)CTFrameGetLines(textFrame);
    CGPoint origins[linesArray.count];

    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    CGFloat line_y = origins[linesArray.count-1].y; //最后一行line的原点y坐标
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef)([linesArray objectAtIndex:[linesArray count]-1]);
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    total_height = 10000 - line_y + descent;
    
    CFRelease(textFrame);
    return total_height;
}

- (NSMutableAttributedString *)setupAttributedStringWithFont:(UIFont *)font
{
    if (self.attributedString == nil) {
        
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:self];
        //设置字体及大小
        CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)font.fontName, 16, NULL);
        
        [self.attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0, self.attributedString.length)];
        if ([NSParagraphStyle class]) {
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.lineSpacing = self.linesSpacing;
            paragraph.paragraphSpacing = self.paragraphSpacing;
            paragraph.alignment = NSTextAlignmentLeft;
            [self.attributedString addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:self.characterSpacing] range:NSMakeRange(0, self.attributedString.length)];
            [self.attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, self.attributedString.length)];
        }else
        {
            
            //设置字间距
            CGFloat characterSpacing = self.characterSpacing;
            CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &characterSpacing);
            [self.attributedString addAttribute:(NSString *)kCTKernAttributeName value:(__bridge id)(num) range:NSMakeRange(0, self.attributedString.length)];
            CFRelease(num);
            
            //        //设置字体颜色
            //        if (color == nil) {
            //            color = [UIColor blackColor];
            //        }
            //        [self.attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)color.CGColor range:NSMakeRange(0, self.attributedString.length)];
            
            //创建文本对齐方式
            CTTextAlignment alignment = kCTLeftTextAlignment;
            CTParagraphStyleSetting alignmentStyle;
            alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
            alignmentStyle.valueSize = sizeof(alignment);
            alignmentStyle.value = &alignment;
            
            //设置文本行间距
            CGFloat linesSpacing = self.linesSpacing;
            CTParagraphStyleSetting linesSpaceStyle;
            linesSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;
            linesSpaceStyle.valueSize = sizeof(linesSpacing);
            linesSpaceStyle.value = &linesSpacing;
            
            //        //设置文本断行模式
            //        CTParagraphStyleSetting lineBreakMode;
            //        lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
            //        lineBreakMode.valueSize = sizeof(lineBreakMode);
            //        lineBreakMode.value = 0;
            
            //设置文本段间距
            CGFloat paragraphSpacings = self.paragraphSpacing;
            CTParagraphStyleSetting paragraphSpaceStyle;
            paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
            paragraphSpaceStyle.valueSize = sizeof(CGFloat);
            paragraphSpaceStyle.value = &paragraphSpacings;
            
            //创建设置数组
            CTParagraphStyleSetting setting[] = {alignmentStyle, linesSpaceStyle, paragraphSpaceStyle};
            CTParagraphStyleRef style = CTParagraphStyleCreate(setting, 3);
            
            //给文本添加设置
            [self.attributedString addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)(style) range:NSMakeRange(0, self.attributedString.length)];
            CFRelease(helveticaBold);
        }
    }
    return self.attributedString;
}
@end
