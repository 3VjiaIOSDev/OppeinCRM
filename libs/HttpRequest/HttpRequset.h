//
//  HttpRequset.h
//  yigoutong
//
//  Created by 3Vjia on 15/11/24.
//  Copyright © 2015年 com.3vjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequset : NSObject

+ (void)post:(NSDictionary *)params method:(NSString*)method completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;//post请求封装

+ (void)post1:(NSDictionary *)params method:(NSString*)method completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;//post请求封装

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
+(NSString*)initCode;
+(NSString*)initUserID;
//+ (BOOL)isExistenceNetwork;
@end
