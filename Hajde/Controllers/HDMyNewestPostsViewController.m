//
//  HDMyNewestPostsViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDMyNewestPostsViewController.h"
#import "HDPostTableViewCell.h"

static NSString *HDPostTableViewCellIdentifier = @"HDPostTableViewCellIdentifier";

@interface HDMyNewestPostsViewController () <UITableViewDragLoadDelegate, UIGestureRecognizerDelegate>
{
    int _dataCount;
    BOOL tempIsOn;
    int tempPostsCount;
}

@end

@implementation HDMyNewestPostsViewController

@synthesize m_tableView;
@synthesize m_viewEmpty;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tempIsOn = false;
    
    _dataCount = 0;
    tempPostsCount = 0;
    
    [m_tableView registerClass:[HDPostTableViewCell class] forCellReuseIdentifier:HDPostTableViewCellIdentifier];
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showLoadMoreView = true;
    
    SVPROGRESSHUD_SHOW;
    [self initLoadNewestPostData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [GlobalData sharedGlobalData].g_strSelectedTab = SELECT_NEWEST;
    
    if ([GlobalData sharedGlobalData].g_togglePhotoIsOn) {
        [GlobalData sharedGlobalData].g_togglePhotoIsOn = false;
    } else if (tempIsOn && ![GlobalData sharedGlobalData].g_togglePhotoIsOn) {
        [self finishRefresh];
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

- (void)initLoadNewestPostData {
    
    [GlobalData sharedGlobalData].g_arrayMyNewestPost = [[NSMutableArray alloc] init];
    tempPostsCount = 0;
    _dataCount += LOAD_DATA_COUNT;
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    
    if ([GlobalData sharedGlobalData].g_toggleMyPostIsOn) {
        query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_userInfo.userID];
    }
    
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (posts.data.count > 0) {
            
            for (Post *post in posts.data) {
                
                PostData *record = [[PostData alloc] init];
                record.objectId = post.objectId;
                record.content = post.content;
                record.backColor = post.backColor;
                record.type = post.type;
                record.filePath = post.filePath;
                record.userID = post.userID;
                record.latitude = post.latitude;
                record.longitude = post.longitude;
                record.time = post.time;
                record.period = post.period;
                record.imgHeight = post.imgHeight;
                record.commentCount = post.commentCount;
                record.likeCount = post.likeCount;
                record.commentType = post.commentType;
                record.likeType = post.likeType;
                record.reportCount = post.reportCount;
                record.reportType = post.reportType;
                
                record.commentTypeArray = [[NSMutableArray alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                
                if (record.commentType != nil && ![record.commentType isEqualToString:@""]) {
                    
                    if ([record.commentType containsString:@";"]) {
                        NSArray *itemsComment = [post.commentType componentsSeparatedByString:@";"];
                        record.commentTypeArray = [itemsComment mutableCopy];
                    } else {
                        [record.commentTypeArray addObject:record.commentType];
                    }
                }
                
                if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
                 
                    if ([record.likeType containsString:@";"]) {
                        NSArray *itemsLike = [post.likeType componentsSeparatedByString:@";"];
                        record.likeTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.likeTypeArray addObject:record.likeType];
                    }
                }
                
                if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
                    
                    if ([record.reportType containsString:@";"]) {
                        NSArray *itemsLike = [post.reportType componentsSeparatedByString:@";"];
                        record.reportTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.reportTypeArray addObject:record.reportType];
                    }
                }
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
                    [[GlobalData sharedGlobalData].g_arrayMyNewestPost addObject:record];
                    tempPostsCount ++;
                }
                
            }
            
            if ([GlobalData sharedGlobalData].g_userInfo.postCount < tempPostsCount) {
                [GlobalData sharedGlobalData].g_userInfo.postCount = tempPostsCount;
                [[GlobalData sharedGlobalData] updateUserDataDB];
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
    
    if ([GlobalData sharedGlobalData].g_arrayMyNewestPost.count > 0) {
        m_viewEmpty.hidden = YES;
        [m_tableView reloadData];
    } else {
        m_viewEmpty.hidden = NO;
    }
    
    tempIsOn = true;
}

- (IBAction)onRefresh:(id)sender {
    
    SVPROGRESSHUD_SHOW;
    [self initLoadNewestPostData];
}

#pragma mark - Control datasource

