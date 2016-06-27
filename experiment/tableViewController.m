//
//  tableViewController.m
//  experiment
//
//  Created by Sina on 16/6/17.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "tableViewController.h"
#import "tableViewCell.h"
#import "AVUnit.h"
#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "detailViewController.h"
#import "FMDatabase.h"
//#import "JASwipeCell.h"
//#import "JAActionButton.h"
#import "DRCellSlideAction.h"
#import "DRCellSlideGestureRecognizer.h"



@interface tableViewController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,MWPhotoBrowserDelegate>

@end

@implementation tableViewController{
    int currentIndex;
    NSMutableArray *mwPhotoArray;
    
    //initial photo content
    NSArray *contentArray;
    
    //local cache storage containing the two nsdata for two images
    //each array element contains: <small_data, big_data, small_address/assetURL>
    NSString *Plist_filePath;
    
    //DZNPhotoPickerController *imagePicker;
    
    UIImagePickerController *imgPickerController;
    UIBarButtonItem *pickImage;
    UIBarButtonItem *flexItem;
    UIBarButtonItem *add_Action;
    UIBarButtonItem *edit_action;
    NSString *folderIcon;
    UIVisualEffectView *blurView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    contentArray = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                     @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                     @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                     @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                     @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                     @"http://ww1.sinaimg.cn/thumbnail/9be2329dgw1etlyb1yu49j20c82p6qc1.jpg"
                     ];
    folderIcon = @"http://ico.ooopic.com/ajax/iconpng/?id=163778.png";
    
    [self loadIntoMWPhotoArray];
    
    [self initializeView];
    
    [self initializeTableView];
    
}

#pragma mark - UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
    folderArray *rootArray = [dict objectForKey:self.uniqueID];
    self.tv_array = rootArray;
    NSInteger count = rootArray.content_array.count;
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.f;
}


