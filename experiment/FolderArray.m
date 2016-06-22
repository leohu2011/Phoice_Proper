//
//  Folder_Photo_Array.m
//  experiment
//
//  Created by Sina on 16/6/16.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FolderArray.h"


@interface folderArray()

@end

@implementation folderArray 

//nscoding methods
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.folder_count forKey:@"folder_count"];
    [aCoder encodeInteger:self.item_count forKey:@"item_count"];
    [aCoder encodeObject:self.folderName forKey:@"folderName"];
    [aCoder encodeObject:self.unique_ID forKey:@"unique_ID"];
    [aCoder encodeObject:self.content_array forKey:@"content_array"];
    [aCoder encodeObject:self.parant_ID forKey:@"parant_ID"];
    
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if(self){
        self.folder_count = [aDecoder decodeIntegerForKey:@"folder_count"];
        self.item_count = [aDecoder decodeIntegerForKey:@"item_count"];
        self.folderName = [aDecoder decodeObjectForKey:@"folderName"];
        self.unique_ID = [aDecoder decodeObjectForKey:@"unique_ID"];
        self.content_array = [aDecoder decodeObjectForKey:@"content_array"];
        self.parant_ID = [aDecoder decodeObjectForKey:@"parant_ID"];
    }
    return self;
}

/*
-(instancetype)init {
    
    if (self = [super init]) {
        backEndArray = [@[] mutableCopy];
    }
    
    return self;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [backEndArray insertObject:anObject atIndex:index];
}

- (void)addObject:(id)anObject {
    [backEndArray addObject:anObject];
}

- (NSUInteger)count {
    return [backEndArray count];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [backEndArray replaceObjectAtIndex:index withObject:anObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [backEndArray removeObjectAtIndex:index];
}

- (void)removeLastObject {
    [backEndArray removeLastObject];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [backEndArray objectAtIndex:index];
}
*/

@end