//
//  detailView.m
//  experiment
//
//  Created by Qi Hu on 17/5/16.
//  Copyright © 2016 Qi Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "detailViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MZTimerLabel.h"
#import "SCSiriWaveformView.h"
#import "photoItem.h"
#import "FolderArray.h"
#import "AVUnit.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"


@interface detailViewController()<UIScrollViewDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@end

@implementation detailViewController{
    NSIndexPath *pathChosen;
    UIScrollView *scrollView;
    UIImageView *returnImageView;
    UIImageView *enlargeView;
    CGRect originalFrame;
    
    NSString *Plist_filePath;
    
    //photoItem object
    photoItem *photo_audio_Item;
    
    
    //other supporting features
    UILabel *timeLabel;
    MZTimerLabel *MZtimer2;
    UIVisualEffectView *visualEffectView;
    SCSiriWaveformView *waveView;
    CADisplayLink *meterUpdateDisplayLink;
    
    //recorder
//    AVAudioRecorder *_audioRecorder;
    UIButton *recordR;
    UIButton *pauseR;
    UIButton *resumeR;
    UIButton *stopR;
    BOOL pausedState;
    NSString *previousMode;
    
    //player
//    AVAudioPlayer *_audioPlayer;
    UIButton *recordP;
    UIButton *pauseP;
    UIButton *resumeP;
    UIButton *stopP;
    
    UIBarButtonItem *flexItem;
    UIBarButtonItem *sendVoiceItem;
    UIBarButtonItem *sendPhotoItem;
    
}

-(instancetype) initWithIndex:(NSIndexPath*)indexpath andAddress: (NSString*) address{
    
    if (self = [super init]) {
    
        pathChosen = indexpath;

    }
    return self;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadPhotoItemObject];
    [self initializeEditAndImage];
    [self initialize_btnAndLabel];
}


-(void) loadPhotoItemObject{
    photo_audio_Item = [[photoItem alloc]init];

    
    photo_audio_Item.audioAddress = self.audioLocation;
    photo_audio_Item.photoAddress = self.photoLocation;
    photo_audio_Item.itemIndex = (NSInteger) pathChosen.row;
    photo_audio_Item.audio_unique_ID = self.audio_unique_ID;
    

    
    //[photo_audio_Item validateMicrophoneAccess];
    [photo_audio_Item initializeAudioSession];
    [photo_audio_Item startUpdatingMeter];
    
    CGRect rect = CGRectMake(10, 300, [UIScreen mainScreen].bounds.size.width - 20, 200);
    visualEffectView = [photo_audio_Item initializeVEViewWithFrame:rect];
    [self.view addSubview:visualEffectView];
    
}

-(void)initializeEditAndImage{
    UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    doubleClick.numberOfTapsRequired = 1;
    
    //setup detail image view
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    int index = (int)pathChosen.row;
    
//    NSURL *url;
//    if ([self.photoLocation containsString:@"thumbnail"]){
//        url = [[NSURL alloc]initWithString:[self.photoLocation stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
//    }
//    else{
//        url = [[NSURL alloc]initWithString:self.photoLocation];
//    }
//    NSData *data = [[NSData alloc]initWithContentsOfURL: url];
//    UIImage *img = [[UIImage alloc]initWithData:data];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    Plist_filePath = [documentDirectory stringByAppendingPathComponent:@"savedData.plist"];
    
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
    folderArray *rootArray = [dict objectForKey:self.parant_unique_ID];
    NSData *big_data;
    
    for (NSInteger i = 0; i < rootArray.content_array.count; i++){
        if ([rootArray.content_array[i] isKindOfClass:[AVUnit class]]){
            AVUnit *unit = rootArray.content_array[i];
            if ([unit.big_address isEqualToString:self.photoLocation]){
                big_data = unit.big_data;
                //record the unit's recording address
//                unit.recording_address = self.audioLocation;
                break;
            }
        }
    }
    
    //writing back the data
//    NSMutableData *new_data = [[NSMutableData alloc]init];
//    [dict setObject:rootArray forKey:self.parant_unique_ID];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:new_data];
//    [archiver encodeObject:dict forKey:@"mainDict"];
//    [archiver finishEncoding];
//    if(![new_data writeToFile:Plist_filePath atomically:YES]){
//        NSLog(@"something went wrong");
//    }
    
    UIImage *img = [[UIImage alloc]initWithData:big_data];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    imgView.frame = (CGRectMake(0, 0, width * 0.5, self.view.frame.size.height *0.3));
    imgView.center = CGPointMake(width/2 + 50, 180);
    imgView.userInteractionEnabled = YES;
    imgView.multipleTouchEnabled = YES;
    [imgView addGestureRecognizer:doubleClick];
    [self.view addSubview: imgView];
    
    //edit cell information
    UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleClick.numberOfTapsRequired = 1;
    
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){10,180,100,50}];
    label.text = @"Edit Cell Info";
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor blueColor];
    label.tag = index;
    label.userInteractionEnabled = YES;
    label.multipleTouchEnabled = YES;
    [label addGestureRecognizer:singleClick];
    [self.view addSubview:label];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[photo_audio_Item validateMicrophoneAccess];

}

