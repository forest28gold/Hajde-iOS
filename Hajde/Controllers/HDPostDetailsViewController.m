//
//  HDPostDetailsViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/27/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDPostDetailsViewController.h"
#import "HDPostTableViewCell.h"
#import "HDCommentTableViewCell.h"
#import "NirKxMenu.h"

static NSString *HDPostTableViewCellIdentifier = @"HDPostTableViewCellIdentifier";
static NSString *HDCommentTableViewCellIdentifier = @"HDCommentTableViewCellIdentifier";

@interface HDPostDetailsViewController () <UITableViewDragLoadDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    
    int _dataCount;
    BOOL toggleKeyboardIsOn;
    NSIndexPath *tempIndexPath;
}

@property (nonatomic, strong) NSMutableArray *commentDataArray;

@end

@implementation HDPostDetailsViewController

@synthesize m_tableView, containerView, textView, m_btnSend, m_lblTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if ([GlobalData sharedGlobalData].g_toggleCommentIsOn) {
        m_lblTitle.text = NSLocalizedString(@"comments", "");
    } else {
        m_lblTitle.text = NSLocalizedString(@"post_details", "");
    }
    
    [self setupLocationManager];
    [_locationManager startUpdatingLocation];
    
    toggleKeyboardIsOn = false;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.m_tableView addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
//    textView.layer.masksToBounds = YES;
//    textView.layer.cornerRadius = 5;
//    textView.layer.borderWidth = 1.f;
//    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    textView.userInteractionEnabled = YES;
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    textView.returnKeyType = UIReturnKeyGo; //just as an example
    textView.font = [UIFont systemFontOfSize:13.0f];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholder = NSLocalizedString(@"enter_comment", "");
    textView.textColor = [UIColor darkGrayColor];
    
    [m_btnSend addTarget:self action:@selector(onCommentPost:) forControlEvents:UIControlEventTouchUpInside];
    
    _dataCount = 0;
    
    [m_tableView registerClass:[HDPostTableViewCell class] forCellReuseIdentifier:HDPostTableViewCellIdentifier];
    [m_tableView registerClass:[HDCommentTableViewCell class] forCellReuseIdentifier:HDCommentTableViewCellIdentifier];
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showLoadMoreView = true;
    
    self.commentDataArray = [[NSMutableArray alloc] init];
    [self.commentDataArray addObject:[GlobalData sharedGlobalData].g_postData];
    
    if ([GlobalData sharedGlobalData].g_postData.commentCount > 0) {
        SVPROGRESSHUD_SHOW;
        [self initLoadPostCommentData];
    }
    
    if ([GlobalData sharedGlobalData].g_toggleCommentIsOn) {
        [GlobalData sharedGlobalData].g_toggleCommentIsOn = false;
        [textView becomeFirstResponder];
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

- (void)setupLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [_locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark Location methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        
        [GlobalData sharedGlobalData].g_userInfo.latitude = currentLocation.coordinate.latitude;
        [GlobalData sharedGlobalData].g_userInfo.longitude = currentLocation.coordinate.longitude;
        
        NSLog(@"latitude -> %f,  longitude -> %f", [GlobalData sharedGlobalData].g_userInfo.latitude, [GlobalData sharedGlobalData].g_userInfo.longitude);
        
    }
    [_locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    //    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Application failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //
    //    [errorAlert show];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    if (!toggleKeyboardIsOn) {
        CGRect tableViewFrame = m_tableView.frame;
        tableViewFrame.size.height = m_tableView.frame.size.height - keyboardBounds.size.height;
        m_tableView.frame = tableViewFrame;
    }
    
    // commit animations
    [UIView commitAnimations];
    
    toggleKeyboardIsOn = true;
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    if (toggleKeyboardIsOn) {
        CGRect tableViewFrame = m_tableView.frame;
        tableViewFrame.size.height = self.view.bounds.size.height - containerFrame.size.height - 55;
        m_tableView.frame = tableViewFrame;
    }
    
    // commit animations
    [UIView commitAnimations];
    
    toggleKeyboardIsOn = false;
}

