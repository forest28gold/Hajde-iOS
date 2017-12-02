//
//  HDKarmaViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/14/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDMyKarmaViewController.h"

@interface HDMyKarmaViewController () <UITableViewDragLoadDelegate>
{
    int _dataCount;
    int tempKarmaScore;
    BOOL karmaCalIsOn;
}

@property (nonatomic, strong) NSMutableArray *karmaDataArray;

@end

@implementation HDMyKarmaViewController

@synthesize m_tableView;
@synthesize m_viewEmpty;
@synthesize m_lblKarmaScore;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataCount = 0;
    tempKarmaScore = 0;
    
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showLoadMoreView = true;
    
    if ([GlobalData sharedGlobalData].g_userInfo.karmaScore > 0) {
        SVPROGRESSHUD_SHOW;
        karmaCalIsOn = false;
        [self initLoadKarmaScoreData];
    } else {
        karmaCalIsOn = true;
        m_viewEmpty.hidden = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    m_lblKarmaScore.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.karmaScore];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initLoadKarmaScoreData {
    
    self.karmaDataArray = [[NSMutableArray alloc] init];
    tempKarmaScore = 0;
    _dataCount += LOAD_DATA_COUNT;
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_userInfo.userID];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Karma class]] find:query response:^(BackendlessCollection *karmas) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (karmas.data.count > 0) {
            
            for (Karma *karma in karmas.data) {
                
                Karma *record = [[Karma alloc] init];
                
                record.objectId = karma.objectId;
                record.type = karma.type;
                record.backColor = karma.backColor;
                record.time = karma.time;
                record.score = karma.score;
                record.userID = karma.userID;
                
                [self.karmaDataArray addObject:record];
                
                tempKarmaScore += karma.score;
            }
            
            if (karmaCalIsOn) {
                [GlobalData sharedGlobalData].g_userInfo.karmaScore = tempKarmaScore;
                m_lblKarmaScore.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.karmaScore];
            }
            
            [self onSetEmptyView];
            
        } else {
            
            [self onSetEmptyView];
        }
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        
        [self onSetEmptyView];
        
    }];
    
}

- (void)onSetEmptyView {
    
    if (self.karmaDataArray.count > 0) {
        m_viewEmpty.hidden = YES;
        [m_tableView reloadData];
    } else {
        m_viewEmpty.hidden = NO;
    }
}

- (IBAction)onRefresh:(id)sender {
    
    SVPROGRESSHUD_SHOW;
    [self initLoadKarmaScoreData];
}

#pragma mark - Control datasource

- (void)finishRefresh
{
//    _dataCount = 0;
    
    if (_dataCount == 0) {
        _dataCount = LOAD_DATA_COUNT;
    }
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_userInfo.userID];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Karma class]] find:query response:^(BackendlessCollection *karmas) {

        if (karmas.data.count > 0) {
            
            self.karmaDataArray = [[NSMutableArray alloc] init];
            
            tempKarmaScore = 0;
            
            for (Karma *karma in karmas.data) {
                
                Karma *record = [[Karma alloc] init];
                
                record.objectId = karma.objectId;
                record.type = karma.type;
                record.backColor = karma.backColor;
                record.time = karma.time;
                record.score = karma.score;
                record.userID = karma.userID;
                
                [self.karmaDataArray addObject:record];
                
                tempKarmaScore += karma.score;

            }
            
            [self onSetEmptyView];
            
            [m_tableView finishRefresh];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
            
        } else {
            
            [self onSetEmptyView];
            
            [m_tableView finishRefresh];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
        }
        
    } error:^(Fault *fault) {
        
        [self onSetEmptyView];
        
        [m_tableView finishRefresh];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
        
    }];
    
}

