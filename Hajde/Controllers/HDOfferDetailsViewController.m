//
//  HDOfferDetailsViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/28/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDOfferDetailsViewController.h"

@interface HDOfferDetailsViewController () <UIGestureRecognizerDelegate>

@end

@implementation HDOfferDetailsViewController

@synthesize m_btnBack, m_lblTitle;
@synthesize m_imgMark, m_imgProduct, m_lblName, m_lblIndex, m_lblOffPercent, m_lblPrice;
@synthesize m_lblBeforePrice, m_lblOfferName, m_lblOfferSpec, m_txtSpecDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *imageURL = [NSURL URLWithString:[GlobalData sharedGlobalData].g_offerData.markFilePath];
    [m_imgProduct setShowActivityIndicatorView:YES];
    [m_imgProduct setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [m_imgProduct sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"offer_image"]];

//    NSURL *imageMarkURL = [NSURL URLWithString:[GlobalData sharedGlobalData].g_offerData.markFilePath];
//    [self.m_imgMark sd_setImageWithURL:imageMarkURL placeholderImage:[UIImage imageNamed:@"offer_logo"]];
    
    m_imgProduct.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_photo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPhoto:)];
    [m_imgProduct addGestureRecognizer:tap_photo];
    
    m_lblTitle.text = [GlobalData sharedGlobalData].g_offerData.name;
    
    m_lblName.text = [GlobalData sharedGlobalData].g_offerData.name;
    m_lblIndex.text = [GlobalData sharedGlobalData].g_offerData.index;
    NSString *percent = @"%";
    m_lblOffPercent.text = [NSString stringWithFormat:@"%@%@ %@", [GlobalData sharedGlobalData].g_offerData.offPercent, percent, NSLocalizedString(@"off", "")];
    
    if ([[GlobalData sharedGlobalData].g_offerData.price containsString:@"."]) {
        m_lblPrice.text = [NSString stringWithFormat:@"%@%@", [GlobalData sharedGlobalData].g_strCurrency, [GlobalData sharedGlobalData].g_offerData.price];
    } else {
        m_lblPrice.text = [NSString stringWithFormat:@"%@%@.-", [GlobalData sharedGlobalData].g_strCurrency, [GlobalData sharedGlobalData].g_offerData.price];
    }
    
    if ([[GlobalData sharedGlobalData].g_offerData.beforePrice containsString:@"."]) {
        m_lblBeforePrice.text = [NSString stringWithFormat:@"%@ %@%@", NSLocalizedString(@"before", ""), [GlobalData sharedGlobalData].g_strCurrency, [GlobalData sharedGlobalData].g_offerData.beforePrice];
    } else {
        m_lblBeforePrice.text = [NSString stringWithFormat:@"%@ %@%@.-", NSLocalizedString(@"before", ""), [GlobalData sharedGlobalData].g_strCurrency, [GlobalData sharedGlobalData].g_offerData.beforePrice];
    }
    
    m_lblOfferName.text = [GlobalData sharedGlobalData].g_offerData.name;
    m_lblOfferSpec.text = [GlobalData sharedGlobalData].g_offerData.specTitle;
    m_txtSpecDescription.text = [GlobalData sharedGlobalData].g_offerData.specDescription;
    [m_txtSpecDescription setTextColor:[UIColor darkGrayColor]];
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

- (void)onTapPhoto:(UITapGestureRecognizer*)sender {
    
    [GlobalData sharedGlobalData].g_strPhotoUrl = [GlobalData sharedGlobalData].g_offerData.markFilePath;
    
    [[GlobalData sharedGlobalData].g_tabBar goToPhotoDetails];
    
//    UIImageView *imgView = (UIImageView*)sender.view;    
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onGotoOffer:(id)sender {
    
    [self performSegueWithIdentifier:UNWIND_GOTO_OFFER sender:nil];
}

@end
