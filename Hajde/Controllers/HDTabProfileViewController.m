//
//  HDTabProfileViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDTabProfileViewController.h"
#import "HDMyPostsViewController.h"
#import "HDMyKarmaViewController.h"
#import "HDMyCommentsViewController.h"
#import "HDMyVotesViewController.h"

@interface HDTabProfileViewController ()
{
    NSTimer *m_timer;
}

@end

@implementation HDTabProfileViewController

@synthesize m_btnMyPosts, m_btnMyComments, m_btnMyVotes, m_lblKarmaScore;
@synthesize m_lblDayTime, m_lblHourTime, m_lblMinuteTime;
@synthesize m_lblPostCount, m_lblCommentCount, m_lblVoteCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_btnMyPosts.layer.borderWidth = 4.f;
    m_btnMyPosts.layer.borderColor = [UIColor whiteColor].CGColor;
    
    m_btnMyComments.layer.borderWidth = 4.f;
    m_btnMyComments.layer.borderColor = [UIColor whiteColor].CGColor;
    
    m_btnMyVotes.layer.borderWidth = 4.f;
    m_btnMyVotes.layer.borderColor = [UIColor whiteColor].CGColor;
    
    m_lblKarmaScore.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.karmaScore];
    
    m_lblDayTime.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_spentDays];
    m_lblHourTime.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_spentHours];
    m_lblMinuteTime.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_spentMins];
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateSpentTime) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initSetMyProfileData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [m_timer invalidate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initSetMyProfileData {
    
    m_lblPostCount.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.postCount];
    m_lblCommentCount.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.commentCount];
    m_lblVoteCount.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.voteCount];
}

- (void)updateSpentTime {
    
    m_lblKarmaScore.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.karmaScore];
    
    m_lblDayTime.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_spentDays];
    m_lblHourTime.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_spentHours];
    m_lblMinuteTime.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_spentMins];

}


-(IBAction)onGoToKarma:(id)sender {
    
    HDMyKarmaViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_MY_KARMA];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

-(IBAction)onProfilePosts:(id)sender {

    [GlobalData sharedGlobalData].g_toggleMyPostIsOn = true;
    
    HDMyPostsViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_MY_POSTS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

-(IBAction)onProfileVotes:(id)sender {
    
    [GlobalData sharedGlobalData].g_toggleMyPostIsOn = true;
    
    HDMyVotesViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_MY_VOTES];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

-(IBAction)onComments:(id)sender {
    
    [GlobalData sharedGlobalData].g_toggleMyPostIsOn = true;
    
    HDMyCommentsViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_MY_COMMENTS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}


@end