-(void)initialize_btnAndLabel{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    //time label
    timeLabel = [[UILabel alloc]initWithFrame:(CGRect){10, height - 150, 200, 50}];
    timeLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 50);
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview: timeLabel];
    
    //recorder buttons
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    

    recordR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [recordR setTitle:@"Record" forState:UIControlStateNormal];
    [recordR setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    recordR.backgroundColor = [UIColor clearColor];
    recordR.titleLabel.font = font;
    CGSize size = [recordR.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    recordR.frame = CGRectMake(10, height-80 ,size.width +10, size.height + 10);
    UITapGestureRecognizer *record = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recordClick:)];
    [recordR addGestureRecognizer:record];
    recordR.userInteractionEnabled = YES;
    [self.view addSubview:recordR];
    
    pauseR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pauseR setTitle:@"Pause" forState:UIControlStateNormal];
    [pauseR setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pauseR.backgroundColor = [UIColor clearColor];
    pauseR.titleLabel.font = font;
    size = [pauseR.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    pauseR.frame = CGRectMake(width*0.25 + 10, height-80 ,size.width +10, size.height + 10);
    UITapGestureRecognizer *pause = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pauseClick:)];
    [pauseR addGestureRecognizer:pause];
    pauseR.userInteractionEnabled = YES;
    [self.view addSubview:pauseR];
    
    resumeR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [resumeR setTitle:@"Resume" forState:UIControlStateNormal];
    [resumeR setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    resumeR.backgroundColor = [UIColor clearColor];
    resumeR.titleLabel.font = font;
    size = [resumeR.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    resumeR.frame = CGRectMake(width*0.5 + 10, height-80 ,size.width +10, size.height + 10);
    UITapGestureRecognizer *resume = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resumeClick:)];
    [resumeR addGestureRecognizer:resume];
    resumeR.userInteractionEnabled = YES;
    [self.view addSubview:resumeR];
    
    stopR = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [stopR setTitle:@"Stop" forState:UIControlStateNormal];
    [stopR setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    stopR.backgroundColor = [UIColor clearColor];
    stopR.titleLabel.font = font;
    size = [stopR.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    stopR.frame = CGRectMake(width*0.75 + 10, height-80 ,size.width +10, size.height + 10);
    UITapGestureRecognizer *stop = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopClick:)];
    [stopR addGestureRecognizer:stop];
    stopR.userInteractionEnabled = YES;
    [self.view addSubview:stopR];
    
    //player buttons
    recordP = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [recordP setTitle:@"Play" forState:UIControlStateNormal];
    [recordP setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    recordP.backgroundColor = [UIColor clearColor];
    recordP.titleLabel.font = font;
    size = [recordP.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    recordP.frame = CGRectMake(10, height-120 ,size.width +10, size.height + 10);
    UITapGestureRecognizer *Play = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playRecording:)];
    [recordP addGestureRecognizer:Play];
    recordP.userInteractionEnabled = YES;
    [self.view addSubview:recordP];
    
    pauseP = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pauseP setTitle:@"Pause" forState:UIControlStateNormal];
    [pauseP setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pauseP.backgroundColor = [UIColor clearColor];
    pauseP.titleLabel.font = font;
    size = [pauseP.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    pauseP.frame = CGRectMake(width*0.25 + 10, height-120 ,size.width +10, size.height + 10);
    UITapGestureRecognizer *pausePlaying = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pauseRecording:)];
    [pauseP addGestureRecognizer:pausePlaying];

    [self.view addSubview:pauseP];
    
