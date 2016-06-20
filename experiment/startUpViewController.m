//
//  startUpViewController.m
//  experiment
//
//  Created by Sina on 16/6/17.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "startUpViewController.h"
#import "FMDatabase.h"
#import "tableViewController.h"
#import "AVUnit.h"


@implementation startUpController{
    //database
    NSString *dbPath;
    FMDatabase *db;
    
    //initial photo content
    NSArray *initial_array;
    int numberOfItems;
    
    //local cache storage containing the two nsdata for two images
    //each array element contains: <small_data, big_data, small_address/assetURL>
    NSString *Plist_filePath;
    
//    folderArray *tableView_contentArray;
}

-(void)loadView{
    [super loadView];
    
    initial_array = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                     @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                     @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                     @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                     @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                     @"http://ww1.sinaimg.cn/thumbnail/9be2329dgw1etlyb1yu49j20c82p6qc1.jpg"
                     ];
//    [self initializeDataBase];
//    
//    [self obtainDataFromDB];
    
    [self kickStartContentArray];
    
    [self initializeView];
    
}

-(void)initializeView{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    
    [self performSelector:@selector(transition) withObject:nil afterDelay:2];
}

-(void)transition{
    tableViewController *tv_controller = [[tableViewController alloc]initWithStyle:UITableViewStylePlain];
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
    folderArray *rootArray = [dict objectForKey:@"root_array"];
    
    folderArray *emptyFolder = [[folderArray alloc]init];
    emptyFolder.folder_count = 0;
    emptyFolder.item_count = 0;
    emptyFolder.folderName = @"empty folder";
    emptyFolder.content_array = nil;
    NSUUID *uuid = [[NSUUID alloc]init];
    NSString *uid = [uuid UUIDString];
    emptyFolder.unique_ID = uid;
    [rootArray.content_array addObject:emptyFolder];
    rootArray.folder_count += 1;
    
    tv_controller.tv_array = rootArray;
    [self.navigationController pushViewController:tv_controller animated:YES];
}

-(void)kickStartContentArray{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    Plist_filePath = [documentDirectory stringByAppendingPathComponent:@"savedData.plist"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    folderArray *tableView_contentArray = [[folderArray alloc]init];
    tableView_contentArray.folderName = @"ROOT POSITION";
    NSUUID *uuid = [[NSUUID alloc]init];
    NSString *uid = [uuid UUIDString];
    tableView_contentArray.unique_ID = uid;
    tableView_contentArray.folder_count = 0;
    tableView_contentArray.item_count = 0;
    tableView_contentArray.content_array = [[NSMutableArray alloc]init];
//    generating unique ID
//    CFUUIDRef ref = CFUUIDCreate(kCFAllocatorDefault);
//    CFStringRef str_ref = CFUUIDCreateString(kCFAllocatorDefault, ref);
//    NSString *unique_ID = [NSString stringWithString:(__bridge NSString*)str_ref];
//    CFRelease(ref);
//    CFRelease(str_ref);
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:Plist_filePath]){
        for (NSString *str in initial_array){
            AVUnit *unit = [[AVUnit alloc]init];
            unit.small_address = str;
            unit.small_data = [[NSData alloc]initWithContentsOfURL:[[NSURL alloc]initWithString:str]];
            unit.big_address = [str stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            unit.big_data = [[NSData alloc]initWithContentsOfURL:[[NSURL alloc]initWithString:unit.big_address]];
            
            unit.recording_address = nil;
            unit.text_description = nil;
            unit.detail_description = nil;
            unit.parant_folder_ID = uid;
            
            [tableView_contentArray.content_array addObject:unit];
            tableView_contentArray.item_count += 1;
        }
        
        [dict setObject:tableView_contentArray forKey:@"root_array"];
        
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:dict forKey:@"mainDict"];
        [archiver finishEncoding];
        if(![data writeToFile:Plist_filePath atomically:YES]){
            NSLog(@"something went wrong");
        }
    }
}

