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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"Log In" style:UIBarButtonItemStyleDone target:self action:@selector(loginCheck)];
    item1.tintColor = [UIColor whiteColor];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"Log Out" style:UIBarButtonItemStyleDone target:self action:@selector(logoutCheck)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:@[flexItem,item1,flexItem, item2, flexItem] animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)loginCheck{
    
}

-(void)logoutCheck{
    
}

-(void)closeKeyboard: (UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

-(void)whichModeToShow{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    //first step is to clear all subviews and then load the requied views
    [[self.view subviews]enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    [self.view addSubview:segControl];
    
    //register mode
    if([segControl selectedSegmentIndex] == 0){
        
    }
    
    //login mode
    else if ([segControl selectedSegmentIndex] == 1){
        CGFloat indent = 10.f;
        
        UITextField *nameField = [[UITextField alloc]init];
        nameField.frame = CGRectMake(indent, 250, width - indent*2, 50);
        nameField.placeholder = @"User Name";
        nameField.textAlignment = NSTextAlignmentCenter;
        nameField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:nameField];
        
        UITextField *passwordField = [UITextField new];
        passwordField.frame = CGRectMake(indent, 320, width-indent*2, 50);
        passwordField.placeholder = @"Password";
        passwordField.textAlignment = NSTextAlignmentCenter;
        passwordField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:passwordField];
    }
    
    else{
        NSLog(@"there are only 2 segments to chooose from");
    }
}

@end