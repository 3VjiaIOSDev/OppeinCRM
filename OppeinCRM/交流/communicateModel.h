//
//  communicateModel.h
//  Crm
//
//  Created by svj on 15/10/22.
//  Copyright (c) 2015年 com.3vjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface communicateModel : NSObject

@property (nonatomic,strong)NSString * ACId;
@property (nonatomic,strong)NSString * Content;
@property (nonatomic,strong)NSString * CreateTime;
@property (nonatomic,strong)NSString * DeptId;
@property (nonatomic,strong)NSString * IsDelete;
@property (nonatomic,strong)NSString * OrganId;
@property (nonatomic,strong)NSString * ParentId;
@property (nonatomic,strong)NSString * ServiceId;
@property (nonatomic,strong)NSString * UserId;
@property (nonatomic,strong)NSArray * anwser;
@property (nonatomic,strong)NSString * userName;


- (communicateModel *)initWithDictionary:(NSDictionary *)dic;

+(communicateModel *)communicateWithDictionary:(NSDictionary *)dic;


@end
