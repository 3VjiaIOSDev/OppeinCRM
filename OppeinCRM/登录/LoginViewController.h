//
//  LoginViewController.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    float viewWidth;
    float viewHeight;
    BOOL isSecure;
    
    UIImageView *logoImgView;
    UILabel *logoLab;
    UIView *phoneview;
    UIView *psdview;
    UIButton *button;
    BOOL isSelect;
}
@property UITextField *nameField;
@property UITextField *pwdField;

@property NSString *name;
@property NSString *password;
@end