- (void)finishRefresh {
    
//    _dataCount = 0;
    
    if (_dataCount == 0) {
        _dataCount = LOAD_DATA_COUNT;
    }
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    
    if ([GlobalData sharedGlobalData].g_toggleMyPostIsOn) {
        query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_userInfo.userID];
    }
    
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        if (posts.data.count > 0) {
            
            [GlobalData sharedGlobalData].g_arrayMyNewestPost = [[NSMutableArray alloc] init];
            tempPostsCount = 0;
            
            for (Post *post in posts.data) {
                
                PostData *record = [[PostData alloc] init];
                record.objectId = post.objectId;
                record.content = post.content;
                record.backColor = post.backColor;
                record.type = post.type;
                record.filePath = post.filePath;
                record.userID = post.userID;
                record.latitude = post.latitude;
                record.longitude = post.longitude;
                record.time = post.time;
                record.period = post.period;
                record.imgHeight = post.imgHeight;
                record.commentCount = post.commentCount;
                record.likeCount = post.likeCount;
                record.commentType = post.commentType;
                record.likeType = post.likeType;
                record.reportCount = post.reportCount;
                record.reportType = post.reportType;
                
                record.commentTypeArray = [[NSMutableArray alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                
                if (record.commentType != nil && ![record.commentType isEqualToString:@""]) {
                    
                    if ([record.commentType containsString:@";"]) {
                        NSArray *itemsComment = [post.commentType componentsSeparatedByString:@";"];
                        record.commentTypeArray = [itemsComment mutableCopy];
                    } else {
                        [record.commentTypeArray addObject:record.commentType];
                    }
                }
                
                if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
                    
                    if ([record.likeType containsString:@";"]) {
                        NSArray *itemsLike = [post.likeType componentsSeparatedByString:@";"];
                        record.likeTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.likeTypeArray addObject:record.likeType];
                    }
                }
                
                if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
                    
                    if ([record.reportType containsString:@";"]) {
                        NSArray *itemsLike = [post.reportType componentsSeparatedByString:@";"];
                        record.reportTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.reportTypeArray addObject:record.reportType];
                    }
                }
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
                    [[GlobalData sharedGlobalData].g_arrayMyNewestPost addObject:record];
                    tempPostsCount ++;
                }
                
            }
            
            if ([GlobalData sharedGlobalData].g_userInfo.postCount < tempPostsCount) {
                [GlobalData sharedGlobalData].g_userInfo.postCount = tempPostsCount;
                [[GlobalData sharedGlobalData] updateUserDataDB];
            }
            
            [self onSetEmptyView];
            
            [m_tableView finishRefresh];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
            
        } else {
            
            [GlobalData sharedGlobalData].g_userInfo.postCount = tempPostsCount;
            [[GlobalData sharedGlobalData] updateUserDataDB];
            
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

- (void)finishLoadMore {
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
    queryOption.offset = [NSNumber numberWithInt:_dataCount];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    
    if ([GlobalData sharedGlobalData].g_toggleMyPostIsOn) {
        query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_USER_ID, [GlobalData sharedGlobalData].g_userInfo.userID];
    }
    
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        if (posts.data.count > 0) {
            
            for (Post *post in posts.data) {
                
                PostData *record = [[PostData alloc] init];
                record.objectId = post.objectId;
                record.content = post.content;
                record.backColor = post.backColor;
                record.type = post.type;
                record.filePath = post.filePath;
                record.userID = post.userID;
                record.latitude = post.latitude;
                record.longitude = post.longitude;
                record.time = post.time;
                record.period = post.period;
                record.imgHeight = post.imgHeight;
                record.commentCount = post.commentCount;
                record.likeCount = post.likeCount;
                record.commentType = post.commentType;
                record.likeType = post.likeType;
                record.reportCount = post.reportCount;
                record.reportType = post.reportType;
                
                record.commentTypeArray = [[NSMutableArray alloc] init];
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                
                if (record.commentType != nil && ![record.commentType isEqualToString:@""]) {
                    
                    if ([record.commentType containsString:@";"]) {
                        NSArray *itemsComment = [post.commentType componentsSeparatedByString:@";"];
                        record.commentTypeArray = [itemsComment mutableCopy];
                    } else {
                        [record.commentTypeArray addObject:record.commentType];
                    }
                }
                
                if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
                    
                    if ([record.likeType containsString:@";"]) {
                        NSArray *itemsLike = [post.likeType componentsSeparatedByString:@";"];
                        record.likeTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.likeTypeArray addObject:record.likeType];
                    }
                }
                
                if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
                    
                    if ([record.reportType containsString:@";"]) {
                        NSArray *itemsLike = [post.reportType componentsSeparatedByString:@";"];
                        record.reportTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.reportTypeArray addObject:record.reportType];
                    }
                }
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
                    [[GlobalData sharedGlobalData].g_arrayMyNewestPost addObject:record];
                    tempPostsCount++;
                }
                
            }
            
            if ([GlobalData sharedGlobalData].g_userInfo.postCount < tempPostsCount) {
                [GlobalData sharedGlobalData].g_userInfo.postCount = tempPostsCount;
                [[GlobalData sharedGlobalData] updateUserDataDB];
            }
            
            [m_tableView finishLoadMore];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
            
        } else {
            
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GlobalData sharedGlobalData].g_arrayMyNewestPost.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayMyNewestPost[indexPath.row];
    
    if ([postData.type isEqualToString:POST_TYPE_AUDIO]) {
        
        UITableViewCell* cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PostAudioCell" forIndexPath:indexPath];
        
        AudioButton* m_btnPlay = (AudioButton*)[cell viewWithTag:1];
        UILabel* m_lblTime = (UILabel*)[cell viewWithTag:2];
        UILabel* m_lblPeriod = (UILabel*)[cell viewWithTag:3];
        UILabel* m_lblDistance = (UILabel*)[cell viewWithTag:4];
        UILabel* m_lblCommentCount = (UILabel*)[cell viewWithTag:5];
        UILabel* m_lblLikeCount = (UILabel*)[cell viewWithTag:6];
        UIButton* m_btnComment = (UIButton*)[cell viewWithTag:7];
        UIButton* m_btnLike = (UIButton*)[cell viewWithTag:8];
        UIButton* m_btnDislike = (UIButton*)[cell viewWithTag:9];
        UIView* m_viewBack = (UIView*)[cell viewWithTag:10];
        
        NSString *colorString = postData.backColor;
//        NSString *filePath = postData.filePath;
        NSString *time = postData.time;
        NSString *duration = postData.period;
        int commentCount = postData.commentCount;
        int likeCount = postData.likeCount;
        double latitude = [postData.latitude doubleValue];
        double longitude = [postData.longitude doubleValue];
        
        CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[GlobalData sharedGlobalData].g_userInfo.latitude longitude:[GlobalData sharedGlobalData].g_userInfo.longitude];
