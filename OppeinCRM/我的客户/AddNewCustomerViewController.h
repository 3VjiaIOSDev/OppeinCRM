//
//  AddNewCustomerViewController.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZAreaPickerView.h"
#import "QRadioButton.h"

@interface AddNewCustomerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,
HZAreaPickerDelegate,UITextFieldDelegate,
QRadioButtonDelegate>

@property UITableView *customerTable;
@property NSArray *customerAry1;
@property NSArray *customerAry2;
@property UILabel *areaLab;
@property UITextField *nameField;
@property UITextField *phoneField;
@property UITextField *addrField;
@property UITextField *markField;
@property UIView *AreaView;
@property NSString *customerName;
@property NSString *customerPhone;
@property NSString *customerProvice;
@property NSString *customerCity;
@property NSString *customerArea;
@property NSString *customerAddr;
@property NSString *customerNote;
@property int sex;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@end