/*
-(void)initializeDataBase{
    //intialize the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    
    if ([db open]){
        //setup the table
        BOOL b = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Phoice (ID INTEGER PRIMARY KEY AUTOINCREMENT, Section integer, IndexRow integer, Loaded integer, TextLabel text, DetailDescription text, SmallPhoto blob, SmallPhotoAddress text, BigPhoto blob, BigPhotoAddress text,AudioFile text)"];
        
        if(!b){
            NSLog( @"sb wan er yi wrong again");
        }
        
        int count = 0;
        FMResultSet *result = [db executeQuery:@"select count(*) as NUM from Phoice"];
        if ([result next]){
            count = [result intForColumn: @"NUM"];
        }
        
        //this step is to check if the database has already be initiated
        if (count == 0){
            for(int i = 0; i < contentArray.count; i++){
                NSString *small = contentArray[i];
                NSString *big = [small stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
                
                NSURL *url_small = [NSURL URLWithString:small];
                NSData *data_small = [[NSData alloc]initWithContentsOfURL:url_small];
                
                NSURL *url_big = [NSURL URLWithString:big];
                NSData *data_big = [[NSData alloc]initWithContentsOfURL:url_big];
                
                NSNumber *notLoaded = [NSNumber numberWithInt:0];
                
                [db executeUpdate: @"INSERT INTO Phoice(Section, IndexRow, Loaded, TextLabel, DetailDescription, SmallPhoto, SmallPhotoAddress, BigPhoto, BigPhotoAddress, AudioFile) VALUES (?,?,?,?,?,?,?,?,?,?);", nil, nil, notLoaded, nil, nil, data_small, small, data_big, big, nil ];
                
            }
        }
    }
    
    [db close];
}

-(void)obtainDataFromDB{
    //start off with initializing a plist file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    Plist_filePath = [documentDirectory stringByAppendingPathComponent:@"image.plist"];
    BOOL success;
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:Plist_filePath]){
        NSLog(@"Plist already created");
    }
    
    else{
        NSArray *array = [[NSArray alloc]initWithObjects:@"data_small", @"data_big", @"small_address", nil];
        NSMutableArray *mainArray = [[NSMutableArray alloc]init];
        [mainArray addObject:array];
        success = [mainArray writeToFile:Plist_filePath atomically:YES];
    }
    
    if ([db open]){
        
        FMResultSet *result = [db executeQuery:@"select * from Phoice"];
        
        //beginTransaction to make sure that the update is not done in a one-to-one manner, but altogether
        success = [db beginTransaction];
        
        while ([result next]){
            int loaded = [result intForColumn:@"Loaded"];
            if (!loaded){
                NSData *small_data = [result dataForColumn:@"SmallPhoto"];
                NSData *big_data = [result dataForColumn:@"BigPhoto"];
                NSString *small_address = [result stringForColumn:@"SmallPhotoAddress"];
                NSArray *array = [[NSArray alloc]initWithObjects:small_data, big_data, small_address, nil];
                NSMutableArray *mainArray = [[NSMutableArray alloc]initWithContentsOfFile:Plist_filePath];
                [mainArray addObject:array];
                success = [mainArray writeToFile:Plist_filePath atomically:YES];
                int currentRow = [result intForColumn:@"ID"];
                
                NSString *updateSql = [NSString stringWithFormat:
                                       @"UPDATE %@ SET %@ = %@ WHERE %@ = %@",
                                       @"Phoice",  @"Loaded",  [NSNumber numberWithInt:1] ,@"ID",  [NSNumber numberWithInt:currentRow]];
                
                success = [db executeUpdate:updateSql];
            }
        }
        [db commit];
    }
    [db close];
    
    NSMutableArray *mainArray = [[NSMutableArray alloc]initWithContentsOfFile:Plist_filePath];
    numberOfItems = (int)mainArray.count - 1;
}
*/


@end
