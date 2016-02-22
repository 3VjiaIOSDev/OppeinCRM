//
//  SpaceModel.h
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCheckBox.h"
#import "QRadioButton.h"

@class SpaceModel;
@protocol SpaceModelDelegate <NSObject>

-(void)SpaceModel:(SpaceModel*)spaceModel withArray:(NSArray*)array objectArray:(NSArray*)objArray;

@end

@interface SpaceModel : UIView<UITableViewDataSource,UITableViewDelegate,QCheckBoxDelegate,QRadioButtonDelegate,UITextFieldDelegate>

@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic, strong)NSMutableArray *saveArray;

@property (nonatomic, strong)NSDictionary *dic;

@property (nonatomic, strong)NSString *string;

@property (nonatomic, strong)NSMutableDictionary *spaceDic;

@property (nonatomic)id<SpaceModelDelegate>delegate;

-(id)initWithArray:(NSDictionary*)dic;

-(void)dismissView;
@end
