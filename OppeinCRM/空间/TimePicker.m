//
//  TimePicker.m
//  Test1
//
//  Created by 3Vjia on 15/10/27.
//  Copyright © 2015年 3Vjia. All rights reserved.
//
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "TimePicker.h"

@implementation TimePicker

- (id)initWithDataArray
{
    self = [super init];
    if (self) {
        
        self.wArray = [self weekAry1];
        self.hArray = [self hourAry];
        self.mArray = [self minAry];
        
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
    [self.picker selectRow:self.wArray.count*40 inComponent:0 animated:NO];
    [self.picker selectRow:self.hArray.count*40+4 inComponent:1 animated:NO];
    [self.picker selectRow:self.mArray.count*40 inComponent:2 animated:NO];
    [self addSubview:self.picker];
    
    
    float offWidth;
    offWidth = 30*ScreenWidth/320;
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


//取消操作
- (void)cancelView
{
    [self dissPicker];
}
//确认操作
- (void)dateChoose:(UIButton *)btn
{
    NSInteger firstRow = [self.picker selectedRowInComponent:0];
    NSInteger subRow = [self.picker selectedRowInComponent:1];
    NSInteger threeRow = [self.picker selectedRowInComponent:2];
    NSString *firstString = [self.wArray objectAtIndex:(firstRow%[self.wArray count])];
    NSString *subString = [self.hArray objectAtIndex:(subRow%[self.hArray count])];
    NSString *thrString = [self.mArray objectAtIndex:(threeRow%[self.mArray count])];
    
    NSString *str3 = [NSString stringWithFormat:@"%@:%@:00",[subString substringToIndex:2],[thrString substringToIndex:2]];
    NSString *string = [NSString stringWithFormat:@"%@ %@",firstString,str3];
 
    if ([self.delegate respondsToSelector:@selector(clickTimeWith:timer:)]) {
        [self.delegate clickTimeWith:self timer:string];
    }
    [self dissPicker];
}

- (void)show
{
    self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, self.picker.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, ScreenHeight - self.frame.size.height, self.frame.size.width, self.frame.size.height);
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
#pragma mark--UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.wArray.count*100;
    }
    else if (component == 1)
    {
        return self.hArray.count*100;
    }
    else
        return self.mArray.count*100;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if(component == 0){
        return [self.wArray objectAtIndex:row%self.wArray.count];
    }
    else if (component == 1)
    {
        return [self.hArray objectAtIndex:row%self.hArray.count];
    }
    else
        return [self.mArray objectAtIndex:row%self.mArray.count];
    
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

// 每一列的宽度

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 150;
    }
    else if(component == 1)
    {
        return 80;
    }
    else
        return 80;
}

#pragma mark 时间生成

-(NSMutableArray*)weekAry1
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    NSDate *date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeInterval  interval = 24*60*60*1;
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    date = now;
    for (int i = 0; i < 30; i++) {
        NSString *str = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
        [ary addObject:str];
        date = [date dateByAddingTimeInterval:+interval];
    }
    return ary;
}

//小时
-(NSMutableArray*)hourAry
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (int i = 0; i <= 12; i++) {
        NSString *str = [NSString stringWithFormat:@"%d时",8+i];
        if (i <= 1) {
             str = [NSString stringWithFormat:@"0%d时",8+i];
        }
        [ary addObject:str];
    }
    return ary;
}
//分钟
-(NSMutableArray*)minAry
{
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    for (int i = 0; i < 12; i++) {
        NSString *str = [NSString stringWithFormat:@"%d分",i*5];
        if (i < 2) {
            str = [NSString stringWithFormat:@"0%@",str];
        }
        [ary addObject:str];
    }
    return ary;
}

@end
