//
//  tableViewController.h
//  experiment
//
//  Created by Sina on 16/6/17.
//  Copyright © 2016年 Qi Hu. All rights reserved.
//

#ifndef tableViewController_h
#define tableViewController_h

#import <UIKit/UIKit.h>
#import "FolderArray.h"
#import "detailViewController.h"

@interface tableViewController : UITableViewController <UITableViewDataSource, detailViewDelegate>


@property (nonatomic, strong) folderArray *tv_array;

@property (nonatomic, copy) NSString *uniqueID;

@end


#endif /* tableViewController_h */
