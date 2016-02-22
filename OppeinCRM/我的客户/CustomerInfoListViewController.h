//
//  CustomerInfoListViewController.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInfoListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSString *name;
    NSString *phone1;
    NSString *phone2;
    NSString *email;
    NSString *qq;
    NSString *addr;
    NSString *note;
    
    NSString *customerSource;
    NSString *customerType;
    NSString *shoppingGuide;
    NSString *designer;
    NSString *decDesigner;
    NSString *salesman;
    NSString *budgetCoust;
    NSString *budgetTime;
    NSString *budgetProducts;
    
    NSString *roomType;
    NSString *roomApart;
    NSString *price;
    NSString *deliveryTime;
    NSString *property;
}
@property NSString* CustomerId;
@property NSString* ServiceId;
@property NSString *spaceId;
@property UITableView *customerInfoListTable;
@property NSArray *customerBaseAry;
@property NSArray *customerIntentionAry;
@property NSArray *customerRoomAry;

@property NSMutableArray *baseAry;
@property NSMutableArray *intentionAry;
@property NSMutableArray *roomAry;

@end
