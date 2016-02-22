//
//  keyPoint.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/13.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class keyPoint;
@protocol keyPointDelegate <NSObject>

-(void)keyPointView:(keyPoint*)keyView keyArr:(NSMutableArray*)keyArray keyCode:(NSMutableArray*)codeArray;

@end

@interface keyPoint : UIView

@property (nonatomic, strong)NSArray *array;
@property (nonatomic, strong)NSArray *selectArr;
@property (nonatomic, strong)NSMutableArray *keyArr;
@property (nonatomic, strong)NSMutableArray *codeArr;

@property (nonatomic, assign)id<keyPointDelegate>delegate;

-(id)initWithArray:(NSArray*)arr selectArr:(NSArray*)selectArr codeArr:(NSArray*)codeArr;
-(void)show;
-(void)dismiss;
@end
