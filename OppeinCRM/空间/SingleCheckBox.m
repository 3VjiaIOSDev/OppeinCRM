//
//  SingleCheckBox.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "SingleCheckBox.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation SingleCheckBox

-(id)initWithArray:(NSArray*)array
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f];
        self.dataArray = array;
        
        [self initUI];
    }
    return self;
}

-(void)dismissSingleBox
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    self.string = radio.titleLabel.text;
    self.boxTag = radio.tag;
}
- (void)initUI
{
    float checkBoxH = (3+[self.dataArray count]/2)*30;
    UIView *checkBoxView = [[UIView alloc]initWithFrame:CGRectMake(45, (ScreenHeight-checkBoxH)/2, ScreenWidth-90, checkBoxH)];
    checkBoxView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
    checkBoxView.layer.cornerRadius = 10.0f;
    
    float halfW = checkBoxView.frame.size.width/2;
    
    float fristH = 1/2*(checkBoxView.frame.size.height)-1/2*(self.dataArray.count)*30+15;
    NSLog(@"%f",checkBoxH);
    for (int i = 0; i < self.dataArray.count; i++) {
        
        int row = i%2;
        int col = i/2;
        
        QRadioButton *radio = [[QRadioButton alloc] initWithDelegate:self groupId:@"group"];
        radio.frame = CGRectMake(35+halfW*row, fristH+30*col, 100, 30);
        radio.tag = i;
        [radio setTitle:[self.dataArray objectAtIndex:i] forState:UIControlStateNormal];
        [radio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [radio.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [checkBoxView addSubview:radio];
        
    }
    
    float buttonH = fristH+15*(self.dataArray.count)+15;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, buttonH+10, 60, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [checkBoxView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(20+halfW, buttonH+10, 60, 30);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [checkBoxView addSubview:button1];
    
    [self addSubview:checkBoxView];
    
}

-(void)cancel:(id)sender
{
    [self dismissSingleBox];
}

-(void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(singleCheckBox:withString:tag:)]) {
        [self.delegate singleCheckBox:self withString:self.string tag:self.boxTag];
    }
    [self dismissSingleBox];
}


@end
