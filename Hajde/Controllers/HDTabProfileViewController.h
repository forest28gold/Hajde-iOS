//
//  HDTabProfileViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDTabProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *m_btnMyPosts;
@property (strong, nonatomic) IBOutlet UIButton *m_btnMyComments;
@property (strong, nonatomic) IBOutlet UIButton *m_btnMyVotes;

@property (strong, nonatomic) IBOutlet UILabel *m_lblKarmaScore;

@property (strong, nonatomic) IBOutlet UILabel *m_lblPostCount;
@property (strong, nonatomic) IBOutlet UILabel *m_lblCommentCount;
@property (strong, nonatomic) IBOutlet UILabel *m_lblVoteCount;

@property (strong, nonatomic) IBOutlet UILabel *m_lblDayTime;
@property (strong, nonatomic) IBOutlet UILabel *m_lblHourTime;
@property (strong, nonatomic) IBOutlet UILabel *m_lblMinuteTime;

@end
