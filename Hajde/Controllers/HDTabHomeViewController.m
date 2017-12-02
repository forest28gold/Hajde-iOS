//
//  HDTabHomeViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDTabHomeViewController.h"
#import "HDNewestPostsViewController.h"
#import "HDMostCommentedViewController.h"
#import "HDMostVotesViewController.h"
#import "HDMyKarmaViewController.h"


@interface HDTabHomeViewController () <ViewPagerDataSource, ViewPagerDelegate>
{
    HDNewestPostsViewController *viewNewestCtrl;
    HDMostCommentedViewController *viewMostCommentedCtrl;
    HDMostVotesViewController *viewMostVotesCtrl;
    
    NSTimer *m_timer;
}

@property (nonatomic) NSUInteger numberOfTabs;

@end

@implementation HDTabHomeViewController

@synthesize m_viewTab, m_btnNewest, m_btnMostCommented, m_btnMostVotes, m_lblKarmaCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_lblKarmaCount.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.karmaScore];
    
    self.viewPagerCtrl = [[ViewPagerController alloc] init];
    self.viewPagerCtrl.view.frame = CGRectMake(0, 0, self.m_viewTab.frame.size.width, self.m_viewTab.frame.size.height + 5);
    self.viewPagerCtrl.delegate = self;
    self.viewPagerCtrl.dataSource = self;
    [self.m_viewTab addSubview:self.viewPagerCtrl.view];
    
    viewNewestCtrl = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_NEWEST_POSTS];
    viewMostCommentedCtrl = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_MOST_COMMENTED];
    viewMostVotesCtrl = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_MOST_VOTES];
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
    
    [GlobalData sharedGlobalData].g_strSelectedTab = SELECT_NEWEST;
    
    [GlobalData sharedGlobalData].g_ctrlTabHome = self;
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateKarmaScore) userInfo:nil repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [GlobalData sharedGlobalData].g_toggleMyPostIsOn = false;
    
    if ([[GlobalData sharedGlobalData].g_strSelectedTab isEqualToString:SELECT_NEWEST]) {
        [viewNewestCtrl viewWillAppear:NO];
    } else if ([[GlobalData sharedGlobalData].g_strSelectedTab isEqualToString:SELECT_MOST_COMMENTED]) {
        [viewMostCommentedCtrl viewWillAppear:NO];
    } else if ([[GlobalData sharedGlobalData].g_strSelectedTab isEqualToString:SELECT_MOST_VOTES]) {
        [viewMostVotesCtrl viewWillAppear:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateKarmaScore {
    
    m_lblKarmaCount.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.karmaScore];
}

- (void)onSetNewest {
    
    [m_btnNewest setBackgroundImage:[UIImage imageNamed:@"segument_newest_selected"] forState:UIControlStateNormal];
    [m_btnMostCommented setBackgroundImage:[UIImage imageNamed:@"segument_most_commented_normal"] forState:UIControlStateNormal];
    [m_btnMostVotes setBackgroundImage:[UIImage imageNamed:@"segument_most_votes_normal"] forState:UIControlStateNormal];
    
    [m_btnNewest setTitleColor:[GlobalData colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [m_btnMostCommented setTitleColor:[GlobalData colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    [m_btnMostVotes setTitleColor:[GlobalData colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    
}

- (void)onSetMostCommented {
    
    [m_btnNewest setBackgroundImage:[UIImage imageNamed:@"segument_newest_normal"] forState:UIControlStateNormal];
    [m_btnMostCommented setBackgroundImage:[UIImage imageNamed:@"segument_most_commented_selected"] forState:UIControlStateNormal];
    [m_btnMostVotes setBackgroundImage:[UIImage imageNamed:@"segument_most_votes_normal"] forState:UIControlStateNormal];
    
    [m_btnNewest setTitleColor:[GlobalData colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    [m_btnMostCommented setTitleColor:[GlobalData colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [m_btnMostVotes setTitleColor:[GlobalData colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
}

- (void)onSetMostVotes {
    
    [m_btnNewest setBackgroundImage:[UIImage imageNamed:@"segument_newest_normal"] forState:UIControlStateNormal];
    [m_btnMostCommented setBackgroundImage:[UIImage imageNamed:@"segument_most_commented_normal"] forState:UIControlStateNormal];
    [m_btnMostVotes setBackgroundImage:[UIImage imageNamed:@"segument_most_votes_selected"] forState:UIControlStateNormal];
    
    [m_btnNewest setTitleColor:[GlobalData colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    [m_btnMostCommented setTitleColor:[GlobalData colorWithHexString:@"#aab2bd"] forState:UIControlStateNormal];
    [m_btnMostVotes setTitleColor:[GlobalData colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self.viewPagerCtrl reloadData];
    
}

#pragma mark - Helpers

- (void)loadContent {
    self.numberOfTabs = 3;
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_viewTab.frame.size.width, 0)];
    view.backgroundColor = [UIColor clearColor];
    view.hidden = YES;
    return view;
    
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    if (index == 0) {
        return viewNewestCtrl;
    } else if (index == 1) {
        return viewMostCommentedCtrl;
    } else {
        return viewMostVotesCtrl;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 0.0;
        case ViewPagerOptionTabHeight:
            return 0.0;
        case ViewPagerOptionTabOffset:
            return 0.0;
        case ViewPagerOptionTabWidth:
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 0.0 : 0.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    return [UIColor clearColor];
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    
    if (index == 0) {
        [self onSetNewest];
    } else if (index == 1) {
        [self onSetMostCommented];
    } else {
        [self onSetMostVotes];
    }
    
}

-(IBAction)onGoToKarma:(id)sender {
    
    HDMyKarmaViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_MY_KARMA];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

-(IBAction)onSelectNewest:(id)sender {
    
    [self onSetNewest];
    [self.viewPagerCtrl selectTabAtIndex:0];
}

-(IBAction)onSelectMostCommented:(id)sender {
    
    [self onSetMostCommented];
    [self.viewPagerCtrl selectTabAtIndex:1];
}

-(IBAction)onSelectMostVotes:(id)sender {
    
    [self onSetMostVotes];
    [self.viewPagerCtrl selectTabAtIndex:2];
}



@end
