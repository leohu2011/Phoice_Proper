//
//  detailView.h
//  experiment
//
//  Created by Qi Hu on 17/5/16.
//  Copyright © 2016 Qi Hu. All rights reserved.
//

#ifndef detailView_h
#define detailView_h
#import <UIKit/UIKit.h>

@class rootViewController, photoItem;

@protocol detailViewDelegate <NSObject>

-(void) changeCellInfoWithText: (NSString*) string andDetailInfo: (NSString*) detail onIndexPath: (NSIndexPath*) indexpath;


@end

@interface detailViewController : UIViewController

-(instancetype) initWithIndex:(NSIndexPath*)index andAddress: (NSString*) address;

@property (nonatomic, weak) id <detailViewDelegate> delegate;

@property (nonatomic, copy) NSString *photoLocation;

@property (nonatomic, copy) NSString *audioLocation;

@property (nonatomic, copy) NSString *parant_unique_ID;

@property (nonatomic, copy) NSString *audio_unique_ID;

@end



#endif /* detailView_h */