//        CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:50.4481127 longitude:30.4290111];

        m_viewBack.backgroundColor = [GlobalData colorWithHexString:colorString];
        m_lblTime.text = [[GlobalData sharedGlobalData] getFormattedTimeStamp:time];
        m_lblDistance.text = [[GlobalData sharedGlobalData] getFormattedDistance:loc1 toLocation:loc2];
        m_lblCommentCount.text = [[GlobalData sharedGlobalData] getFormattedCount:commentCount];
        m_lblLikeCount.text = [[GlobalData sharedGlobalData] getFormattedCount:likeCount];
        m_lblPeriod.text = [NSString stringWithFormat:@"%@", duration];
        
        if ([postData.commentTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
            [m_btnComment setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        } else {
            [m_btnComment setImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal];
        }
        
        if ([postData.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, LIKE_TYPE]]) {
            [m_btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            [m_btnDislike setImage:[UIImage imageNamed:@"dislike_normal"] forState:UIControlStateNormal];
        } else if ([postData.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, DISLIKE_TYPE]]) {
            [m_btnLike setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
            [m_btnDislike setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        } else {
            [m_btnLike setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
            [m_btnDislike setImage:[UIImage imageNamed:@"dislike_normal"] forState:UIControlStateNormal];
        }
        
        [m_btnPlay addTarget:self action:@selector(onPlayAudio:) forControlEvents:UIControlEventTouchUpInside];
        [m_btnComment addTarget:self action:@selector(onCommentPost:) forControlEvents:UIControlEventTouchUpInside];
        [m_btnLike addTarget:self action:@selector(onLikePost:) forControlEvents:UIControlEventTouchUpInside];
        [m_btnDislike addTarget:self action:@selector(onDislikePost:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([postData.userID isEqualToString:ADMIN_EMAIL]) {
            m_lblDistance.text = @"Hajde";
        }
        
        return cell;
        
    } else {
        
        HDPostTableViewCell *cell = (HDPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HDPostTableViewCellIdentifier forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        // Load data
        [cell setupCellWithData:postData];
        
        cell.btnReport.hidden = YES;
        
        [cell.btnLike addTarget:self action:@selector(onLikePost:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDislike addTarget:self action:@selector(onDislikePost:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnComment addTarget:self action:@selector(onCommentPost:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
            
            cell.backImage.userInteractionEnabled = true;
            
            UILongPressGestureRecognizer *lPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imgLongPressed:)];
            lPressed.delegate = self;
            lPressed.minimumPressDuration = 0.4;
            [cell.backImage addGestureRecognizer:lPressed];
        }
        
        if ([postData.userID isEqualToString:ADMIN_EMAIL]) {
            cell.labelLocation.text = @"Hajde";
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    PostData *dataDict = [GlobalData sharedGlobalData].g_arrayMyNewestPost[indexPath.row];
    
    if ([dataDict.type isEqualToString:POST_TYPE_AUDIO]) {
        return defaultSize.height;
    } else if ([dataDict.type isEqualToString:POST_TYPE_PHOTO]) {
//        return dataDict.imgHeight;
        return PHOTO_HEIGHT;
    } else {
        // Create our size
        CGSize cellSize = [HDPostTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            
            [((HDPostTableViewCell *)cellToSetup) setupCellWithData:dataDict];
            
            // return cell
            return cellToSetup;
        }];
        return cellSize.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [GlobalData sharedGlobalData].g_toggleCommentIsOn = false;
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = [GlobalData sharedGlobalData].g_arrayMyNewestPost[indexPath.row];
    
    [[GlobalData sharedGlobalData].g_tabBar goToPostDetails];
}

- (void)imgLongPressed:(UILongPressGestureRecognizer*)sender {
    
    UIImageView *imgView = (UIImageView*)sender.view;
    CGRect buttonFrameInTableView = [imgView convertRect:imgView.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayMyNewestPost[indexPath.row];
    
    [GlobalData sharedGlobalData].g_strPhotoUrl = postData.filePath;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPhotoDetails];
    
//    UIImageView *imgView = (UIImageView*)sender.view;
//    
//    if (sender.state == UIGestureRecognizerStateBegan)
//    {
//        
//    }
//    else if (sender.state == UIGestureRecognizerStateChanged)
//    {
//        
//    }
//    else if (sender.state == UIGestureRecognizerStateEnded)
//    {
//        
//    }    
}

- (void)onPlayAudio:(AudioButton *)button {
    
    CGRect buttonFrameInTableView = [button convertRect:button.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = [GlobalData sharedGlobalData].g_arrayMyNewestPost[indexPath.row];
    
    NSString* resourcePath = postData.filePath;
    
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioPlayer alloc] init];
    }
    
    if ([_audioPlayer.button isEqual:button]) {
        [_audioPlayer play];
    } else {
        [_audioPlayer stop];
        
        _audioPlayer.button = button;
        _audioPlayer.url = [NSURL URLWithString:resourcePath];
        
        [_audioPlayer play];
    }
    
}

- (void)onCommentPost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_toggleCommentIsOn = true;
    
    [GlobalData sharedGlobalData].g_postData = [[PostData alloc] init];
    [GlobalData sharedGlobalData].g_postData.commentTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.likeTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData.reportTypeArray = [[NSMutableArray alloc] init];
    [GlobalData sharedGlobalData].g_postData = [GlobalData sharedGlobalData].g_arrayMyNewestPost[indexPath.row];
    
    [[GlobalData sharedGlobalData].g_tabBar goToPostDetails];
}

- (void)onLikePost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [HDUtility likePostInBackground:indexPath dataArray:[GlobalData sharedGlobalData].g_arrayMyNewestPost];
    
    [m_tableView reloadData];

}

- (void)onDislikePost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [HDUtility dislikePostInBackground:sender indexPath:indexPath dataArray:[GlobalData sharedGlobalData].g_arrayMyNewestPost];
    
    [m_tableView reloadData];
    
}


@end
