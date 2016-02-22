//
//  HttpRequset.m
//  yigoutong
//
//  Created by 3Vjia on 15/11/24.
//  Copyright © 2015年 com.3vjia. All rights reserved.
//

#import "HttpRequset.h"
//#import "Reachability.h"

@implementation HttpRequset

+ (void)post:(NSDictionary *)params method:(NSString*)method completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //把传进来的URL字符串转变为URL地址
        NSURL *url = [NSURL URLWithString:OppeinURL];
        //请求初始化，可以在这针对缓存，超时做出一些设置
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:5];
        //解析请求参数，用NSDictionary来存参数，通过自定义的函数parseParams把它解析成一个post格式的字符串
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:nil];
        NSString *paramsString = [[NSString alloc] initWithData:paramsData
                                                       encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = @{@"Params":paramsString ,@"Command":method};

        
        NSString *parseParamsResult = [self parseParams:dic];
 
        NSData *postData = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
        
       
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:postData];
        
        //创建一个新的队列（开启新线程）
//        NSOperationQueue *queue = [NSOperationQueue new];
//        
//        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * response, NSData *  data, NSError *  connectionError) {
//            NSString * result = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
//            NSLog(@"error--%@",connectionError);
//            if (failure) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    failure(connectionError,result);
//                });
//            }
//            if (success) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    success(result);
//                });
//            }
//            result = nil;
//        }];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          // ...
                                          NSString * result = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (success) {
                                                  success(result);
                                              }else{
                                                  failure(error,result);
                                              }
                                          });
                                      }];
        
        [task resume];
    });
}



+ (void)post1:(NSDictionary *)params method:(NSString*)method completionBlock:(void (^)(id obj))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //把传进来的URL字符串转变为URL地址
        NSURL *url = [NSURL URLWithString:PhotoURL];
        //请求初始化，可以在这针对缓存，超时做出一些设置
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:5];
        //解析请求参数，用NSDictionary来存参数，通过自定义的函数parseParams把它解析成一个post格式的字符串
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:nil];
        NSString *paramsString = [[NSString alloc] initWithData:paramsData
                                                       encoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = @{@"Params":paramsString ,@"Command":method};
        
        
        NSString *parseParamsResult = [self parseParams:dic];
        
        NSData *postData = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:postData];
        
        //创建一个新的队列（开启新线程）
        //        NSOperationQueue *queue = [NSOperationQueue new];
        //
        //        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * response, NSData *  data, NSError *  connectionError) {
        //            NSString * result = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        //            NSLog(@"error--%@",connectionError);
        //            if (failure) {
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    failure(connectionError,result);
        //                });
        //            }
        //            if (success) {
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    success(result);
        //                });
        //            }
        //            result = nil;
        //        }];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          // ...
                                          NSString * result = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              if (success) {
                                                  success(result);
                                              }else{
                                                  failure(error,result);
                                              }
                                          });
                                      }];
        
        [task resume];
    });
}
+ (NSString *)parseParams:(NSDictionary *)params{
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        
        [result appendString:keyValueFormat];
    }
    NSString *string = [NSString stringWithString:result];
    string = [string substringToIndex:string.length-1];
    NSLog(@"%@",string);
    return string;
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

+(NSString*)initCode
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    return [userDefaultes stringForKey:@"AuthCode"];
}
+(NSString*)initUserID
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    return [userDefaultes stringForKey:@"userID"];
}
//+ (BOOL)isExistenceNetwork
//{
////    BOOL isExistenceNetwork;
////    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];  // 测试服务器状态
////    
////    switch([reachability currentReachabilityStatus]) {
////        case NotReachable:
////            isExistenceNetwork = FALSE;
////            break;
////        case ReachableViaWWAN:
////            isExistenceNetwork = TRUE;
////            break;
////        case ReachableViaWiFi:
////            isExistenceNetwork = TRUE;
////            break;
////    }
////    return  isExistenceNetwork;
//}
@end