//    resumeP = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [resumeP setTitle:@"Resume" forState:UIControlStateNormal];
//    [resumeP setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    resumeP.backgroundColor = [UIColor clearColor];
//    resumeP.titleLabel.font = font;
//    size = [resumeP.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
//    resumeP.frame = CGRectMake(width*0.5 + 10, height-120 ,size.width +10, size.height + 10);
//    [self.view addSubview:resumeP];
    
    stopP = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [stopP setTitle:@"Stop" forState:UIControlStateNormal];
    [stopP setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    stopP.backgroundColor = [UIColor clearColor];
    stopP.titleLabel.font = font;
    size = [stopP.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]];
    stopP.frame = CGRectMake(width*0.75 + 10, height-120 ,size.width +10, size.height + 10);
    UITapGestureRecognizer *Stop = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopRecording:)];
    [stopP addGestureRecognizer:Stop];
    stopP.userInteractionEnabled = YES;
    [self.view addSubview:stopP];
    
    
    flexItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    sendVoiceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(sendFile)];
    sendPhotoItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendPhoto)];
    [self setToolbarItems:@[flexItem,sendVoiceItem, flexItem, sendPhotoItem, flexItem]];
    [self.navigationController setToolbarHidden:NO];
    
}

//-(void)sendPhoto{
//    NSLog(@"starting uploadiong photo procedures");
//    
//    // 启动系统风火轮
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    //服务器给的域名
//    NSString *domainStr = @"http://10.236.52.85/test_2.php";
//    
//    //假如需要提交给服务器的参数是key＝1,class_id=100
//    //创建一个可变字典
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    //往字典里面添加需要提交的参数
//    
//    NSString *name = @"destop";
//    NSNumber *ID = [NSNumber numberWithInteger:12345];
//    NSString *description = @"fake password";
//    
//    [parametersDict setObject:name forKey:@"name"];
//    [parametersDict setObject:ID forKey:@"ID"];
//    [parametersDict setObject:description forKey:@"password"];
//    
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    //these serializers have both the normal type and the json type. determine which one to use
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    //do not user the requestSerializer here for the intended string is not a json string. user this if we are sending over an nsdata->json string
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
////    [manager.requestSerializer setValue:@"text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    [manager POST:domainStr parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        
//        //json解析
//        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        
//        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"---获取到的json格式的字典--%@",resultDict);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSLog(@"failure due to: %@", error.userInfo);
//    }];
//}


-(void)sendPhoto{
    NSLog(@"starting uploadiong photo procedures");
    
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //服务器给的域名
    NSString *domainStr = @"http://10.236.56.75/test_3.php";
    
    //假如需要提交给服务器的参数是key＝1,class_id=100
    //创建一个可变字典
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
    
    NSString *name = @"destop";
    NSNumber *ID = [NSNumber numberWithInteger:12345];
    NSString *description = @"testing photo upload function";
    
    [parametersDict setObject:name forKey:@"name"];
    [parametersDict setObject:ID forKey:@"ID"];
    [parametersDict setObject:description forKey:@"description"];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content_type"];
    [manager.requestSerializer setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"text/json", @"image/png", @"image/jpeg", nil];
    
//    [manager.requestSerializer setValue:@"application/json; text/html" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:domainStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *img = [UIImage imageNamed:@"wu"];
        NSData *data = UIImagePNGRepresentation(img);
        
        [formData appendPartWithFileData:data name:@"testingPhoto" fileName:@"wu.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //json解析
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"---获取到的json格式的字典--%@",resultDict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"failure due to: %@", error.userInfo);
    }];
    
//    [manager POST:domainStr parameters:parametersDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        UIImage *img = [UIImage imageNamed:@"wu"];
//        NSData *data = UIImagePNGRepresentation(img);
//        
////        [formData appendPartWithFileData:data name:@"testingPhoto" fileName:@"wu.png" mimeType:@"image/png"];
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        
//        //json解析
//        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        
//        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"---获取到的json格式的字典--%@",resultDict);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSLog(@"failure due to: %@", error.userInfo);
//        
//    }];
}