- (void)showKeyboard {
    
    CGRect keyboardBounds;
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // set views with new info
    containerView.frame = containerFrame;
    
    if (!toggleKeyboardIsOn) {
        CGRect tableViewFrame = m_tableView.frame;
        tableViewFrame.size.height = m_tableView.frame.size.height - keyboardBounds.size.height;
        m_tableView.frame = tableViewFrame;
    }
    
    // commit animations
    [UIView commitAnimations];
    
    toggleKeyboardIsOn = true;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // set views with new info
    containerView.frame = containerFrame;
    
    CGRect tableViewFrame = m_tableView.frame;
    tableViewFrame.size.height = self.view.bounds.size.height - containerFrame.size.height - 55;
    m_tableView.frame = tableViewFrame;

    toggleKeyboardIsOn = false;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
    
    CGRect tableViewFrame = m_tableView.frame;
    tableViewFrame.size.height += diff;
    m_tableView.frame = tableViewFrame;
    
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView {
    
    if (growingTextView.text.length > 200) {
        growingTextView.text = [growingTextView.text substringToIndex:200];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (growingTextView.text.length > 200) {
        growingTextView.text = [growingTextView.text substringToIndex:200];
    }
    
    return true;
}

- (void)initLoadPostCommentData {
    
    _dataCount += LOAD_DATA_COUNT;
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"time DESC"];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_POST_ID, [GlobalData sharedGlobalData].g_postData.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[ActivityPost class]] find:query response:^(BackendlessCollection *comments) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (comments.data.count > 0) {
            
            for (ActivityPost *comment in comments.data) {
                
                ActivityPostData *record = [[ActivityPostData alloc] init];
                record.objectId = comment.objectId;
                record.postId = comment.postId;
                record.backColor = comment.backColor;
                record.comment = comment.comment;
                record.fromUser = comment.fromUser;
                record.toUser = comment.toUser;
                record.latitude = comment.latitude;
                record.longitude = comment.longitude;
                record.time = comment.time;
                record.likeCount = comment.likeCount;
                record.likeType = comment.likeType;
                record.reportCount = comment.reportCount;
                record.reportType = comment.reportType;
                
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                
                if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
                    
                    if ([record.likeType containsString:@";"]) {
                        NSArray *itemsLike = [comment.likeType componentsSeparatedByString:@";"];
                        record.likeTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.likeTypeArray addObject:record.likeType];
                    }
                }
                
                if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
                    
                    if ([record.reportType containsString:@";"]) {
                        NSArray *itemsLike = [comment.reportType componentsSeparatedByString:@";"];
                        record.reportTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.reportTypeArray addObject:record.reportType];
                    }
                }
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
                    [self.commentDataArray addObject:record];
                }

            }
            
             [m_tableView reloadData];
            
        } else {
            
             [m_tableView reloadData];
        }
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        
         [m_tableView reloadData];
        
    }];
    
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
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_POST_ID, [GlobalData sharedGlobalData].g_postData.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[ActivityPost class]] find:query response:^(BackendlessCollection *comments) {
        
        self.commentDataArray = [[NSMutableArray alloc] init];
        [self.commentDataArray addObject:[GlobalData sharedGlobalData].g_postData];
        
        if (comments.data.count > 0) {
            
            for (ActivityPost *comment in comments.data) {
                
                ActivityPostData *record = [[ActivityPostData alloc] init];
                record.objectId = comment.objectId;
                record.postId = comment.postId;
                record.backColor = comment.backColor;
                record.comment = comment.comment;
                record.fromUser = comment.fromUser;
                record.toUser = comment.toUser;
                record.latitude = comment.latitude;
                record.longitude = comment.longitude;
                record.time = comment.time;
                record.likeCount = comment.likeCount;
                record.likeType = comment.likeType;
                record.reportCount = comment.reportCount;
                record.reportType = comment.reportType;
                
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                
                if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
                    
                    if ([record.likeType containsString:@";"]) {
                        NSArray *itemsLike = [comment.likeType componentsSeparatedByString:@";"];
                        record.likeTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.likeTypeArray addObject:record.likeType];
                    }
                }
                
                if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
                    
                    if ([record.reportType containsString:@";"]) {
                        NSArray *itemsLike = [comment.reportType componentsSeparatedByString:@";"];
                        record.reportTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.reportTypeArray addObject:record.reportType];
                    }
                }
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
                    [self.commentDataArray addObject:record];
                }
                
            }
            
            [m_tableView finishRefresh];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
            
        } else {
            
            [m_tableView finishRefresh];
            [m_tableView reloadData];
            m_tableView.showLoadMoreView = true;
        }
        
    } error:^(Fault *fault) {
        
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
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_POST_ID, [GlobalData sharedGlobalData].g_postData.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[ActivityPost class]] find:query response:^(BackendlessCollection *comments) {

        if (comments.data.count > 0) {
            
            for (ActivityPost *comment in comments.data) {
                
                ActivityPostData *record = [[ActivityPostData alloc] init];
                record.objectId = comment.objectId;
                record.postId = comment.postId;
                record.backColor = comment.backColor;
                record.comment = comment.comment;
                record.fromUser = comment.fromUser;
                record.toUser = comment.toUser;
                record.latitude = comment.latitude;
                record.longitude = comment.longitude;
                record.time = comment.time;
                record.likeCount = comment.likeCount;
                record.likeType = comment.likeType;
                record.reportCount = comment.reportCount;
                record.reportType = comment.reportType;
                
                record.likeTypeArray = [[NSMutableArray alloc] init];
                record.reportTypeArray = [[NSMutableArray alloc] init];
                
                if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
                    
                    if ([record.likeType containsString:@";"]) {
                        NSArray *itemsLike = [comment.likeType componentsSeparatedByString:@";"];
                        record.likeTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.likeTypeArray addObject:record.likeType];
                    }
                }
                
                if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
                    
                    if ([record.reportType containsString:@";"]) {
                        NSArray *itemsLike = [comment.reportType componentsSeparatedByString:@";"];
                        record.reportTypeArray = [itemsLike mutableCopy];
                    } else {
                        [record.reportTypeArray addObject:record.reportType];
                    }
                }
                
                if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
                    [self.commentDataArray addObject:record];
                }
                
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
    return self.commentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        PostData *postData = self.commentDataArray[indexPath.row];
        
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
            UIButton* m_btnReport = (UIButton*)[cell viewWithTag:11];
            
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
//            CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:50.4481127 longitude:30.4290111];
            
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
            
