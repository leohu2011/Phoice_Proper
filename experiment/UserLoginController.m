//
//  UserLoginController.m
//  experiment
//
//  Created by Sina on 16/6/28.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLoginController.h"


@interface userLoginController()

@end

//for now, the login and user infomation is stored in the nsuserdefault and the checking step is also done against the info stored in nsuserdafault. After the afnetworking is properly setup will upload everything to the network. Also, encription is possible with MD5 and other types of encription
@implementation userLoginController{
    UISegmentedControl *segControl;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initializeView];
}

-(void) initializeView{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"User Login";
    
    //adding segmented control
    NSArray *segmentArray = [[NSArray alloc]initWithObjects:@"register", @"login", nil];
    segControl = [[UISegmentedControl alloc]initWithItems:segmentArray];
    segControl.frame = CGRectMake(width/4, 80, width/2, 50);
    segControl.selectedSegmentIndex = 0;
    segControl.backgroundColor = [UIColor whiteColor];
    segControl.tintColor = [UIColor blackColor];
    [self.view addSubview:segControl];
    [segControl addTarget:self action:@selector(whichModeToShow) forControlEvents:UIControlEventValueChanged];
}

-(void)whichModeToShow{
    //register mode
    if([segControl selectedSegmentIndex] == 0){
        
    }
    
    //login mode
    else if ([segControl selectedSegmentIndex] == 1){
        
    }
    
    else{
        NSLog(@"there are only 2 segments to chooose from");
    }
}

@end