-(void)sendFile{
    NSLog(@"sending over voice file");
    
    // 启动系统风火轮
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //服务器给的域名
    NSString *domainStr = @"http://10.236.56.75/test_4.php";
    domainStr = [domainStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:config];
//    
//    NSURL *url = [NSURL URLWithString:@"http://10.209.68.42/download"];
//    NSURL *url2 = [NSURL URLWithString:[self.audioLocation stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//    
////    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:@"http://10.209.68.42/download" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileURL:url2 name:@"testingVoice" fileName:@"sample.wav" mimeType:@"audio/wav" error:nil];
//    } error:nil];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    NSURLSessionUploadTask *uploadTast = [manager uploadTaskWithRequest:request fromFile:url2 progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        }
//        else {
//            NSLog(@"Successfully send the audio file: %@ %@", response, responseObject);
//        }
//    }];
//    
//    [uploadTast resume];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"application/json"]];
    
    [manager POST:domainStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *path = self.audioLocation;
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        [formData appendPartWithFileData:data name:@"testingVoice" fileName:@"sample.wav" mimeType:@"audio/wav"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //json解析
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"---获取到的json格式的字典--%@",resultDict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"failure due to: %@", error.userInfo);

    }];
}


//recorder
- (void)recordClick:(UIButton *)sender{
    [photo_audio_Item validateMicrophoneAccess];
    [photo_audio_Item recordClick:sender];
}

- (void)pauseClick:(UIButton *)sender{
    [photo_audio_Item pauseClick:sender];
}

- (void)resumeClick:(UIButton *)sender{
    [photo_audio_Item resumeClick:sender];
}

- (void)stopClick:(UIButton *)sender{
    [photo_audio_Item stopClick:sender];
}


//player
-(void)playRecording:(UIButton*)sender{
    [photo_audio_Item playRecording:sender];
}

-(void) stopRecording : (UIButton *) sender{
    [photo_audio_Item stopRecording:sender];
}

-(void)pauseRecording: (UIButton*) sender{
    [photo_audio_Item pauseRecording:sender];
}


-(void)singleTap : (UITapGestureRecognizer*)recognizer{
    
    UILabel *lbl = [self.view viewWithTag:(int)pathChosen.row];
    
    if ([lbl isKindOfClass:[UILabel class]]){
        lbl.textColor = [UIColor redColor];
    }
    
    
    //prompt the user to change info
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"This is an Alert" message:@"change of info" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * textField){
        textField.placeholder = @"textLabel";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * textField){
        textField.placeholder = @"detailInfo";
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
        UITextField *text1 = alert.textFields.firstObject;
        UITextField *text2 = alert.textFields.lastObject;
        
    [self.delegate changeCellInfoWithText:text1.text andDetailInfo:text2.text onIndexPath:pathChosen];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)doubleTap : (UITapGestureRecognizer*)recognizer{
    
    //setup the background scroll view
    UIScrollView *bgView = [[UIScrollView alloc]init];
    //bgView.bounds = [UIScreen mainScreen].bounds;
    bgView.frame = (CGRect){0,0,self.view.bounds.size.width, self.view.bounds.size
        .height};
    bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *returnBack = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack:)];
    [bgView addGestureRecognizer:returnBack];
    
    enlargeView = (UIImageView*)recognizer.view;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = enlargeView.image;
    imageView.frame = [bgView convertRect:enlargeView.frame fromView:self.view];
    [bgView addSubview:imageView];
    
    [self.view addSubview:bgView];
    //[[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    
    returnImageView = imageView;
    originalFrame = imageView.frame;
    scrollView = bgView;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-enlargeView.image.size.height*[UIScreen mainScreen].bounds.size.width/enlargeView.image.size.width)/2,
            [UIScreen mainScreen].bounds.size.width,
            enlargeView.image.size.height*[UIScreen mainScreen].bounds.size.width/enlargeView.image.size.width);
        bgView.alpha=1;
    } completion:^(BOOL finished) {
    }];
}


-(void)goBack:(UITapGestureRecognizer *)tapBgRecognizer
{
    scrollView.contentOffset = CGPointZero;
    [UIView animateWithDuration:0.5 animations:^{
        returnImageView.frame = originalFrame;
        tapBgRecognizer.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [tapBgRecognizer.view removeFromSuperview];
        scrollView = nil;
        returnImageView = nil;
    }];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return returnImageView;
}




@end