/*
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JASwipeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JASC"];
    [cell addActionButtons:[self leftButtons] withButtonWidth:100.f withButtonPosition:JAButtonLocationLeft];
    [cell addActionButtons:[self rightButtons] withButtonWidth:100.f withButtonPosition:JAButtonLocationRight];
    
    cell.delegate = self;
    
    NSInteger position = indexPath.row;
    AVUnit *unit = self.tv_array.content_array[position];
    
    if (!cell){
        cell = [[JASwipeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"JASC"];
    }
    
    int num = (int)position % self.tv_array.content_array.count;
    
    UIImage *img = [[UIImage alloc]initWithData:unit.small_data];
    cell.imageView.image = img;
    cell.imageView.tag = num;
    
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(continuousView:)];
    click.numberOfTapsRequired = 1;
    cell.imageView.userInteractionEnabled = YES;
    [cell.imageView addGestureRecognizer:click];
    
    cell.textLabel.text = unit.text_description ? unit.text_description : [NSString stringWithFormat:@"#%d", num];
    cell.detailTextLabel.text = unit.detail_description ? unit.detail_description : unit.big_address;
    
    cell.tag = (int)position;
    
    
    return cell;
}

-(NSArray*)leftButtons{
    __typeof(self) __weak weakSelf = self;
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"Delete" color:[UIColor redColor] handler:^(UIButton *actionButton, JASwipeCell *cell) {
        [cell completePinToTopViewAnimation];
        [weakSelf leftMostButtonSwipeCompleted:nil];
        NSLog(@"delete action triggered");
    }];
    return @[button1];
}

-(NSArray*)rightButtons{
     __typeof(self) __weak weakSelf = self;
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"Edit" color:[UIColor blueColor] handler:^(UIButton *actionButton, JASwipeCell *cell) {
        [cell completePinToTopViewAnimation];
        [weakSelf rightMostButtonSwipeCompleted:nil];
        NSLog(@"editing aciton triggered");
    }];
    
    JAActionButton *button2 = [JAActionButton actionButtonWithTitle:@"Share" color:[UIColor greenColor] handler:^(UIButton *actionButton, JASwipeCell *cell) {
        NSLog(@"sharing action triggered");
    }];
    return @[button1, button2];
}

- (void)rightMostButtonSwipeCompleted:(JASwipeCell *)cell {
	
}

- (void)leftMostButtonSwipeCompleted:(JASwipeCell *)cell {
	
}
*/





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger position = indexPath.row;
    
    //item is a folder
    if ([self.tv_array.content_array[position] isKindOfClass:[folderArray class]]){
        folderArray *subFolder = self.tv_array.content_array[position];
        //        NSInteger folderNum = subFolder.folder_count;
        //        NSInteger itemNum = subFolder.item_count;
        
        NSInteger folderNum = [subFolder obtainFolderCount];
        NSInteger itemNum = [subFolder obtainItemCount];
        
        NSString *reuseIdentifier = [NSString stringWithFormat:@"cellIdentifier:%@ %ld", @"folderCell", (long)[indexPath row]];
        
        tableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if (!cell){
            cell = [[tableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        }
        
        UIImage *img = [[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:[[NSURL alloc]initWithString:folderIcon]]];
        cell.imageView.image = img;
        int num = (int)position % self.tv_array.content_array.count;
        cell.imageView.tag = num;
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(continuousView:)];
        click.numberOfTapsRequired = 1;
        cell.imageView.userInteractionEnabled = YES;
        [cell.imageView addGestureRecognizer:click];
        
        if (subFolder.folderName){
            cell.textLabel.text = subFolder.folderName;
        }
        else{
            cell.textLabel.text = [NSString stringWithFormat:@"#%d", (int)position];
        }
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"This folder has %d folders and %d items", (int)folderNum, (int)itemNum];
        
        return cell;
    }
    
    //item is an AVUnit item
    else if ([self.tv_array.content_array[position] isKindOfClass:[AVUnit class]]){
        AVUnit *unit = self.tv_array.content_array[position];
        
        NSString *reuseIdentifier = [NSString stringWithFormat:@"cellIdentifier:%@ %ld", @"itemCell", (long)[indexPath row]];
        
        tableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if (!cell){
            cell = [[tableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: reuseIdentifier];
        }
        
        int num = (int)position % self.tv_array.content_array.count;
        
        UIImage *img = [[UIImage alloc]initWithData:unit.small_data];
        cell.imageView.image = img;
        cell.imageView.tag = num;
        
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(continuousView:)];
        click.numberOfTapsRequired = 1;
        cell.imageView.userInteractionEnabled = YES;
        [cell.imageView addGestureRecognizer:click];
        
        
        DRCellSlideGestureRecognizer *recognizer = [DRCellSlideGestureRecognizer new];
        DRCellSlideAction *action = [DRCellSlideAction actionForFraction:-0.25];
        action.behavior = DRCellSlideActionPullBehavior;
        action.activeBackgroundColor = [UIColor blueColor];
        action.inactiveBackgroundColor = [UIColor grayColor];
        action.icon = [UIImage imageNamed:@"add_image"];
        action.iconMargin = 20.f;
        action.elasticity = 0.f;
        action.didTriggerBlock = [self pullTriggerBlock];
        [recognizer addActions:action];
        [cell addGestureRecognizer:recognizer];
        
        
        cell.textLabel.text = unit.text_description ? unit.text_description : [NSString stringWithFormat:@"#%d", num];
        cell.detailTextLabel.text = unit.detail_description ? unit.detail_description : unit.big_address;
        
        
        cell.photoAddress = unit.big_address;
        cell.tag = (int)position;
        
        return cell;
        
    }
    
    else{
        NSLog(@"something wrong with the tv_array. containing illegal item types");
        return nil;
    }
}

