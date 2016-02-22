//
//  keyPoint.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/13.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "keyPoint.h"

#define screen_w [UIScreen mainScreen].bounds.size.width
#define screen_h [UIScreen mainScreen].bounds.size.height

@implementation keyPoint

-(id)initWithArray:(NSArray*)arr selectArr:(NSArray*)selectArr codeArr:(NSArray*)codeArr
{
    if (self = [super init]) {
        self.array = arr;
        self.selectArr = selectArr;
        self.keyArr = [[NSMutableArray alloc]initWithArray:self.selectArr];
        self.codeArr = [[NSMutableArray alloc]initWithArray:self.codeArr];
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.frame = CGRectMake(0, 0, screen_w, screen_h);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f];
    
    
    UIScrollView *scrView = [[UIScrollView alloc]initWithFrame:CGRectMake((screen_w-240)/2, (screen_h-300)/2, 240, 240)];
    scrView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:scrView];
    
    UIView *actionView = [[UIView alloc]initWithFrame:CGRectMake((screen_w-240)/2, CGRectGetMaxY(scrView.frame), 240, 40)];
    actionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:actionView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(35, 0, 50, 30);
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [actionView addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(155, 0, 50, 30);
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [actionView addSubview:doneBtn];
    
    
    [_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.frame = CGRectMake(30, 20+30*idx, 200, 30);
        checkBtn.tag = idx;
        scrView.contentSize = CGSizeMake(0, 20+30*idx);
        
        [checkBtn setTitle:obj[@"ItemName"] forState:UIControlStateNormal];
        if ([_selectArr containsObject:obj[@"ItemName"]]) {
            [checkBtn setImage:[UIImage imageNamed:@"keyChecked"] forState:UIControlStateNormal];
        }
        else
        {
            [checkBtn setImage:[UIImage imageNamed:@"keyUnchecked"] forState:UIControlStateNormal];
        }
        
        checkBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [checkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [checkBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [scrView addSubview:checkBtn];
    }];
    
}
-(void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, screen_w, screen_h);
    }];
}
-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)buttonAction:(UIButton*)button
{
    if ([button.imageView.image isEqual:[UIImage imageNamed:@"keyUnchecked"]]) {
        [button setImage:[UIImage imageNamed:@"keyChecked"] forState:UIControlStateNormal];
        [self.keyArr addObject:button.titleLabel.text];
        [self.codeArr addObject:[self.array objectAtIndex:button.tag][@"ItemCode"]];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"keyUnchecked"] forState:UIControlStateNormal];
        [self.keyArr removeObject:button.titleLabel.text];
        [self.codeArr removeObject:[self.array objectAtIndex:button.tag][@"ItemCode"]];
    }
}

-(void)doneAction
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(keyPointView:keyArr:keyCode:)]) {
        [self.delegate keyPointView:self keyArr:self.keyArr keyCode:self.codeArr];
    }
}
@end
