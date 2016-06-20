//
//  AVUnit.h
//  experiment
//
//  Created by Sina on 16/6/17.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#ifndef AVUnit_h
#define AVUnit_h
#import <UIKit/UIKit.h>

@interface AVUnit : NSObject

@property (nonatomic, copy) NSString *small_address;
@property (nonatomic, strong) NSData *small_data;

@property (nonatomic, copy) NSString *big_address;
@property (nonatomic, strong) NSData *big_data;

@property (nonatomic, copy) NSString *recording_address;    //could be extended to an array of recordings

@property (nonatomic, copy) NSString *text_description;
@property (nonatomic, copy) NSString *detail_description;

@property (nonatomic, copy) NSString *parant_folder_ID;

@end

#endif /* AVUnit_h */
