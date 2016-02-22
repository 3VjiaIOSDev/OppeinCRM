//
//  NSAlertView.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAlertView : NSObject

+(void)alert:(NSString*)message;

+(void)addAnimation:(UIView*)view push:(BOOL)push;

+(void)initLabelView:(UIView*)insertView
               frame:(CGRect)frame
                text:(NSString*)string
                font:(float)font
           alignment:(NSTextAlignment)alignment
           isNumLine:(BOOL)numLine
           textColor:(UIColor *)color;

+(void)initLabelView:(UIView*)insertView
               frame:(CGRect)frame
                text:(NSString*)string
                font:(float)font
           alignment:(NSTextAlignment)alignment
           isNumLine:(BOOL)numLine;
//字符串转颜色
+(UIColor *) colorWithHexString: (NSString *) stringToConvert;
//将要请求的数据转换成jsonString
+ (NSString*)param:(NSArray*)objectAry forKey:(NSArray*)keyAry;


@end
