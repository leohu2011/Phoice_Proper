//
//  Folder_Photo_Array.h
//  experiment
//
//  Created by Sina on 16/6/16.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#ifndef Folder_Photo_Array_h
#define Folder_Photo_Array_h
#import <UIKit/UIKit.h>

//folderArray could contain both folder_array and AVUnit items.
@interface folderArray : NSObject<NSCoding>

//folder_count keeps track of the number of subfolders in the current fparray
//@property (nonatomic, assign) NSInteger folder_count;
//item_count keeps track of the number of photo_items in the current fparray
//@property (nonatomic, assign) NSInteger item_count;

@property (nonatomic, strong) NSMutableArray *content_array;

//@property (nonatomic, copy) folderArray *folder_array;
//
//@property (nonatomic, copy) NSMutableArray *item_array;

@property (nonatomic, copy) NSString *folderName;

//this ID is used as the key to its subarray objects
@property (nonatomic, copy) NSString *unique_ID;

@property (nonatomic, copy) NSString *parant_ID;

-(NSInteger) obtainFolderCount;

-(NSInteger) obtainItemCount;


/*
//rewriting nsmutableArray methods
- (NSUInteger)count;

- (id)objectAtIndex:(NSUInteger)index;

- (void)addObject:(id)anObject;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)removeLastObject;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
*/

@end



#endif /* Folder_Photo_Array_h */
