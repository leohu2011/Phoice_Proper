//
//  tableViewCell.h
//  experiment
//
//  Created by Qi Hu on 16/5/16.
//  Copyright © 2016 Qi Hu. All rights reserved.
//

#ifndef tableViewCell_h
#define tableViewCell_h
#import <UIKit/UIKit.h>
#import "photoItem.h"

@interface tableViewCell : UITableViewCell

//typedef void (^updateBlock)(BOOL contain);

//@property (nonatomic, strong) NSArray *photoArray;

//@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, copy) NSString *photoAddress;

@property (nonatomic, copy) NSString *recordingAdress;


-(void)containRecordingInCell:(BOOL)contain;

@end


#endif /* tableViewCell_h */
