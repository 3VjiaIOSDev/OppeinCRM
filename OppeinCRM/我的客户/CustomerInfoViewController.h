//
//  CustomerInfoViewController.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CustomerInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,
MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>

{
    UILabel *infoLab;
    UIButton *infoBtn;
}

@property NSArray *customerAry1;

@property UITableView *customerTable;

@property NSString *name;
@property NSString *phone;
@property NSString *address;

@property NSString *CustomerId;
@property NSString *ServiceId;
@property NSString *UserId;
@property NSString *serviceNO;

@end
