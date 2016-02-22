//
//  MearsureIistViewController.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/12.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MearsureIistViewController : UIViewController
{
    UILabel *infoLab;
    UIButton *infoBtn;
    AFLoadIngView *afloading;
}
@property NSString *ServiceId;
@property NSString *UserId;

@property NSMutableArray *customerAry2;
@property NSMutableArray *customerAry3;
@property NSMutableArray *customerAry4;
@property NSMutableArray *customerAry5;
@property NSMutableArray *isUpdataAry;

@property UITableView *customerTable;
@end
