//
//  AVUit.m
//  experiment
//
//  Created by Sina on 16/6/17.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVUnit.h"


@interface AVUnit()<NSCoding>

@end


@implementation AVUnit

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.small_address forKey:@"small_address"];
    [aCoder encodeObject:self.small_data forKey:@"small_data"];
    [aCoder encodeObject:self.big_address forKey:@"big_address"];
    [aCoder encodeObject:self.big_data forKey:@"big_data"];
    [aCoder encodeObject:self.recording_address forKey:@"recording_address"];
    [aCoder encodeObject:self.text_description forKey:@"text_description"];
    [aCoder encodeObject:self.detail_description forKey:@"detail_description"];
    [aCoder encodeObject:self.parant_folder_ID forKey:@"parant_folder_ID"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if (self){
        self.small_address = [aDecoder decodeObjectForKey:@"small_address"];
        self.small_data = [aDecoder decodeObjectForKey:@"small_data"];
        self.big_address = [aDecoder decodeObjectForKey:@"big_address"];
        self.big_data = [aDecoder decodeObjectForKey:@"big_data"];
        self.recording_address = [aDecoder decodeObjectForKey:@"recording_address"];
        self.text_description = [aDecoder decodeObjectForKey:@"test_description"];
        self.detail_description = [aDecoder decodeObjectForKey:@"detail_description"];
        self.parant_folder_ID = [aDecoder decodeObjectForKey:@"parant_folder_ID"];
    }
    return self;
}


@end