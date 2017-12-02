//
//  HDWhatKarmaViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDWhatKarmaViewController.h"
#import "HDPrivacyTableViewCell.h"

static NSString *HDPrivacyTableViewCellIdentifier = @"HDPrivacyTableViewCellIdentifier";

@interface HDWhatKarmaViewController () <UITableViewDragLoadDelegate>


@end

@implementation HDWhatKarmaViewController

@synthesize m_tableView;
@synthesize m_viewEmpty;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [m_tableView registerClass:[HDPrivacyTableViewCell class] forCellReuseIdentifier:HDPrivacyTableViewCellIdentifier];
    
    if (!([GlobalData sharedGlobalData].g_arrayWhatsKarma.count > 0)) {
        [self initLoadWhatsKarmaData];
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

- (void)initLoadWhatsKarmaData {
    
    SVPROGRESSHUD_SHOW;
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"index ASC"];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[WhatsKarma class]] find:query response:^(BackendlessCollection *whatsKarmaData) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (whatsKarmaData.data.count > 0) {
            
            for (WhatsKarma *karma in whatsKarmaData.data) {
                
                [[GlobalData sharedGlobalData].g_arrayWhatsKarma addObject:karma];
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
    
    if ([GlobalData sharedGlobalData].g_arrayWhatsKarma.count > 0) {
        m_viewEmpty.hidden = YES;
    } else {
        m_viewEmpty.hidden = NO;
    }
}

- (IBAction)onRefresh:(id)sender {
    
    [self initLoadWhatsKarmaData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GlobalData sharedGlobalData].g_arrayWhatsKarma.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDPrivacyTableViewCell *cell = (HDPrivacyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:HDPrivacyTableViewCellIdentifier forIndexPath:indexPath];
    
    // Load data
    WhatsKarma *karma = [GlobalData sharedGlobalData].g_arrayWhatsKarma[indexPath.row];
    
    TermsOfUse *terms = [[TermsOfUse alloc] init];
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANG_ALB]) {
        
        terms.title = karma.titleAlb;
        terms.content = karma.contentAlb;
    } else {
        terms.title = karma.title;
        terms.content = karma.content;
    }
    
    [cell setupCellWithData:terms];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    // Create our size
    CGSize cellSize = [HDPrivacyTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
        
        WhatsKarma *karma = [GlobalData sharedGlobalData].g_arrayWhatsKarma[indexPath.row];
        
        TermsOfUse *terms = [[TermsOfUse alloc] init];
        
        if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANG_ALB]) {
            
            terms.title = karma.titleAlb;
            terms.content = karma.contentAlb;
        } else {
            terms.title = karma.title;
            terms.content = karma.content;
        }
        
        [((HDPrivacyTableViewCell *)cellToSetup) setupCellWithData:terms];
        
        // return cell
        return cellToSetup;
    }];
    
    return cellSize.height;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onGotoOffers:(id)sender {
    
    [self performSegueWithIdentifier:UNWIND_GOTO_OFFER_KARMA sender:nil];
}

@end
