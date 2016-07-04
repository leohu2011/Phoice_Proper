//
//  UserLoginController.m
//  experiment
//
//  Created by Sina on 16/6/28.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLoginController.h"
#import "userInfo.h"


@interface userLoginController()

@end

//for now, the login and user infomation is stored in the nsuserdefault and the checking step is also done against the info stored in nsuserdafault. After the afnetworking is properly setup will upload everything to the network. Also, encription is possible with MD5 and other types of encription
@implementation userLoginController{
    UISegmentedControl *segControl;
    UIButton *autoButton;
    UIButton *rememberButton;
    
    UIBarButtonItem *item_login;
    UIBarButtonItem *item_logout;
    UIBarButtonItem *item_register;
    UIBarButtonItem *flexItem;
    
    UITextField *nameField;
    UITextField *passwordField;
    UITextField *passwordField2;
    
    NSString *UserData_filePath;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initializeView];
    
    [self initializeData];
}

-(void)initializeData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    UserData_filePath = [documentDirectory stringByAppendingPathComponent:@"UserInfoData.plist"];
}

-(void) initializeView{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"User Login";
    
    //adding segmented control
    NSArray *segmentArray = [[NSArray alloc]initWithObjects: @"register", @"login", nil];
    segControl = [[UISegmentedControl alloc]initWithItems:segmentArray];
    segControl.frame = CGRectMake(width/4, 80, width/2, 50);
    segControl.selectedSegmentIndex = 1;
    segControl.backgroundColor = [UIColor whiteColor];
    segControl.tintColor = [UIColor blackColor];
    [self.view addSubview:segControl];
    [segControl addTarget:self action:@selector(whichModeToShow) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    
    CGFloat indent = 10.f;
    
    nameField = [[UITextField alloc]init];
    nameField.frame = CGRectMake(indent, 250, width - indent*2, 50);
    nameField.placeholder = @"User Name";
    nameField.textAlignment = NSTextAlignmentCenter;
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:nameField];
    
    passwordField = [UITextField new];
    passwordField.frame = CGRectMake(indent, 320, width-indent*2, 50);
    passwordField.placeholder = @"Password";
    passwordField.textAlignment = NSTextAlignmentCenter;
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.secureTextEntry = YES;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordField];
    
    autoButton = [[UIButton alloc]init];
    [autoButton setTitle:@"Auto Login" forState: UIControlStateNormal];
    autoButton.selected = YES;
    [autoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [autoButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    autoButton.frame = CGRectMake(indent + 20, 400, 100, 50);
    [autoButton sizeToFit];
    [autoButton addTarget:self action:@selector(autoLogIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autoButton];
    
    rememberButton = [[UIButton alloc]init];
    [rememberButton setTitle:@"Remember User Name" forState:UIControlStateNormal];
    rememberButton.selected = YES;
    [rememberButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rememberButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    rememberButton.frame = CGRectMake(170, 400, 200, 50);
    [rememberButton sizeToFit];
    [rememberButton addTarget:self action:@selector(rememberName) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rememberButton];
    
    passwordField2 = [UITextField new];
    passwordField2.secureTextEntry = YES;
    passwordField2.clearButtonMode = UITextFieldViewModeWhileEditing;
//    passwordField2.frame = CGRectMake(indent, 390, width-indent*2, 50);
//    passwordField2.placeholder = @"Enter Password Again";
//    passwordField2.textAlignment = NSTextAlignmentCenter;
//    passwordField2.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:passwordField2];

    
    item_login = [[UIBarButtonItem alloc]initWithTitle:@"Log In" style:UIBarButtonItemStyleDone target:self action:@selector(loginCheck)];
    item_logout = [[UIBarButtonItem alloc]initWithTitle:@"Log Out" style:UIBarButtonItemStyleDone target:self action:@selector(logoutCheck)];
    item_register = [[UIBarButtonItem alloc]initWithTitle:@"Register" style:UIBarButtonItemStyleDone target:self action:@selector(registerUser)];
    flexItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:@[flexItem,item_login, flexItem, item_logout, flexItem] animated:YES];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)loginCheck{
    NSLog(@"logging in");
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:UserData_filePath]){
        NSLog(@"data file missing, chech startUpViewController");
    }
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:UserData_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableArray *array = [unarchiver decodeObjectForKey:@"user_information"];
    
    NSMutableArray *statusArray = array[0];
    BOOL loggedIn = [statusArray[0] boolValue];
    if (loggedIn){
        NSLog(@"already logged in");
        return;
    }
    
    NSString *userName = nameField.text;
    NSString *userPassword = passwordField.text;
    BOOL autoLogIn = autoButton.selected;
    BOOL rememberUserName = rememberButton.selected;
    
    NSMutableDictionary *dict = array[2];
    if(![dict objectForKey:userName]){
        NSLog(@"wrong user name");
        return;
    }
    if([dict objectForKey:userName]){
        userInfo *correctUser = [dict objectForKey:userName];
        NSString *correctPassword = correctUser.user_password;
        if (![correctPassword isEqualToString:userPassword]){
            NSLog(@"wrong password");
            return;
        }
        else{
            NSLog(@"correct credential entered");
            //user information checks out, change login status and write back
            correctUser.autoLogin = autoLogIn;
            correctUser.rememberUserName = rememberUserName;
            //see if array[2] is changed
            [dict setObject:correctUser forKey:userName];
            
            array[1] = correctUser;
            statusArray[0] = [NSNumber numberWithBool:YES];
            statusArray[1] = correctUser.user_name;
            statusArray[2] = correctUser.user_ID;
            array[0] = statusArray;
            
            NSMutableData *newData = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:newData];
            [archiver encodeObject:array forKey:@"user_information"];
            [archiver finishEncoding];
            if ([newData writeToFile:UserData_filePath atomically:YES]){
                NSLog(@"log in successful");
            }
        }
    }
}

