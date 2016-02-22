//
//  TimePicker.h
//  Test1
//
//  Created by 3Vjia on 15/10/27.
//  Copyright © 2015年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TimePicker;

@protocol TimePickerDelegate <NSObject>

-(void)clickTimeWith:(TimePicker*)timePicker timer:(NSString*)timer;

@end

@interface TimePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)NSArray * wArray;
@property (nonatomic,strong)NSArray * hArray;
@property (nonatomic,strong)NSArray * mArray;

@property (nonatomic,strong)UIPickerView * picker;

@property (nonatomic)id <TimePickerDelegate>delegate;

- (id)initWithDataArray;

- (void)show;

- (void)dissPicker;

@end