-(DRCellSlideActionBlock)pullTriggerBlock{
    return ^(UITableView *tableView, NSIndexPath *indexPath){
        NSLog(@"pull action triggered");
    };
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger position = indexPath.row;
    
    //    NSString *address = contentArray[temp];
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
    folderArray *current_array = [dict objectForKey:self.uniqueID];
    
    //selected item is an AVUnit
    if ([current_array.content_array[position] isKindOfClass:[AVUnit class]]){
        
        detailViewController *detail;
        
        AVUnit *selected_unit = current_array.content_array[position];
        NSString *address = selected_unit.big_address;
        
        if (selected_unit.recording_address){
            cell.recordingAdress = selected_unit.recording_address;
            NSLog(@"already has a recording address");
        }
        else if(!cell.recordingAdress){
            // generating unique ID for the recording address
            CFUUIDRef ref = CFUUIDCreate(kCFAllocatorDefault);
            CFStringRef str_ref = CFUUIDCreateString(kCFAllocatorDefault, ref);
            NSString *unique_ID = [NSString stringWithString:(__bridge NSString*)str_ref];
            CFRelease(ref);
            CFRelease(str_ref);
            
            cell.recordingAdress = [self obtainCellRecordingAddressWithID: unique_ID];

#warning currently saving the unique ID property, probably not necessary. Consider trimming it from AVUnit/detailViewController/photo_item_unit
            selected_unit.recording_address = cell.recordingAdress;
            selected_unit.recording_unique_ID = unique_ID;
            
            NSMutableData *new_data = [[NSMutableData alloc]init];
            [dict setObject:current_array forKey:self.uniqueID];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:new_data];
            [archiver encodeObject:dict forKey:@"mainDict"];
            [archiver finishEncoding];
            if(![new_data writeToFile:Plist_filePath atomically:YES]){
                NSLog(@"something went wrong");
            }
        }
        
        detail = [[detailViewController alloc]initWithIndex:indexPath andAddress: address];
        detail.delegate = self;
        detail.photoLocation = cell.photoAddress;
        detail.audioLocation = cell.recordingAdress;
        detail.parant_unique_ID = selected_unit.parant_folder_ID;
        detail.audio_unique_ID = selected_unit.recording_unique_ID;
        
        
        [self.navigationController pushViewController:detail animated:YES];
        cell.selected = NO;
    }
    
    //selected item is a folderArray
    else if ([current_array.content_array[position] isKindOfClass:[folderArray class]]){
        folderArray *array = current_array.content_array[position];
        NSString *ID = array.unique_ID;
        
        tableViewController *tvController = [[tableViewController alloc]initWithStyle:UITableViewStylePlain];
        tvController.uniqueID = ID;
        
        [self.navigationController pushViewController:tvController animated:YES];
        cell.selected = NO;
    }
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //currently does not support deleting folders
    NSInteger position = indexPath.row;
    
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
    folderArray *editingArray = [dict objectForKey:self.uniqueID];
    
    if ([editingArray.content_array[position] isKindOfClass:[folderArray class]]){
        return YES;
    }
    
    else {
        return YES;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //need to diferentiate btw deleting an AVUnit and a Folder
    NSInteger position = indexPath.row;
    
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
    folderArray *editingArray = [dict objectForKey:self.uniqueID];
    
    if([editingArray.content_array[position] isKindOfClass: [AVUnit class]]){
        [editingArray.content_array removeObjectAtIndex:position];
        //        editingArray.item_count -= 1;
        
        [dict setObject:editingArray forKey:self.uniqueID];
        NSMutableData *data_new = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data_new];
        [archiver encodeObject:dict forKey:@"mainDict"];
        [archiver finishEncoding];
        if(![data_new writeToFile:Plist_filePath atomically:YES]){
            NSLog(@"something went wrong");
        }
    }
    
    else if([editingArray.content_array[position] isKindOfClass: [folderArray class]]){
        //this is the tricky part, when deleting a folder, it is imperative that we delete all the folders that is embeded in this folder
        folderArray *deleteingArray = editingArray.content_array[position];
        NSString *ID = deleteingArray.unique_ID;
        [self deleteFolderArrayWithID:ID];
    }
    
    [self.tableView setEditing:NO animated:YES];
    [self.tableView reloadData];
    
}

#pragma mark - initialization step

