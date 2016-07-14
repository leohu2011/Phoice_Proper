//
//  networkRequest.m
//  experiment
//
//  Created by Qi Hu on 5/7/16.
//  Copyright © 2016 Qi Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "networkRequest.h"
#import "AFNetworking.h"
#import "userInfo.h"

#define kRegisterDestination @"http://10.209.68.42/register.php"
#define kLoginDestination @"http://10.209.68.42/login.php"
#define kCheckDuplicateDestination @"http://10.209.68.42/checkDuplicate.php"



@interface networkRequest()

@end




@implementation networkRequest

-(void)processLoginRequestWithParameter:(userInfo *)user CompletionHandler:(completionBlock)returnResult{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *domainStr = kLoginDestination;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *name = user.user_name;
    NSString *pwd = user.user_password;
    
    [dict setObject:name forKey:@"name"];
    [dict setObject:pwd forKey:@"password"];
    
    
    [manager POST:domainStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"success at logging in");
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---获取到的json格式的字典--: %@",resultDict);
        
        if([[resultDict objectForKey:@"result"] isEqualToString:@"success"]){
            BOOL result = YES;
            returnResult(result);
        }
        else{
            BOOL result2 = NO;
            returnResult(result2);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"failure at registering for: %@", error.userInfo);
        BOOL result = NO;
        returnResult(result);
    }];
}


-(void)processRegisterRequestWithParameter: (userInfo*)user CompletionHandler:(completionBlock)returnResult{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *domainStr = kRegisterDestination;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *name = user.user_name;
    NSString *pwd = user.user_password;
    NSString *userID = user.user_ID;
    NSString *autoLogin = user.autoLogin ? @"true" : @"false";
    NSString *rememberName = user.rememberUserName ? @"true" : @"false";
    
    [dict setObject:name forKey:@"name"];
    [dict setObject:pwd forKey:@"password"];
    [dict setObject:userID forKey:@"ID"];
    [dict setObject:autoLogin forKey:@"auto"];
    [dict setObject:rememberName forKey:@"rmb"];
    
    
    [manager POST:domainStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"success at registering");
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---获取到的json格式的字典--: %@",resultDict);
        
        if([[resultDict objectForKey:@"result"] isEqualToString:@"success"]){
            BOOL result = YES;
            returnResult(result);
        }
        else{
            BOOL result2 = NO;
            returnResult(result2);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"failure at registering for: %@", error.userInfo);
        BOOL result = NO;
        returnResult(result);
    }];
    
    
}

-(void)checkForDuplicateUserName:(userInfo*) user CompletionHandler:(completionBlock)returnResult{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *domainStr = kCheckDuplicateDestination;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *name = user.user_name;
    
    [dict setObject:name forKey:@"name"];
    
    
    [manager POST:domainStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"success at registering");
        
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---获取到的json格式的字典--: %@",resultDict);
        
        if([[resultDict objectForKey:@"result"] isEqualToString:@"success"]){
            BOOL result = YES;
            returnResult(result);
        }
        else{
            BOOL result2 = NO;
            returnResult(result2);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"failure at registering for: %@", error.userInfo);
        BOOL result = NO;
        returnResult(result);
    }];

}

@end