//
//  NSAlertView.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "NSAlertView.h"

@implementation NSAlertView
+(void)alert:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

+(void)initLabelView:(UIView*)insertView
               frame:(CGRect)frame
                text:(NSString*)string
                font:(float)font
           alignment:(NSTextAlignment)alignment
           isNumLine:(BOOL)numLine
           textColor:(UIColor *)color
{
    UILabel *lab = [[UILabel alloc]initWithFrame:frame];
    lab.text = string;
    lab.font = [UIFont systemFontOfSize:font];
    lab.textAlignment = alignment;
    lab.textColor = color;
    if (numLine) {
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines = 0;
    }
    [insertView addSubview:lab];
}

+(void)initLabelView:(UIView*)insertView
               frame:(CGRect)frame
                text:(NSString*)string
                font:(float)font
           alignment:(NSTextAlignment)alignment
           isNumLine:(BOOL)numLine
{
    UILabel *lab = [[UILabel alloc]initWithFrame:frame];
    lab.text = string;
    lab.font = [UIFont systemFontOfSize:font];
    lab.textAlignment = alignment;
    if (numLine) {
        lab.lineBreakMode = NSLineBreakByWordWrapping;
        lab.numberOfLines = 0;
    }
    [insertView addSubview:lab];

}
+(void)addAnimation:(UIView*)view push:(BOOL)push
{
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 1.0f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    if (push) {
        transition.subtype = kCAGravityTopRight;
    }
    else
    {
        transition.subtype = kCAGravityTopLeft;
    }
    
    [view.layer addAnimation:transition forKey:nil];
}
//字符串转颜色
+(UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
/*
 功能：将要请求的数据转换成jsonString
 输入：objectAry：NSMutableDictionary的object  keyAry：NSMutableDictionary的key
 返回：jsonString
 */
+ (NSString*)param:(NSArray*)objectAry forKey:(NSArray*)keyAry
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    for (int i = 0; i < keyAry.count; i++) {
        
        [dic setValue:[objectAry objectAtIndex:i] forKey:[keyAry objectAtIndex:i]];
    }
    
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return string;
}

@end
