//
//  userInfo.m
//  experiment
//
//  Created by Sina on 16/6/28.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userInfo.h"

#define kUserName           @"user_name"
#define kUserPassword       @"user_password"
#define kUserID             @"user_ID"
#define kAutoLogin          @"autoLogin"
#define kRememberUserName   @"rememberUserName"

@interface userInfo() <NSCoding>

@end

@implementation userInfo

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.user_name forKey:kUserName];
    [aCoder encodeObject:self.user_password forKey:kUserPassword];
    [aCoder encodeObject:self.user_ID forKey:kUserID];
    [aCoder encodeBool:self.autoLogin forKey:kAutoLogin];
    [aCoder encodeBool:self.rememberUserName forKey:kRememberUserName];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if (self){
        self.user_name = [aDecoder decodeObjectForKey:kUserName];
        self.user_password = [aDecoder decodeObjectForKey:kUserPassword];
        self.user_ID = [aDecoder decodeObjectForKey:kUserID];
        self.autoLogin = [aDecoder decodeBoolForKey:kAutoLogin];
        self.rememberUserName = [aDecoder decodeBoolForKey:kRememberUserName];
    }
    
    return self;
}

@end