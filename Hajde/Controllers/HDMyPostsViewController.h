//
//  HDMyPostsViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 5/3/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"

@interface HDMyPostsViewController : UIViewController

@property (nonatomic, strong) ViewPagerController *viewPagerCtrl;

@property (strong, nonatomic) IBOutlet UILabel *m_lblKarmaCount;
@property (strong, nonatomic) IBOutlet UIView *m_viewTab;
@property (strong, nonatomic) IBOutlet UIButton *m_btnNewest;
@property (strong, nonatomic) IBOutlet UIButton *m_btnMostCommented;
@property (strong, nonatomic) IBOutlet UIButton *m_btnMostVotes;

@end
