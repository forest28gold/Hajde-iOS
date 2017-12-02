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
#define DEFAULT_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 85}

/**
 * Sample CollectionViewCell that implements the dynamic sizing protocol.
 */
@interface HDPrivacyTableViewCell : HTKDynamicResizingTableViewCell

/**
 * Sets up the cell with data
 */
- (void)setupCellWithData:(TermsOfUse *)data;

@end
