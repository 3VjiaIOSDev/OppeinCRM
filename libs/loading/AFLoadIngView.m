//
//  AFLoadIngView.m
//  Test1
//
//  Created by 3Vjia on 15/11/4.
//  Copyright © 2015年 3Vjia. All rights reserved.
//
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "AFLoadIngView.h"

@implementation AFLoadIngView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f];
        NSArray *myImages = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"progress_1.png"],
                             [UIImage imageNamed:@"progress_2.png"],
                             [UIImage imageNamed:@"progress_3.png"],
                             [UIImage imageNamed:@"progress_4.png"],
                             [UIImage imageNamed:@"progress_5.png"],
                             [UIImage imageNamed:@"progress_6.png"],
                             [UIImage imageNamed:@"progress_7.png"],
                             [UIImage imageNamed:@"progress_8.png"],nil];
        
        UIImageView *myAnimatedView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-26.5, self.frame.size.height/2-26.5, 53, 53)];
        myAnimatedView.animationImages = myImages; //animationImages属性返回一个存放动画图片的数组
        myAnimatedView.animationDuration = 0.5; //浏览整个图片一次所用的时间
        myAnimatedView.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
        [myAnimatedView startAnimating];
        [self addSubview:myAnimatedView];
    }
    return self;
}
-(id)initWithLoading
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}
-(void)initUI
{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f];
    
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"progress_1.png"],
                         [UIImage imageNamed:@"progress_2.png"],
                         [UIImage imageNamed:@"progress_3.png"],
                         [UIImage imageNamed:@"progress_4.png"],
                         [UIImage imageNamed:@"progress_5.png"],
                         [UIImage imageNamed:@"progress_6.png"],
                         [UIImage imageNamed:@"progress_7.png"],
                         [UIImage imageNamed:@"progress_8.png"],nil];
    
    UIImageView *myAnimatedView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-26.5, self.frame.size.height/2-26.5, 53, 53)];
    myAnimatedView.animationImages = myImages; //animationImages属性返回一个存放动画图片的数组
    myAnimatedView.animationDuration = 0.5; //浏览整个图片一次所用的时间
    myAnimatedView.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
    [myAnimatedView startAnimating];
    [self addSubview:myAnimatedView];
    
}
-(void)show
{
    [self initUI];
}

-(void)dismiss
{
    [self removeFromSuperview];
}
@end