-(void)logoutCheck{
    NSLog(@"logging out");
    if(![[NSFileManager defaultManager]fileExistsAtPath:UserData_filePath]){
        NSLog(@"data file missing, chech startUpViewController");
    }
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:UserData_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableArray *array = [unarchiver decodeObjectForKey:@"user_information"];
    
    NSMutableArray *statusArray = array[0];
    BOOL loggedIn = [statusArray[0] boolValue];
    if (!loggedIn){
        NSLog(@"already at log out mode");
        return;
    }
    
    else{
        array[0][0] = [NSNumber numberWithBool:NO];
        
        //write back
        NSMutableData *newData = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:newData];
        [archiver encodeObject:array forKey:@"user_information"];
        [archiver finishEncoding];
        if ([newData writeToFile:UserData_filePath atomically:YES]){
            NSLog(@"log out successful");
        }
    }
}

-(void)registerUser{
    
    NSLog(@"registering");
    
    NSString *userName = nameField.text;
    if (userName.length < 5){
        NSLog(@"user name is too short");
        return;
    }
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:UserData_filePath]){
        NSLog(@"data file missing, chech startUpViewController");
    }
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:UserData_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableArray *array = [unarchiver decodeObjectForKey:@"user_information"];
    NSMutableDictionary *dict = array[2];
    if ([dict objectForKey:userName]){
        NSLog(@"user name already exists");
        return;
    }
    
    NSString *pass1 = passwordField.text;
    NSString *pass2 = passwordField2.text;
    
    if (pass1.length < 5){
        NSLog(@"password too short");
        return;
    }
    
    if (![pass1 isEqualToString: pass2]){
        NSLog(@"passwords do not match");
        return;
    }
    
    //reaching this point indicates that the registering informaiton is acceptable, now needs to write them into the dictionary array[2]
    userInfo *newUser = [[userInfo alloc]init];
    newUser.user_name = userName;
    newUser.user_password = pass1;
    NSString *identifier = [[NSUUID UUID]UUIDString];
    newUser.user_ID = identifier;
    newUser.autoLogin = YES;
    newUser.rememberUserName = YES;
    
    [dict setObject:newUser forKey:userName];
    
    NSMutableData *newData = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:newData];
    [archiver encodeObject:array forKey:@"user_information"];
    [archiver finishEncoding];
    if ([newData writeToFile:UserData_filePath atomically:YES]){
        NSLog(@"write back after registering new user successful");
        [nameField setText:@""];
        [passwordField setText:@""];
        [passwordField2 setText:@""];
    }
    
    return;
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
    
    //clear inputs
    [nameField setText:@""];
    [passwordField setText:@""];
    [passwordField2 setText:@""];
    
    [self.view addSubview:segControl];
    
    //register mode
    if([segControl selectedSegmentIndex] == 0){
        CGFloat indent = 10.f;
        
        nameField.frame = CGRectMake(indent, 250, width - indent*2, 50);
        nameField.placeholder = @"User Name";
        nameField.textAlignment = NSTextAlignmentCenter;
        nameField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:nameField];
        
        passwordField.frame = CGRectMake(indent, 320, width-indent*2, 50);
        passwordField.placeholder = @"Password";
        passwordField.textAlignment = NSTextAlignmentCenter;
        passwordField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:passwordField];
        
        passwordField2.frame = CGRectMake(indent, 390, width-indent*2, 50);
        passwordField2.placeholder = @"Enter Password Again";
        passwordField2.textAlignment = NSTextAlignmentCenter;
        passwordField2.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:passwordField2];
        
        [self setToolbarItems:@[flexItem, item_register, flexItem] animated:YES];
    }
    
    //login mode
    else if ([segControl selectedSegmentIndex] == 1){
        CGFloat indent = 10.f;
        
        nameField.frame = CGRectMake(indent, 250, width - indent*2, 50);
        nameField.placeholder = @"User Name";
        nameField.textAlignment = NSTextAlignmentCenter;
        nameField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:nameField];
        
        passwordField.frame = CGRectMake(indent, 320, width-indent*2, 50);
        passwordField.placeholder = @"Password";
        passwordField.textAlignment = NSTextAlignmentCenter;
        passwordField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:passwordField];
        
        autoButton = [[UIButton alloc]init];
        [autoButton setTitle:@"Auto Login" forState: UIControlStateNormal];
        autoButton.selected = YES;
        [autoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [autoButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        autoButton.frame = CGRectMake(indent + 20, 400, 100, 50);
        [autoButton sizeToFit];
        [autoButton addTarget:self action:@selector(autoLogIn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:autoButton];
        
        rememberButton = [[UIButton alloc]init];
        [rememberButton setTitle:@"Remember User Name" forState:UIControlStateNormal];
        rememberButton.selected = YES;
        [rememberButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [rememberButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        rememberButton.frame = CGRectMake(170, 400, 200, 50);
        [rememberButton sizeToFit];
        [rememberButton addTarget:self action:@selector(rememberName) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rememberButton];
        
        [self setToolbarItems:@[flexItem, item_login, flexItem, item_logout, flexItem] animated:YES];
    }
    
    else{
        NSLog(@"there are only 2 segments to chooose from");
    }
}

-(void)autoLogIn{
    if (autoButton.selected == NO){
        [autoButton setSelected:YES];
        NSLog(@"auto login mode");
    }
    
    else{
        [autoButton setSelected:NO];
    }
    
}

-(void)rememberName{
    if (rememberButton.selected == NO){
        [rememberButton setSelected:YES];
        NSLog(@"remembering user name");
    }
    
    else{
        [rememberButton setSelected:NO];
    }
}



@end