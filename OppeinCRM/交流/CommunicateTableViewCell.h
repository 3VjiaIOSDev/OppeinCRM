//
//  CommunicateTableViewCell.h
//  Crm
//
//  Created by svj on 15/10/22.
//  Copyright (c) 2015年 com.3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "communicateModel.h"
@interface CommunicateTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * dateLab;
@property (nonatomic,strong)UILabel * infoLab;
@property (nonatomic,strong)UIButton * replyBtn;

@property (nonatomic,strong)communicateModel * communicateObj;
@property (nonatomic,assign) CGFloat cellHeight;

@end
