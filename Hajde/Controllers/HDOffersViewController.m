//
//  HDOffersViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/28/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDOffersViewController.h"

@interface HDOffersViewController () <UITableViewDragLoadDelegate, UIGestureRecognizerDelegate>
{
    int _dataCount;
}

@property (nonatomic, strong) NSMutableArray *offerDataArray;

@end

@implementation HDOffersViewController

@synthesize m_lblTitle;
@synthesize m_viewEmpty;
@synthesize m_tableView;
@synthesize m_imgMark, m_txtDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataCount = 0;
    
    m_lblTitle.text = [GlobalData sharedGlobalData].g_shopData.shopTitle;
    NSURL *imageURL = [NSURL URLWithString:[GlobalData sharedGlobalData].g_shopData.markFilePath];
    [self.m_imgMark setShowActivityIndicatorView:YES];
    [self.m_imgMark setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.m_imgMark sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"shop_empty"]];
    m_txtDescription.text = [GlobalData sharedGlobalData].g_shopData.shopDescription;
    [m_txtDescription setTextColor:[UIColor darkGrayColor]];
    
    [m_tableView setDragDelegate:self refreshDatePermanentKey:@"RefreshList"];
    m_tableView.showLoadMoreView = true;

    SVPROGRESSHUD_SHOW;
    [self initLoadOfferData];
    
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

- (void)initLoadOfferData {
    
    self.offerDataArray = [[NSMutableArray alloc] init];
    _dataCount += LOAD_DATA_COUNT;
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_SHOP_ID, [GlobalData sharedGlobalData].g_shopData.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Offer class]] find:query response:^(BackendlessCollection *offers) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (offers.data.count > 0) {
            
            for (Offer *offer in offers.data) {
                
                [self.offerDataArray addObject:offer];
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
    
    if (self.offerDataArray.count > 0) {
        m_viewEmpty.hidden = YES;
        [m_tableView reloadData];
    } else {
        m_viewEmpty.hidden = NO;
    }
}

- (IBAction)onRefresh:(id)sender {
    
    SVPROGRESSHUD_SHOW;
    [self initLoadOfferData];
}

#pragma mark - Control datasource

- (void)finishRefresh
{
//    _dataCount = 0;
    
    if (_dataCount == 0) {
        _dataCount = LOAD_DATA_COUNT;
    }
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.pageSize = [NSNumber numberWithInt:_dataCount];
    queryOption.offset = [NSNumber numberWithInt:0];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_SHOP_ID, [GlobalData sharedGlobalData].g_shopData.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Offer class]] find:query response:^(BackendlessCollection *offers) {
        
        if (offers.data.count > 0) {
            
            self.offerDataArray = [[NSMutableArray alloc] init];
            
            for (Offer *offer in offers.data) {
                
                [self.offerDataArray addObject:offer];
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
    queryOption.pageSize = [NSNumber numberWithInt:LOAD_DATA_COUNT];
    queryOption.offset = [NSNumber numberWithInt:_dataCount];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_SHOP_ID, [GlobalData sharedGlobalData].g_shopData.objectId];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Offer class]] find:query response:^(BackendlessCollection *offers) {
        
        if (offers.data.count > 0) {
            
            for (Offer *offer in offers.data) {
                
                [self.offerDataArray addObject:offer];
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
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.offerDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* _cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    
    Offer *record = self.offerDataArray[indexPath.row];
    
    UIImageView *m_imgProduct = (UIImageView *)[_cell viewWithTag:1];
//    UIImageView *m_imgMark = (UIImageView *)[_cell viewWithTag:2];
    UILabel *m_lblName = (UILabel *)[_cell viewWithTag:3];
    UILabel *m_lblIndex = (UILabel *)[_cell viewWithTag:4];
    UILabel *m_lblOffPercent = (UILabel *)[_cell viewWithTag:5];
    UILabel *m_lblPrice = (UILabel *)[_cell viewWithTag:6];
    UILabel *m_lblBeforePrice = (UILabel *)[_cell viewWithTag:7];
    
    NSURL *imageURL = [NSURL URLWithString:record.markFilePath];
    [m_imgProduct setShowActivityIndicatorView:YES];
    [m_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [m_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"offer_image"]];
    
//    NSURL *imageMarkURL = [NSURL URLWithString:record.markFilePath];
//    [m_imgMark sd_setImageWithURL:imageMarkURL placeholderImage:[UIImage imageNamed:@"offer_logo"]];
    
    m_lblName.text = record.name;
    m_lblIndex.text = record.index;
    NSString *percent = @"%";
    m_lblOffPercent.text = [NSString stringWithFormat:@"%@%@ %@", record.offPercent, percent, NSLocalizedString(@"off", "")];
    
    if ([record.price containsString:@"."]) {
        m_lblPrice.text = [NSString stringWithFormat:@"%@%@", [GlobalData sharedGlobalData].g_strCurrency, record.price];
    } else {
        m_lblPrice.text = [NSString stringWithFormat:@"%@%@.-", [GlobalData sharedGlobalData].g_strCurrency, record.price];
    }
    
    if ([record.beforePrice containsString:@"."]) {
        m_lblBeforePrice.text = [NSString stringWithFormat:@"%@ %@%@", NSLocalizedString(@"before", ""), [GlobalData sharedGlobalData].g_strCurrency, record.beforePrice];
    } else {
        m_lblBeforePrice.text = [NSString stringWithFormat:@"%@ %@%@.-", NSLocalizedString(@"before", ""), [GlobalData sharedGlobalData].g_strCurrency, record.beforePrice];
    }
    
    m_imgProduct.userInteractionEnabled = true;
    
    UILongPressGestureRecognizer *lPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imgLongPressed:)];
    lPressed.delegate = self;
    lPressed.minimumPressDuration = 0.4;
    [m_imgProduct addGestureRecognizer:lPressed];
    
    return _cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [GlobalData sharedGlobalData].g_offerData = [[Offer alloc] init];
    [GlobalData sharedGlobalData].g_offerData = self.offerDataArray[indexPath.row];
    
    [[GlobalData sharedGlobalData].g_tabBar goToOfferDetails];
}

- (void)imgLongPressed:(UILongPressGestureRecognizer*)sender {
    
    UIImageView *imgView = (UIImageView*)sender.view;
    CGRect buttonFrameInTableView = [imgView convertRect:imgView.bounds toView:self.m_tableView];
    NSIndexPath *indexPath = [self.m_tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    Offer *record = self.offerDataArray[indexPath.row];
    
    [GlobalData sharedGlobalData].g_strPhotoUrl = record.markFilePath;
    
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
