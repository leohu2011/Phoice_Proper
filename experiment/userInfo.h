//
//  userInfo.h
//  experiment
//
//  Created by Sina on 16/6/28.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#ifndef userInfo_h
#define userInfo_h
#import <UIKit/UIKit.h>

@interface userInfo : NSObject

@property (nonatomic, copy) NSString * user_name;

@property (nonatomic, copy) NSString * user_password;

@property (nonatomic, copy) NSString * user_ID;

@property (nonatomic, assign) BOOL autoLogin;

@property (nonatomic, assign) BOOL rememberUserName;

@end


#endif /* userInfo_h */
