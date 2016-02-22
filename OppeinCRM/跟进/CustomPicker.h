//
//  CustomPicker.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/9.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomPicker;

@protocol CustomPickerDelegate <NSObject>

- (void)clickSureButtonWith:(CustomPicker *)picker currentTitle:(NSString *)title tag:(NSInteger)row;

@end

@interface CustomPicker : UIView

@property (nonatomic,strong)NSArray * dataArray;

@property (nonatomic)id <CustomPickerDelegate>pickerDelegate;

- (id)initWithDataArray:(NSArray *)arr;

- (void)show;

- (void)dissPicker;

@end
