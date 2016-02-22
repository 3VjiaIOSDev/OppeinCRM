//
//  communicateModel.m
//  Crm
//
//  Created by svj on 15/10/22.
//  Copyright (c) 2015年 com.3vjia. All rights reserved.
//

#import "communicateModel.h"

@implementation communicateModel
- (communicateModel *)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.ACId = dic[@"ACID"];
        self.Content = dic[@"Content"];
        self.CreateTime = dic[@"CreateTime"];
        self.DeptId = dic[@"DeptId"];
        self.IsDelete = dic[@"IsDelete"];
        self.OrganId = dic[@"OrganId"];
        self.ParentId = dic[@"ParentId"];
        self.ServiceId = dic[@"ServiceId"];
        self.UserId = dic[@"UserId"];
        self.anwser = dic[@"anwser"];
        self.userName = dic[@"UserName"];
    }
    return self;
}
+(communicateModel *)communicateWithDictionary:(NSDictionary *)dic{
    communicateModel * model = [[communicateModel alloc]initWithDictionary:dic];
    return model;
}
@end
