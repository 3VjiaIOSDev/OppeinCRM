//
//  AddFollowUpViewController.h
//  Crm
//
//  Created by 3Vjia on 15/10/22.
//  Copyright (c) 2015年 com.3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFollowUpViewController : UIViewController

@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * phone;
@property (nonatomic,copy)NSString * address;
@property (nonatomic,copy)NSString * customerId;
@property (nonatomic,copy)NSString * serviceId;
@property (nonatomic,copy)NSString * serviceNo;
@property (nonatomic,copy)NSString * userId;

@property (nonatomic,strong)UITextField *FollowUpTimeField;
@property (nonatomic,strong)UITextField *FollowUpStepField;
@property (nonatomic,strong)UITextField *FollowUpSpanField;
@property (nonatomic,strong)UITextField *nextTimeField;
@property (nonatomic,strong)UITextView *connectView;

@end
