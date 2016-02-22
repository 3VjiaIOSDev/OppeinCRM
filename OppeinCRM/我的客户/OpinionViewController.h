//
//  OpinionViewController.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"

@interface OpinionViewController : UIViewController<QRadioButtonDelegate,UITextViewDelegate>
{
    int CommunicateType;
    UITextView *communicateTextView;
    UILabel *placeholderLab;
}
@property (nonatomic,strong) NSString *ServiceId;

@end