-(void)loadIntoMWPhotoArray{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    Plist_filePath = [documentDirectory stringByAppendingPathComponent:@"savedData.plist"];
    
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
    folderArray *rootArray = [dict objectForKey:self.uniqueID];
    
    self.tv_array = rootArray;
    
    mwPhotoArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *content = self.tv_array.content_array;
    [content enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[folderArray class]]){
            NSURL *url = [[NSURL alloc]initWithString:folderIcon];
            [mwPhotoArray addObject:[MWPhoto photoWithURL:url]];
        }
        else if ([obj isKindOfClass:[AVUnit class]]){
            AVUnit *unit = obj;
            NSURL *url = [NSURL URLWithString:unit.big_address];
            [mwPhotoArray addObject:[MWPhoto photoWithURL:url]];
        }
        else{
            NSLog(@"something funny in the folderArray's content_array");
        }
    }];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



-(void)continuousView: (UITapGestureRecognizer*)tap{
    //go to MW Photo Array
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
    int index = (int)tap.view.tag;
    currentIndex = index;
    [browser setCurrentPhotoIndex:currentIndex];
    
    [self.navigationController pushViewController:browser animated:YES];
    
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
}

-(void)initializeView{
    
    //setup navigation bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    self.title = @"Phoice";
    
    //setup barItems
    flexItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    //    pickImage = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(chooseImage:)];
    UIImage *img = [UIImage imageNamed:@"add_image"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = img;
    pickImage = [[UIBarButtonItem alloc]initWithCustomView:imgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImage:)];
    [imgView addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = pickImage;
    
    edit_action = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    
    add_Action = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFolder:)];
    [self setToolbarItems:@[edit_action,flexItem, add_Action] animated:NO];
    [self.navigationController setToolbarHidden:NO animated:YES];
}


-(void) initializeTableView{
    //new feature coming after IOS7
    self.automaticallyAdjustsScrollViewInsets = YES;
    //    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height *2 - self.navigationController.navigationBar.frame.origin.y) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorColor = [UIColor blackColor];
    
    self.tableView.allowsSelection = YES;
    self.tableView.userInteractionEnabled = YES;
    
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
}


#pragma mark - UIBarButton Actions

-(void)editAction: (UIBarButtonItem*) sender{
    //    NSLog(@"edit action activated");
    if(self.tableView.editing == NO){
        [self.tableView setEditing:YES animated:YES];
    }
    else if(self.tableView.editing == YES){
        [self.tableView setEditing:NO animated:YES];
    }
}


-(void)deleteFolderArrayWithID:(NSString*)uniqueID{
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
    folderArray *targetArray = [dict objectForKey:uniqueID];
    
    folderArray *parantArray = [dict objectForKey:targetArray.parant_ID];
    NSInteger position = -1;
    
    for (NSInteger i = 0; i < parantArray.content_array.count; i++){
        if ([parantArray.content_array[i]isKindOfClass:[folderArray class]]){
            folderArray *current_array = parantArray.content_array[i];
            NSString* current_ID = current_array.unique_ID;
            if ([current_ID isEqualToString:uniqueID]){
                position = i;
                break;
            }
        }
    }
    
    if(position == -1){
        NSLog(@"error finding the designated folderArray");
    }
    
    //base Case -- the array is empty
    //second case -- the array contains only AVUnits
    //same treatment as the above case, since the delete action discards all the embeded files && items
    if (targetArray.content_array.count == 0 || [self ifArrayContainAVUnitsOnly:targetArray]){
        NSString *parant_ID = targetArray.parant_ID;
        //remove the array from dictionary
        [dict removeObjectForKey:uniqueID];
        //also remove the array from its parant's content_array
        folderArray *parantArray = [dict objectForKey:parant_ID];
        [parantArray.content_array removeObjectAtIndex:position];
        //        parantArray.folder_count -= 1;
        [dict setObject:parantArray forKey:parantArray.unique_ID];
        
        NSMutableData *new_data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:new_data];
        [archiver encodeObject:dict forKey:@"mainDict"];
        [archiver finishEncoding];
        if(![new_data writeToFile:Plist_filePath atomically:YES]){
            NSLog(@"something went wrong");
        }
    }
    
    //last case -- the array contains both AVUnits and folders
    else{
        [targetArray.content_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[folderArray class]]){
                folderArray *subarray = obj;
                NSString *subID = subarray.unique_ID;
                [self deleteFolderArrayWithID:subID];
            }
        }];
        //deleting the parant
        [self deleteFolderArrayWithID:uniqueID];
    }
}

