//
//  networkRequest.h
//  experiment
//
//  Created by Qi Hu on 5/7/16.
//  Copyright © 2016 Qi Hu. All rights reserved.
//

#ifndef networkRequest_h
#define networkRequest_h
#import <UIKit/UIKit.h>
#import "userInfo.h"


@interface networkRequest : NSObject

typedef void (^completionBlock)(BOOL result);

//typedef enum{
//    case_register,
//    case_login,
//}networkRequestType;

//@property (nonatomic, copy) NSString *destination;

//@property (nonatomic, strong) NSDictionary *parameter;

//@property (nonatomic, assign) networkRequestType *type;


-(void)processRegisterRequestWithParameter: (userInfo*)user CompletionHandler:(completionBlock)returnResult;

-(void)processLoginRequestWithParameter:(userInfo *)user;

-(void)checkForDuplicateUserName:(userInfo*) user CompletionHandler: (completionBlock)returnResult;




@end


#endif /* networkRequest_h */
