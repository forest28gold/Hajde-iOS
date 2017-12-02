//
//  HDCartOffersViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDTabShopViewController.h"

@interface HDTabShopViewController ()

@property (nonatomic, strong) NSMutableArray *shopDataArray;

@end

@implementation HDTabShopViewController

@synthesize m_collectionView;
@synthesize m_viewEmpty;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GlobalData sharedGlobalData].g_strCurrency = [self getOfferCurrency:[GlobalData sharedGlobalData].g_userInfo.country];
    
    [self initLoadShopData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [m_collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *)getOfferCurrency:(NSString*)country {
    
    NSString *strCurreny = CURRENCY_OTHERS;
    
    if ([country isEqualToString:COUNTRY_ALBANIA]) {
        strCurreny = CURRENCY_ALBANIA;
    } else if ([country isEqualToString:COUNTRY_BOSNIA_HEREZE]) {
        strCurreny = CURRENCY_BOSNIA_HEREZE;
    } else if ([country isEqualToString:COUNTRY_KOSOVO]) {
        strCurreny = CURRENCY_KOSOVO;
    } else if ([country isEqualToString:COUNTRY_MACEDONIA]) {
        strCurreny = CURRENCY_MACEDONIA;
    } else if ([country isEqualToString:COUNTRY_MONTENEGRO]) {
        strCurreny = CURRENCY_MONTENEGRO;
    } else if ([country isEqualToString:COUNTRY_SERBIA]) {
        strCurreny = CURRENCY_SERBIA;
    } else if ([country isEqualToString:COUNTRY_SWISS]) {
        strCurreny = CURRENCY_SWISS;
    } else if ([country isEqualToString:COUNTRY_TURKEY]) {
        strCurreny = CURRENCY_TURKEY;
    } else {
        strCurreny = CURRENCY_OTHERS;
    }
    
    return strCurreny;
}

- (void)initLoadShopData {
    
    SVPROGRESSHUD_SHOW;
    
    self.shopDataArray = [[NSMutableArray alloc] init];
    
    QueryOptions *queryOption = [QueryOptions new];
    queryOption.sortBy = @[@"created ASC"];
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"country = \'%@\'", [GlobalData sharedGlobalData].g_userInfo.country];
    query.queryOptions = queryOption;
    [[backendless.persistenceService of:[Shop class]] find:query response:^(BackendlessCollection *shops) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (shops.data.count > 0) {
            
            for (Shop *shop in shops.data) {
                
                [self.shopDataArray addObject:shop];
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
    
    if (self.shopDataArray.count > 0) {
        m_viewEmpty.hidden = YES;
        [m_collectionView reloadData];
    } else {
        m_viewEmpty.hidden = NO;
    }
}

- (IBAction)onRefresh:(id)sender {

    [self initLoadShopData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shopDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OfferCell" forIndexPath:indexPath];
    
    Shop *record = self.shopDataArray[indexPath.row];

    UIButton* _btnOffer = (UIButton*)[_cell viewWithTag:1];
    [_btnOffer addTarget:self action:@selector(onOffers:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView* _imgShop = (UIImageView*)[_cell viewWithTag:2];
    NSURL *imageURL = [NSURL URLWithString:record.markFilePath];
    [_imgShop setShowActivityIndicatorView:YES];
    [_imgShop setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_imgShop sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"shop_empty"]];
    
    return _cell;
}

-(void)onOffers:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.m_collectionView];
    NSIndexPath *indexPath = [self.m_collectionView indexPathForItemAtPoint:buttonFrameInTableView.origin];
    
    [GlobalData sharedGlobalData].g_shopData = [[Shop alloc] init];
    [GlobalData sharedGlobalData].g_shopData = self.shopDataArray[indexPath.row];
    
    [[GlobalData sharedGlobalData].g_tabBar goToOffers];
}


@end