-(BOOL)ifArrayContainAVUnitsOnly: (folderArray*)array{
    //empty array
    if (array.content_array.count == 0){
        return YES;
    }
    
    else {
        for (NSInteger i = 0; i < array.content_array.count; i++){
            if ([array.content_array[i] isKindOfClass:[folderArray class]]){
                return NO;
            }
        }
    }
    return YES;
}

-(void)addAction: (UIBarButtonItem*) sender{
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    
    NSLog(@"add action activated");
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
    [blurView setFrame:CGRectMake(0, 0, width, height)];
    UITapGestureRecognizer *cancel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBlurView)];
    [blurView addGestureRecognizer:cancel];
    [self.view addSubview:blurView];
    
    
    UIImage *img_photo = [UIImage imageNamed:@"add_image"];
    UIImageView *imgView_photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    imgView_photo.contentMode = UIViewContentModeScaleAspectFit;
    imgView_photo.image = img_photo;
    imgView_photo.center = CGPointMake(width/2, height/4);
    UITapGestureRecognizer *tap_photo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseImage:)];
    [imgView_photo addGestureRecognizer:tap_photo];
    [self.view addSubview:imgView_photo];
    
    UIImage *img_folder = [UIImage imageNamed:@"add_folder"];
    UIImageView *imgView_folder = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    imgView_folder.contentMode = UIViewContentModeScaleAspectFit;
    imgView_folder.image = img_folder;
    imgView_folder.center = CGPointMake(width/2, height/5*3);
    UITapGestureRecognizer *tap_folder = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addFolder:)];
    [imgView_folder addGestureRecognizer:tap_folder];
    [self.view addSubview:imgView_folder];
    
}

-(void)removeBlurView{
    [blurView removeFromSuperview];
}

-(void)addFolder: (UIBarButtonItem*) sender{
    NSLog(@"adding new folder to current level");
    
    //prompt the user to give a name for the added folder
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"This is an alert" message:@"give a name to the new folder" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * textField){
        textField.placeholder = @"Folder Title";
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *givenText = alert.textFields.firstObject;
        NSString *userGivenName = givenText.text;
        
        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
        folderArray *current_array = [dict objectForKey:self.uniqueID];
        
        folderArray *emptyFolder = [[folderArray alloc]init];
        //    emptyFolder.folder_count = 0;
        //    emptyFolder.item_count = 0;
        if (userGivenName){
            emptyFolder.folderName = userGivenName;
        }
        else{
            emptyFolder.folderName = @"empty folder";
        }
        emptyFolder.content_array = [[NSMutableArray alloc]init];;
        NSUUID *uuid = [[NSUUID alloc]init];
        NSString *uid = [uuid UUIDString];
        emptyFolder.unique_ID = uid;
        emptyFolder.parant_ID = current_array.unique_ID;
        
        [current_array.content_array addObject:emptyFolder];
        //    current_array.folder_count += 1;
        
        //adding to current array
        [dict setObject:current_array forKey:self.uniqueID];
        
        //adding the new empty array
        [dict setObject:emptyFolder forKey:emptyFolder.unique_ID];
        
        NSMutableData *data_new = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data_new];
        [archiver encodeObject:dict forKey:@"mainDict"];
        [archiver finishEncoding];
        if(![data_new writeToFile:Plist_filePath atomically:YES]){
            NSLog(@"something went wrong");
        }
        [self.tableView reloadData];
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)chooseImage: (UIBarButtonItem*) sender{
    
    imgPickerController = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imgPickerController.sourceType];
        
    }
    imgPickerController.delegate = self;
    imgPickerController.allowsEditing = NO;
    
    [self presentViewController:imgPickerController animated:YES completion:^(void){
        NSLog(@"going into photo library");
    }];
}