- (void)finishLoadMore
{
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
    queryOption.offset = [NSNumber numberWithInt:_dataCount];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_userInfo.userID];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Karma class]] find:query response:^(BackendlessCollection *karmas) {
        
        if (karmas.data.count > 0) {
            
            for (Karma *karma in karmas.data) {
                
                Karma *record = [[Karma alloc] init];
                
                record.objectId = karma.objectId;
                record.type = karma.type;
                record.backColor = karma.backColor;
                record.time = karma.time;
                record.score = karma.score;
                record.userID = karma.userID;
                
                [self.karmaDataArray addObject:record];
                
                tempKarmaScore += karma.score;
            }
            
            if (karmaCalIsOn) {
                [GlobalData sharedGlobalData].g_userInfo.karmaScore = tempKarmaScore;
                m_lblKarmaScore.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.karmaScore];
            }
            
            [m_tableView finishLoadMore];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
            
        } else {
            
            [GlobalData sharedGlobalData].g_userInfo.karmaScore = tempKarmaScore;
            m_lblKarmaScore.text = [NSString stringWithFormat:@"%d", [GlobalData sharedGlobalData].g_userInfo.karmaScore];
            [[GlobalData sharedGlobalData] updateUserDataDB];
            
            [m_tableView finishLoadMore];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
        }
        _dataCount += LOAD_DATA_COUNT;
        
    } error:^(Fault *fault) {
        
        [m_tableView finishLoadMore];
        [m_tableView reloadData];
        m_tableView.showLoadMoreView = true;
    }];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:1];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //send load more request(generally network request) here
    
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:1];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.karmaDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"KarmaCell" forIndexPath:indexPath];
    
    Karma *record = self.karmaDataArray[indexPath.row];
    
    UILabel *m_lblKarmaTitle = (UILabel *)[_cell viewWithTag:1];
    UILabel *m_lblKarmaDescription = (UILabel *)[_cell viewWithTag:2];
    UILabel *m_lblKarmaCount = (UILabel *)[_cell viewWithTag:3];
    UILabel *m_lblKarmaTime = (UILabel *)[_cell viewWithTag:4];
    UIView *m_viewKarmaBack = (UIView *)[_cell viewWithTag:5];
    
    if ([record.type isEqualToString:KARMA_POST]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_increased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_from_posting", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"+%d", record.score];
    } else if ([record.type isEqualToString:KARMA_COMMENT]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_increased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_from_commenting", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"+%d", record.score];
    } else if ([record.type isEqualToString:KARMA_VOTE_LIKE]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_increased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_from_upvote_post", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"+%d", record.score];
    } else if ([record.type isEqualToString:KARMA_VOTE_DISLIKE]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_increased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_from_downvote_post", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"+%d", record.score];
    } else if ([record.type isEqualToString:KARMA_COMMENT_LIKE]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_increased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_from_upvote_comment", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"+%d", record.score];
    } else if ([record.type isEqualToString:KARMA_COMMENT_DISLIKE]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_increased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_from_downvote_comment", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"+%d", record.score];
    } else if ([record.type isEqualToString:KARMA_ABUSE]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_increased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_from_report_post", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"+%d", record.score];
    } else if ([record.type isEqualToString:KARMA_COMMENT_ABUSE]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_increased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_from_report_comment", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"+%d", record.score];
    } else if ([record.type isEqualToString:KARMA_DECREASE_COMMENT]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_decreased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_someone_downvote_comment", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"%d", record.score];
    } else if ([record.type isEqualToString:KARMA_DECREASE_POST]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_decreased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_someone_downvote_post", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"%d", record.score];
    } else if ([record.type isEqualToString:KARMA_DECREASE_DELETE_COMMENT]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_decreased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_comment_5_downvotes", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"%d", record.score];
    } else if ([record.type isEqualToString:KARMA_DECREASE_DELETE_POST]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_decreased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_post_5_downvotes", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"%d", record.score];
    } else if ([record.type isEqualToString:KARMA_LOGIN]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_daily_add", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_daily_login", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"+%d", record.score];
    } else if ([record.type isEqualToString:KARMA_REPORT_DELETE_COMMENT]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_decreased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_delete_comment", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"%d", record.score];
    } else if ([record.type isEqualToString:KARMA_REPORT_DELETE_POST]) {
        m_lblKarmaTitle.text = NSLocalizedString(@"karma_decreased", "");
        m_lblKarmaDescription.text = NSLocalizedString(@"karma_delete_post", "");
        m_lblKarmaCount.text = [NSString stringWithFormat:@"%d", record.score];
    }
    
    m_viewKarmaBack.backgroundColor = [UIColor colorWithHexString:record.backColor];
    m_lblKarmaTime.text = [NSString stringWithFormat:@"%@ %@", [[GlobalData sharedGlobalData] getFormattedTimeStamp:record.time], NSLocalizedString(@"ago", "")];
       
    return _cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