//            [m_btnComment setEnabled:false];
            [m_btnPlay addTarget:self action:@selector(onPlayAudio:) forControlEvents:UIControlEventTouchUpInside];
            [m_btnReport addTarget:self action:@selector(onReportPost:) forControlEvents:UIControlEventTouchUpInside];
            [m_btnLike addTarget:self action:@selector(onLikePost:) forControlEvents:UIControlEventTouchUpInside];
            [m_btnDislike addTarget:self action:@selector(onDislikePost:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([postData.userID isEqualToString:ADMIN_EMAIL]) {
                m_lblDistance.text = @"Hajde";
                m_btnReport.hidden = YES;
            }
            
            return cell;
            
        } else {
            
            HDPostTableViewCell *cell = (HDPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HDPostTableViewCellIdentifier forIndexPath:indexPath];
            cell.clipsToBounds = YES;
            
            // Load data
            [cell setupCellWithData:postData];
            
//            [cell.btnComment setEnabled:false];
            [cell.btnReport addTarget:self action:@selector(onReportPost:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnLike addTarget:self action:@selector(onLikePost:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnDislike addTarget:self action:@selector(onDislikePost:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([postData.type isEqualToString:POST_TYPE_PHOTO]) {
                
                cell.backImage.userInteractionEnabled = true;
                
                UITapGestureRecognizer *tap_photo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPhoto:)];
                [cell.backImage addGestureRecognizer:tap_photo];
            }
            
            if ([postData.userID isEqualToString:ADMIN_EMAIL]) {
                cell.labelLocation.text = @"Hajde";
                cell.btnReport.hidden = YES;
            }
            
            return cell;
        }
        
    } else {
        
        ActivityPostData *commentData = self.commentDataArray[indexPath.row];
        
        HDCommentTableViewCell *cell = (HDCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HDCommentTableViewCellIdentifier forIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        // Load data
        [cell setupCellWithData:commentData];
        
        if ([commentData.fromUser isEqualToString:[GlobalData sharedGlobalData].g_userInfo.userID]) {
            cell.imgMyComment.hidden = NO;
            cell.labelMyComment.hidden = NO;
        } else {
            cell.imgMyComment.hidden = YES;
            cell.labelMyComment.hidden = YES;
        }
        
        [cell.btnReport addTarget:self action:@selector(onReportComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLike addTarget:self action:@selector(onLikeComment:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDislike addTarget:self action:@selector(onDislikeComment:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    if (indexPath.row == 0) {
        
        PostData *dataDict = self.commentDataArray[indexPath.row];
        
        if ([dataDict.type isEqualToString:POST_TYPE_AUDIO]) {
            return defaultSize.height;
        } else if ([dataDict.type isEqualToString:POST_TYPE_PHOTO]) {
//            return dataDict.imgHeight;
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
        
    } else {
        
        ActivityPostData *dataDict = self.commentDataArray[indexPath.row];
        
        // Create our size
        CGSize cellSize = [HDCommentTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
            
            [((HDCommentTableViewCell *)cellToSetup) setupCellWithData:dataDict];
            
            // return cell
            return cellToSetup;
        }];
        return cellSize.height;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)onTapPhoto:(UITapGestureRecognizer*)sender
{
    UIImageView *imgView = (UIImageView*)sender.view;
    CGRect buttonFrameInTableView = [imgView convertRect:imgView.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    PostData *postData = self.commentDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_strPhotoUrl = postData.filePath;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPhotoDetails];
}

- (void)onPlayAudio:(AudioButton *)button {
    
    NSString* resourcePath = [GlobalData sharedGlobalData].g_postData.filePath;
    
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

- (void)onReportPost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    KxMenuItem *item = [KxMenuItem menuItem:NSLocalizedString(@"abuse", "") image:[UIImage imageNamed:@"report_abuse"] target:self action:@selector(onReportPostAbuse:)];
    NSArray *menuItems = [[NSArray alloc] initWithObjects:item, nil];
    [KxMenu setTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    Color txtColor, backColor;
    txtColor.R = 0.36; txtColor.G = 0.36; txtColor.B = 0.36;
    backColor.R = 1; backColor.G = 1; backColor.B = 1;
    
    OptionalConfiguration options;
    options.arrowSize = 9;
    options.marginXSpacing = 5;
    options.marginYSpacing = 7;
    options.intervalSpacing = 25;
    options.menuCornerRadius = 3;
    options.maskToBackground = true;
    options.shadowOfMenu = false;
    options.hasSeperatorLine = true;
    options.seperatorLineHasInsets = false;
    options.textColor = txtColor;
    options.menuBackgroundColor = backColor;

    CGRect fromRect = [btn convertRect:btn.bounds toView:self.view];
    
    [KxMenu showMenuInView:self.view fromRect:fromRect menuItems:menuItems withOptions:options];

}

- (void)onReportPostAbuse:(id)sender {
    
    [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_ABUSE;
    [[GlobalData sharedGlobalData] updateUserDataDB];
    [HDUtility karmaInBackground:KARMA_ABUSE];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![[GlobalData sharedGlobalData].g_postData.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
            
            SVPROGRESSHUD_SHOW;
            
            [[GlobalData sharedGlobalData].g_postData.reportTypeArray addObject:[GlobalData sharedGlobalData].g_userInfo.userID];
            
            [GlobalData sharedGlobalData].g_postData.reportCount = [GlobalData sharedGlobalData].g_postData.reportCount + 1;
            
            [GlobalData sharedGlobalData].g_postData.reportType = @"";
            
            if ([GlobalData sharedGlobalData].g_postData.reportTypeArray.count > 1) {
                
                [GlobalData sharedGlobalData].g_postData.reportType = [GlobalData sharedGlobalData].g_postData.reportTypeArray[0];
                
                for (int i = 1; i < [GlobalData sharedGlobalData].g_postData.reportTypeArray.count; i++) {
                    [GlobalData sharedGlobalData].g_postData.reportType = [NSString stringWithFormat:@"%@;%@", [GlobalData sharedGlobalData].g_postData.reportType, [GlobalData sharedGlobalData].g_postData.reportTypeArray[i]];
                }
            } else if ([GlobalData sharedGlobalData].g_postData.reportTypeArray.count == 1) {
                
                [GlobalData sharedGlobalData].g_postData.reportType = [GlobalData sharedGlobalData].g_postData.reportTypeArray[0];
                
            }
            
            BackendlessDataQuery *query = [BackendlessDataQuery query];
            query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, [GlobalData sharedGlobalData].g_postData.objectId];
            [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
                
                if (posts.data.count > 0) {
                    
                    Post *updatedData = posts.data[0];
                    
                    [updatedData setReportCount:[GlobalData sharedGlobalData].g_postData.reportCount];
                    [updatedData setReportType:[GlobalData sharedGlobalData].g_postData.reportType];
                    
                    [[backendless.persistenceService of:[Post class]] save:updatedData response:^(id response) {
                        
                        NSLog(@"******************* Post Report Count is succeed!********************");
                        
                        SVPROGRESSHUD_DISMISS;
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } error:^(Fault *fault) {
                        
                        NSLog(@"******************* Post Report Count is failed!********************");
                        SVPROGRESSHUD_DISMISS;
                    }];
                    
                } else {
                    SVPROGRESSHUD_DISMISS;
                    NSLog(@"******************* Post Report Count is not found!********************");
                }
                
            } error:^(Fault *fault) {
                SVPROGRESSHUD_DISMISS;
                NSLog(@"******************* Post Report Count is time out!********************");
                
            }];
        }
        
    });
    
}

- (void)onLikePost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [HDUtility likePostInBackground:indexPath dataArray:self.commentDataArray];
    
    [m_tableView reloadData];
}

- (void)onDislikePost:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [HDUtility dislikePostInBackground:sender indexPath:indexPath dataArray:self.commentDataArray];
    
    [m_tableView reloadData];
}

- (void)onReportComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    tempIndexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    KxMenuItem *item = [KxMenuItem menuItem:NSLocalizedString(@"abuse", "") image:[UIImage imageNamed:@"report_abuse"] target:self action:@selector(onReportCommentAbuse:)];
    NSArray *menuItems = [[NSArray alloc] initWithObjects:item, nil];
    [KxMenu setTitleFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    
    Color txtColor, backColor;
    txtColor.R = 0.36; txtColor.G = 0.36; txtColor.B = 0.36;
    backColor.R = 1; backColor.G = 1; backColor.B = 1;
    
    OptionalConfiguration options;
    options.arrowSize = 9;
    options.marginXSpacing = 5;
    options.marginYSpacing = 7;
    options.intervalSpacing = 25;
    options.menuCornerRadius = 3;
    options.maskToBackground = true;
    options.shadowOfMenu = false;
    options.hasSeperatorLine = true;
    options.seperatorLineHasInsets = false;
    options.textColor = txtColor;
    options.menuBackgroundColor = backColor;
    
    CGRect fromRect = [btn convertRect:btn.bounds toView:self.view];
    
    [KxMenu showMenuInView:self.view fromRect:fromRect menuItems:menuItems withOptions:options];
}

- (void)onReportCommentAbuse:(id)sender {
    
    ActivityPostData *record = [[ActivityPostData alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    record = self.commentDataArray[tempIndexPath.row];
    
    
    if (![record.reportTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
        
        record.reportCount = record.reportCount + 1;
        
        [record.reportTypeArray addObject:[GlobalData sharedGlobalData].g_userInfo.userID];
        
        record.reportType = @"";
        if (record.reportTypeArray.count > 1) {
            record.reportType = record.reportTypeArray[0];
            for (int i = 1; i < record.reportTypeArray.count; i++) {
                record.reportType = [NSString stringWithFormat:@"%@;%@", record.reportType, record.reportTypeArray[i]];
            }
        } else if (record.reportTypeArray.count == 1) {
            record.reportType = record.reportTypeArray[0];
        }
        
        [self.commentDataArray removeObjectAtIndex:tempIndexPath.row];
        
        [m_tableView reloadData];
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_ABUSE;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaInBackground:KARMA_COMMENT_ABUSE];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BackendlessDataQuery *query = [BackendlessDataQuery query];
            query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.objectId];
            [[backendless.persistenceService of:[ActivityPost class]] find:query response:^(BackendlessCollection *comments) {
                
                if (comments.data.count > 0) {
                    
                    ActivityPost *updatedData = comments.data[0];
                    
                    [updatedData setReportCount:record.reportCount];
                    [updatedData setReportType:record.reportType];
                    
                    [[backendless.persistenceService of:[ActivityPost class]] save:updatedData response:^(id response) {
                        
                        NSLog(@"******************* Comment Report is succeed!********************");
                        
                    } error:^(Fault *fault) {
                        
                        NSLog(@"******************* Comment Report is failed!********************");
                        
                    }];
                    
                } else {
                    
                    NSLog(@"******************* Comment Report is not found!********************");
                }
                
            } error:^(Fault *fault) {
                
                NSLog(@"******************* Comment Report is time out!********************");
                
            }];
            
        });
    }
    
}

- (void)onLikeComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [HDUtility likeCommentInBackground:indexPath dataArray:self.commentDataArray];
    
    [m_tableView reloadData];
    
}

- (void)onDislikeComment:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    [HDUtility dislikeCommentInBackground:sender indexPath:indexPath dataArray:self.commentDataArray];
    
    [m_tableView reloadData];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onCommentPost:(id)sender {
    
    [GlobalData sharedGlobalData].g_userInfo.latitude = _locationManager.location.coordinate.latitude;
    [GlobalData sharedGlobalData].g_userInfo.longitude = _locationManager.location.coordinate.longitude;
    
    NSLog(@"latitude -> %f,  longitude -> %f", [GlobalData sharedGlobalData].g_userInfo.latitude, [GlobalData sharedGlobalData].g_userInfo.longitude);
    
    NSString *strComment = textView.text;
    
    if ([strComment isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_enter_comment", "")];
        return;
    }
    
    NSData *data = [strComment dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *commentValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    ActivityPost *commentData = [ActivityPost new];
    commentData.postId = [GlobalData sharedGlobalData].g_postData.objectId;
    commentData.comment = commentValue;
    commentData.fromUser = [GlobalData sharedGlobalData].g_userInfo.userID;
    commentData.toUser = [GlobalData sharedGlobalData].g_postData.userID;
    commentData.latitude = [NSString stringWithFormat: @"%f", [GlobalData sharedGlobalData].g_userInfo.latitude];
    commentData.longitude = [NSString stringWithFormat: @"%f", [GlobalData sharedGlobalData].g_userInfo.longitude];
    commentData.time = [[GlobalData sharedGlobalData] getCurrentDate];
    commentData.likeCount = 0;
    commentData.likeType = @"";
    commentData.reportCount = 0;
    commentData.reportType = @"";
    
    if ([[GlobalData sharedGlobalData].g_postData.type isEqualToString:POST_TYPE_PHOTO]) {
        commentData.backColor = COMMENT_COLOR_10;
    } else {
        commentData.backColor = [HDUtility setCommentBackColor:[GlobalData sharedGlobalData].g_postData.backColor];
    }
    
    SVPROGRESSHUD_SHOW;
    
    [backendless.persistenceService save:commentData response:^(id response) {
        
        NSLog(@"saved new comment data");
        
        ActivityPost *comment = response;
        
        SVPROGRESSHUD_DISMISS;
        
        textView.text = @"";
        [textView resignFirstResponder];
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_COMMENT;
        [GlobalData sharedGlobalData].g_userInfo.commentCount ++;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [HDUtility karmaInBackground:KARMA_COMMENT];
        
        ActivityPostData *record = [[ActivityPostData alloc] init];
        record.objectId = comment.objectId;
        record.postId = comment.postId;
        record.backColor = comment.backColor;
        record.comment = comment.comment;
        record.fromUser = comment.fromUser;
        record.toUser = comment.toUser;
        record.latitude = comment.latitude;
        record.longitude = comment.longitude;
        record.time = comment.time;
        record.likeCount = comment.likeCount;
        record.likeType = comment.likeType;
        record.reportCount = comment.reportCount;
        record.reportType = comment.reportType;
        
        record.likeTypeArray = [[NSMutableArray alloc] init];
        record.reportTypeArray = [[NSMutableArray alloc] init];
        
        if (record.likeType != nil && ![record.likeType isEqualToString:@""]) {
            
            if ([record.likeType containsString:@";"]) {
                NSArray *itemsLike = [comment.likeType componentsSeparatedByString:@";"];
                record.likeTypeArray = [itemsLike mutableCopy];
            } else {
                [record.likeTypeArray addObject:record.likeType];
            }
        }
        
        if (record.reportType != nil && ![record.reportType isEqualToString:@""]) {
            
            if ([record.reportType containsString:@";"]) {
                NSArray *itemsLike = [comment.reportType componentsSeparatedByString:@";"];
                record.reportTypeArray = [itemsLike mutableCopy];
            } else {
                [record.reportTypeArray addObject:record.reportType];
            }
        }
        
        
        [self.commentDataArray insertObject:record atIndex:1];
        [self.m_tableView reloadData];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
//            
//            [deviceIDArray addObject:record.toUser];
//            
//            PublishOptions *options = [PublishOptions new];
//            options.headers = @{@"ios-alert":@"Your Karma has been increased",
//                                @"ios-badge":PUSH_BADGE,
//                                @"ios-sound":PUSH_SOUND};
//
//            DeliveryOptions *deliveryOptions = [DeliveryOptions new];
//            deliveryOptions.pushSinglecast = deviceIDArray;
//            
//            [backendless.messagingService publish:MESSAGING_CHANNEL message:@"You received karma from someone commenting for your post" publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
//                NSLog(@"showMessageStatus: %@", res);
//            } error:^(Fault *fault) {
//                NSLog(@"sendMessage: fault = %@", fault);
//            }];
//            
//        });
        
    } error:^(Fault *fault) {
        
        NSLog(@"Failed save in background of comment data, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_new_comment_failed", "")];
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [GlobalData sharedGlobalData].g_postData.commentCount = [GlobalData sharedGlobalData].g_postData.commentCount + 1;
        
        [[GlobalData sharedGlobalData].g_postData.commentTypeArray addObject:[GlobalData sharedGlobalData].g_userInfo.userID];
        
        [GlobalData sharedGlobalData].g_postData.commentType = @"";
        
        if ([GlobalData sharedGlobalData].g_postData.commentTypeArray.count > 1) {
            
            [GlobalData sharedGlobalData].g_postData.commentType = [GlobalData sharedGlobalData].g_postData.commentTypeArray[0];
            
            for (int i = 1; i < [GlobalData sharedGlobalData].g_postData.commentTypeArray.count; i++) {
                [GlobalData sharedGlobalData].g_postData.commentType = [NSString stringWithFormat:@"%@;%@", [GlobalData sharedGlobalData].g_postData.commentType, [GlobalData sharedGlobalData].g_postData.commentTypeArray[i]];
            }
        } else if ([GlobalData sharedGlobalData].g_postData.commentTypeArray.count == 1) {
            [GlobalData sharedGlobalData].g_postData.commentType = [GlobalData sharedGlobalData].g_postData.commentTypeArray[0];
        }
        
        BackendlessDataQuery *query = [BackendlessDataQuery query];
        query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, [GlobalData sharedGlobalData].g_postData.objectId];
        [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
            
            if (posts.data.count > 0) {
                
                Post *updatedData = posts.data[0];
                
                [updatedData setCommentCount:[GlobalData sharedGlobalData].g_postData.commentCount];
                [updatedData setCommentType:[GlobalData sharedGlobalData].g_postData.commentType];
                
                [[backendless.persistenceService of:[Post class]] save:updatedData response:^(id response) {
                    
                    NSLog(@"******************* Post Comment Count is succeed!********************");
                    
                } error:^(Fault *fault) {
                    
                    NSLog(@"******************* Post Comment Count is failed!********************");
                    
                }];
                
            } else {
                
                NSLog(@"******************* Post Comment Count is not found!********************");
            }
            
        } error:^(Fault *fault) {
            
            NSLog(@"******************* Post Comment Count is time out!********************");
            
        }];
        
    });
}

@end
