//
//  CustomPicker.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/9.
//  Copyright © 2016年 3Vjia. All rights reserved.
//
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "CustomPicker.h"

@interface CustomPicker()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)UIPickerView * picker;

@end

@implementation CustomPicker

- (id)initWithDataArray:(NSArray *)arr
{
    self = [super init];
    if (self) {
        self.dataArray = arr;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    
    self.backgroundColor = [UIColor colorWithRed:0.5294 green:0.8078 blue:0.9803 alpha:1.0f];
    
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 216)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.picker];
    
    
    float offWidth;
    offWidth = 30*ScreenWidth/320;
    NSLog(@"%f",offWidth);
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(offWidth, 5, 40, 30);
    btn1.tag = 1001;
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(ScreenWidth-40-offWidth, 5, 40, 30);
    btn2.tag = 1002;
    [btn2 setTitle:@"确定" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(dateChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
}
#pragma mark--UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArray objectAtIndex:row%self.dataArray.count];
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}
//取消操作
- (void)cancelView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}
- (void)dissPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
    
}
//确认操作
- (void)dateChoose:(UIButton *)btn
{
    NSInteger row = [self.picker selectedRowInComponent:0];
    NSString * string = [self.dataArray objectAtIndex:row%self.dataArray.count];
    if ([self.pickerDelegate respondsToSelector:@selector(clickSureButtonWith:currentTitle:tag:)]) {
        [self.pickerDelegate clickSureButtonWith:self currentTitle:string tag:row];
    }
    
    [self cancelView];
}
- (void)show
{
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, self.picker.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, ScreenHeight - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}


@end
