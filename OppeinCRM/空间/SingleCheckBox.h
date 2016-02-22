//
//  SingleCheckBox.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
@class SingleCheckBox;

@protocol SingleCheckBoxDelegate <NSObject>

-(void)singleCheckBox:(SingleCheckBox*)singleCheckBox withString:(NSString *)string tag:(NSInteger)tag;

@end

@interface SingleCheckBox : UIView<QRadioButtonDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSString *string;

@property (nonatomic, assign) NSInteger boxTag;

@property(nonatomic)id<SingleCheckBoxDelegate>delegate;

-(id)initWithArray:(NSArray*)array;

-(void)dismissSingleBox;


@end