//-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
//{
//    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
//
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
//
//    return scaledImage;   //返回的就是已经改变的图片
//}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"user canceled action, going back to phoice");
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chosenImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSURL *small_url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *small_address = [small_url absoluteString];
    
    NSData *big_data = UIImagePNGRepresentation(chosenImg);
    NSData *small_data = UIImageJPEGRepresentation(chosenImg, 0.5);
    
    //saving and updating
    NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:Plist_filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    NSMutableDictionary *dict = [unarchiver decodeObjectForKey:@"mainDict"];
    folderArray *current_array = [dict objectForKey:self.uniqueID];
    
    AVUnit *unit = [[AVUnit alloc]init];
    unit.small_address =  small_address;
    unit.small_data = small_data;
    unit.big_address = small_address;
    unit.big_data = big_data;
    
    unit.recording_address = nil;
    unit.text_description = nil;
    unit.detail_description = nil;
    unit.parant_folder_ID = self.uniqueID;
    
    BOOL contain = NO;
    
    for (NSInteger i = 0; i < current_array.content_array.count; i++){
        if ([current_array.content_array[i] isKindOfClass:[AVUnit class]]){
            AVUnit *next_unit = current_array.content_array[i];
            if ([next_unit.small_address isEqualToString:small_address]){
                contain = YES;
                break;
            }
        }
    }
    
    //alert if the user is selecting the same photo to incorporate
    if (contain){
        //tell the user to try again
        UIAlertController *repeatSelection = [UIAlertController alertControllerWithTitle:@"This is an Alert" message:@"repeated selection" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [repeatSelection addAction:cancel];
        
        [picker presentViewController:repeatSelection animated:YES completion:nil];
    }
    
    
    //prompt the user to enter these two fields
    __block NSString *description, *detail;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"This is an Alert" message:@"Input Photo Info" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * textField){
        textField.placeholder = @"textLabel";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * textField){
        textField.placeholder = @"detailInfo";
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *act){
        
        UITextField *text1 = alert.textFields.firstObject;
        UITextField *text2 = alert.textFields.lastObject;
        description = text1.text;
        detail = text2.text;
        
        if (![description isEqualToString: @""]){
            unit.text_description = description;
        }
        if (![detail isEqualToString:@""]){
            unit.detail_description = detail;
        }
        
        if(!contain){
            //put into the mwPhotoArray
            //            UIImage *img = [[UIImage alloc]initWithData:big_data];
            //            [mwPhotoArray addObject:[MWPhoto photoWithImage:img]];
            //save onto plist
            [current_array.content_array addObject:unit];
            //            current_array.item_count += 1;
            [dict setObject:current_array forKey:self.uniqueID];
            NSMutableData *data = [[NSMutableData alloc]init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
            [archiver encodeObject:dict forKey:@"mainDict"];
            [archiver finishEncoding];
            if(![data writeToFile:Plist_filePath atomically:YES]){
                NSLog(@"something went wrong");
            }
        }
        
        //back to Phoice
        [self dismissViewControllerAnimated:YES completion:^(void){
            NSLog(@"user selected something");
        }];
        
        //on completion need to reload the tableView
        [self.tableView reloadData];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action];
    [alert addAction:action2];
    
    [picker presentViewController:alert animated:YES completion:nil];
}




#pragma mark -  MWPhotoBrowserDelegate methods

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return mwPhotoArray.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if(index < mwPhotoArray.count){
        return [mwPhotoArray objectAtIndex:index];
    }
    
    return nil;
}


#pragma mark - other


//consider moving this to AVUnit
-(NSString*) obtainCellRecordingAddressWithID: (NSString*) unique_ID{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *myDirectory = [documentDirectory stringByAppendingPathComponent:@"recording addresses"];
    [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    NSString* filePath= [myDirectory stringByAppendingPathComponent:unique_ID];
    
    return filePath;
}

-(void)changeCellInfoWithText:(NSString *)string andDetailInfo:(NSString *)detail onIndexPath:(NSIndexPath *)indexpath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    
    cell.textLabel.text = string;
    cell.detailTextLabel.text = detail;
}

@end