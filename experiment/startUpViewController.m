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
#import "userInfo.h"


@implementation startUpController{
    //database
    NSString *dbPath;
    FMDatabase *db;
    
    //initial photo content
    NSArray *initial_array;
    int numberOfItems;
    NSString *root_array_ID;
    
    //local cache storage containing the two nsdata for two images
    //each array element contains: <small_data, big_data, small_address/assetURL>
    NSString *Plist_filePath;
    NSString *UserData_filePath;
    
    //    folderArray *tableView_contentArray;
}

-(void)loadView{
    [super loadView];
    root_array_ID = @"root_array";
    
    initial_array = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                      @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                      @"http://ww1.sinaimg.cn/thumbnail/9be2329dgw1etlyb1yu49j20c82p6qc1.jpg"
                      ];
    
    [self initializeUserSystem];
    
    [self kickStartContentArray];
    
    [self initializeView];
    
}

-(void)initializeUserSystem{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    UserData_filePath = [documentDirectory stringByAppendingPathComponent:@"UserInfoData.plist"];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:UserData_filePath]){
        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:UserData_filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        NSMutableArray *array = [unarchiver decodeObjectForKey:@"user_information"];
        
        BOOL loggedIn = [array[0][0] boolValue];
        if (loggedIn){
            return;
        }
        else{
            userInfo *primaryUser = array[1];
            if (!primaryUser){
                return;
            }
            else{
                BOOL autoLogin = primaryUser.autoLogin;
                if (autoLogin){
//                    NSArray *newArray = [[NSArray alloc]initWithObjects:[NSNumber numberWithBool:YES], primaryUser.user_name, primaryUser.user_ID, nil];
                    array[0][0] = [NSNumber numberWithBool:YES];
                    array[0][1] = primaryUser.user_name;
                    array[0][2] = primaryUser.user_ID;
                    
                    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
                    [archiver encodeObject:array forKey:@"user_information"];
                    [archiver finishEncoding];
                    if(![data writeToFile:UserData_filePath atomically:YES]){
                        NSLog(@"something went wrong");
                    }
                }
            }
            
        }
    }
    
    else{
        userInfo *primaryInfo = [userInfo new];

#warning currently the user password is saved as is, in the future need to encode the user password using encriptions such as MD5 or other type of irreversible encriptions to ensure safety
        userInfo *sample = [[userInfo alloc]init];
        sample.user_name = @"user name";
        sample.user_password = @"user password";
        sample.user_ID = @"user ID";
        sample.autoLogin = NO;
        sample.rememberUserName = NO;
        
        NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc]init];
        [userInfoDict setObject:sample forKey:sample.user_name];
        
        //this is the status array indicating whether the user has logged in or not
        NSMutableArray *statusArray = [[NSMutableArray alloc]initWithObjects: [NSNumber numberWithBool:NO], @"logged in user name", @"logged in user ID", nil];
        
#warning first object is the primary user login info, second object is a list of registered user identities. should move the second item online when the network is properly setup
//        NSArray *userArray = [[NSArray alloc]initWithObjects:statusArray, primaryInfo,userInfoDict, nil];
        NSMutableArray *userArray = [[NSMutableArray alloc]initWithObjects:statusArray,primaryInfo, userInfoDict, nil];
        
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:userArray forKey:@"user_information"];
        [archiver finishEncoding];
        if(![data writeToFile:UserData_filePath atomically:YES]){
            NSLog(@"something went wrong");
        }
    }
    
    
}

-(void)initializeView{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:@"goto Phoice" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(transition) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.toolbar.tintColor = [UIColor blackColor];
    
    [self performSelector:@selector(transition) withObject:nil afterDelay:1];
}

-(void)transition{
    tableViewController *tv_controller = [[tableViewController alloc]initWithStyle:UITableViewStylePlain];
//    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
//    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
//    folderArray *rootArray = [dict objectForKey:root_array_ID];
//    tv_controller.tv_array = rootArray;
    
    tv_controller.uniqueID = root_array_ID;
    [self.navigationController pushViewController:tv_controller animated:YES];
}

-(void)kickStartContentArray{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    Plist_filePath = [documentDirectory stringByAppendingPathComponent:@"savedData.plist"];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:Plist_filePath]){
        folderArray *tableView_contentArray = [[folderArray alloc]init];
        tableView_contentArray.folderName = @"ROOT POSITION";
        tableView_contentArray.unique_ID = root_array_ID;
        //root array does not have parant
        tableView_contentArray.parant_ID = @"none";
        tableView_contentArray.content_array = [[NSMutableArray alloc]init];
        
        
        for (NSString *str in initial_array){
            AVUnit *unit = [[AVUnit alloc]init];
            unit.small_address = str;
            unit.small_data = [[NSData alloc]initWithContentsOfURL:[[NSURL alloc]initWithString:str]];
            unit.big_address = [str stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
            unit.big_data = [[NSData alloc]initWithContentsOfURL:[[NSURL alloc]initWithString:unit.big_address]];
            
            unit.recording_address = nil;
            unit.text_description = nil;
            unit.detail_description = nil;
            unit.parant_folder_ID = root_array_ID;
            
            [tableView_contentArray.content_array addObject:unit];
        }
        
        

        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:tableView_contentArray forKey:root_array_ID];
        
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:dict forKey:@"mainDict"];
        [archiver finishEncoding];
        if(![data writeToFile:Plist_filePath atomically:YES]){
            NSLog(@"something went wrong");
        }
    }
}


@end
