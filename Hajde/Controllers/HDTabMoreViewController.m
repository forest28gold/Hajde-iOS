//
//  HDProfileMoreViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDTabMoreViewController.h"
#import "HDInviteFriendsViewController.h"
#import <MessageUI/MessageUI.h>

@interface HDTabMoreViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation HDTabMoreViewController

@synthesize m_btnLanguage, m_viewLanguage;
//@synthesize facebookLikeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_viewLanguage.hidden = YES;
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANG_ALB]) {
        [m_btnLanguage setTitle:NSLocalizedString(@"albanian", "") forState:UIControlStateNormal];
    } else {
        [m_btnLanguage setTitle:NSLocalizedString(@"english", "") forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHiddenLanguage)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
//    facebookLikeButton.objectID = HAJDE_FACEBOOK_LINK;
//    [facebookLikeButton setTitle:@"" forState:UIControlStateNormal];
//    [facebookLikeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [facebookLikeButton setBackgroundImage:[UIImage imageNamed:@"follow_facebook"] forState:UIControlStateNormal];
//    [facebookLikeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
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

- (void)onHiddenLanguage {
    
    m_viewLanguage.hidden = YES;
}

- (IBAction)onSetLanguage:(id)sender {
    
    m_viewLanguage.hidden = NO;
}

- (IBAction)onSetEnglish:(id)sender {
    
    m_viewLanguage.hidden = YES;
    [m_btnLanguage setTitle:NSLocalizedString(@"english", "") forState:UIControlStateNormal];
    
    [NSBundle setLanguage:@"en"];
    
    [GlobalData sharedGlobalData].g_userInfo.language = LANG_ENG;
    [[GlobalData sharedGlobalData] updateUserDataDB];
    
    [GlobalData sharedGlobalData].g_toggleLanguageIsOn = true;
    [[GlobalData sharedGlobalData].g_tabBar viewWillAppear:NO];
}

- (IBAction)onSetAlbanian:(id)sender {
    
    m_viewLanguage.hidden = YES;
    [m_btnLanguage setTitle:NSLocalizedString(@"albanian", "") forState:UIControlStateNormal];
    
    [NSBundle setLanguage:@"sq"];
    
    [GlobalData sharedGlobalData].g_userInfo.language = LANG_ALB;
    [[GlobalData sharedGlobalData] updateUserDataDB];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"sq", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [GlobalData sharedGlobalData].g_toggleLanguageIsOn = true;
    [[GlobalData sharedGlobalData].g_tabBar viewWillAppear:NO];
}

- (IBAction)onLoveHajde:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:HAJDE_APP_LINK]];
}

- (IBAction)onWhatKarma:(id)sender {
    
    [[GlobalData sharedGlobalData].g_tabBar goToWhatsKarma];
}

- (IBAction)onInviteFriends:(id)sender {
    
    [[GlobalData sharedGlobalData].g_tabBar goToInviteFriends];
}

- (IBAction)onFeedback:(id)sender {
    
//    if ([MFMailComposeViewController canSendMail]) {
//        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
//        [mailController setToRecipients:@[SUPPORT_EMAIL]];
//        mailController.mailComposeDelegate = self;
//        [self presentViewController:mailController animated:YES completion:nil];
//    }
    
    [[GlobalData sharedGlobalData].g_tabBar goToFeedback];
}

- (IBAction)onTermsOfUse:(id)sender {
    
    [[GlobalData sharedGlobalData].g_tabBar goToTermsUse];
}

- (IBAction)onFollowTwitter:(id)sender {
    
//    [HDUtility shareToSicial:1 viewCtrl:self image:[UIImage imageNamed:@"icon-512"]];
    
    NSArray *urls = [NSArray arrayWithObjects:
                     @"twitter://user?screen_name={handle}", // Twitter
                     @"tweetbot:///user_profile/{handle}", // TweetBot
                     @"echofon:///user_timeline?{handle}", // Echofon
                     @"twit:///user?screen_name={handle}", // Twittelator Pro
                     @"x-seesmic://twitter_profile?twitter_screen_name={handle}", // Seesmic
                     @"x-birdfeed://user?screen_name={handle}", // Birdfeed
                     @"tweetings:///user?screen_name={handle}", // Tweetings
                     @"simplytweet:?link=http://twitter.com/{handle}", // SimplyTweet
                     @"icebird://user?screen_name={handle}", // IceBird
                     @"fluttr://user/{handle}", // Fluttr
                     @"http://twitter.com/{handle}",
                     nil];
    
    UIApplication *application = [UIApplication sharedApplication];
    
    for (NSString *candidate in urls) {
        NSURL *url = [NSURL URLWithString:[candidate stringByReplacingOccurrencesOfString:@"{handle}" withString:@"Hajdeapp"]];
        if ([application canOpenURL:url]) {
            [application openURL:url];
            // Stop trying after the first URL that succeeds
            return;
        }
    }
}

- (IBAction)onLikeFacebook:(id)sender {
    
//    [HDUtility shareToSicial:0 viewCtrl:self image:[UIImage imageNamed:@"icon-512"]];
    
    NSURL *googleUrl = [NSURL URLWithString:[NSString  stringWithFormat:HAJDE_FACEBOOK_LINK]];
    
    if ([[UIApplication sharedApplication] canOpenURL:googleUrl]) {
        [[UIApplication sharedApplication] openURL:googleUrl];
    }
}

- (IBAction)onFollowGoogle:(id)sender {
    
    NSURL *googleUrl = [NSURL URLWithString:[NSString  stringWithFormat:HAJDE_GOOGLE_LINK]];
    
    if ([[UIApplication sharedApplication] canOpenURL:googleUrl]) {
        [[UIApplication sharedApplication] openURL:googleUrl];
    }
}


@end
