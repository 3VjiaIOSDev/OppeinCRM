//
//  UserinfoViewController.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserinfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property UITableView *userInfoTable;
@property NSArray *userInfoAry1;
@property NSMutableArray *userInfoAry2;

@end
