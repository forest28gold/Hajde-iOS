//
//  STUReviewTableViewCell.h
//  StyleUp
//
//  Created by AppsCreationTech on 2/5/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HTKDynamicResizingTableViewCell.h"
#import "HTKDynamicResizingCellProtocol.h"

/**
 * Default cell size. This is required to properly size cells.
 */
#define DEFAULT_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 110}

/**
 * Sample CollectionViewCell that implements the dynamic sizing protocol.
 */
@interface HDPostTableViewCell : HTKDynamicResizingTableViewCell

@property (nonatomic, strong) UILabel *labelPost;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UILabel *labelLocation;
@property (nonatomic, strong) UILabel *labelComments;
@property (nonatomic, strong) UILabel *labelLikes;
@property (nonatomic, strong) UIImageView *imgLocation;
@property (nonatomic, strong) UIButton *btnComment;
@property (nonatomic, strong) UIButton *btnLike;
@property (nonatomic, strong) UIButton *btnDislike;
@property (nonatomic, strong) UIView *viewSeperate;
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIImageView *backOverlayImage;
@property (nonatomic, strong) UIButton *btnReport;

/**
 * Sets up the cell with data
 */
- (void)setupCellWithData:(PostData *)postData
;

@end
