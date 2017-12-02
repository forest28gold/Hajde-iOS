//
//  HDPrivacyPolicyViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/28/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDPrivacyPolicyViewController.h"
#import "HDPrivacyTableViewCell.h"
#import "PrivacyPolicy.h"

static NSString *HDPrivacyTableViewCellIdentifier = @"HDPrivacyTableViewCellIdentifier";

@interface HDPrivacyPolicyViewController ()

@end

@implementation HDPrivacyPolicyViewController

@synthesize m_tableView;
@synthesize m_viewEmpty;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [m_tableView registerClass:[HDPrivacyTableViewCell class] forCellReuseIdentifier:HDPrivacyTableViewCellIdentifier];
    
    if ([GlobalData sharedGlobalData].g_toggleTermsIsOn) {
        [self initLoadTermsOfUseData];
    } else {
        [self initLoadPrivacyPolicyData];
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

- (void)initLoadTermsOfUseData {
    
    SVPROGRESSHUD_SHOW;
    
    [GlobalData sharedGlobalData].g_arrayPrivacyPolicy = [[NSMutableArray alloc] init];
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"index ASC"];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[TermsOfUse class]] find:query response:^(BackendlessCollection *termsofuses) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (termsofuses.data.count > 0) {
            
            for (TermsOfUse *term in termsofuses.data) {
                
                [[GlobalData sharedGlobalData].g_arrayPrivacyPolicy addObject:term];
            }
            
            [m_tableView reloadData];
            [self onSetEmptyView];
            
        } else {
         
            [self onSetEmptyView];
        }
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        [self onSetEmptyView];
    }];
}

- (void)initLoadPrivacyPolicyData {
    
    SVPROGRESSHUD_SHOW;
    
    [GlobalData sharedGlobalData].g_arrayPrivacyPolicy = [[NSMutableArray alloc] init];
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"index ASC"];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[PrivacyPolicy class]] find:query response:^(BackendlessCollection *privacyData) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (privacyData.data.count > 0) {
            
            for (PrivacyPolicy *privacy in privacyData.data) {
                
                TermsOfUse *term = [[TermsOfUse alloc] init];
                
                term.title = privacy.title;
                term.content = privacy.content;
                [[GlobalData sharedGlobalData].g_arrayPrivacyPolicy addObject:term];
            }
            
            [m_tableView reloadData];
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
    
    if ([GlobalData sharedGlobalData].g_arrayPrivacyPolicy.count > 0) {
        m_viewEmpty.hidden = YES;
    } else {
        m_viewEmpty.hidden = NO;
    }
}

- (IBAction)onRefresh:(id)sender {
    
    if ([GlobalData sharedGlobalData].g_toggleTermsIsOn) {
        [self initLoadTermsOfUseData];
    } else {
        [self initLoadPrivacyPolicyData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GlobalData sharedGlobalData].g_arrayPrivacyPolicy.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDPrivacyTableViewCell *cell = (HDPrivacyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HDPrivacyTableViewCellIdentifier forIndexPath:indexPath];
    
    // Load data
    TermsOfUse *termsData = [GlobalData sharedGlobalData].g_arrayPrivacyPolicy[indexPath.row];
    [cell setupCellWithData:termsData];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    // Create our size
    CGSize cellSize = [HDPrivacyTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
        
        TermsOfUse *termsData = [GlobalData sharedGlobalData].g_arrayPrivacyPolicy[indexPath.row];
        [((HDPrivacyTableViewCell *)cellToSetup) setupCellWithData:termsData];
        
        // return cell
        return cellToSetup;
    }];
    
    return cellSize.height;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
