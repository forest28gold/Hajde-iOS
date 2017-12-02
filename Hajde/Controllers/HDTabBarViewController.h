//
//  HDTabBarViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDTabHomeViewController.h"
#import "HDTabProfileViewController.h"
#import "HDTabShopViewController.h"
#import "HDTabMoreViewController.h"

@protocol tabbarDelegate <NSObject>

-(void)ShowMenu;
-(void)touchBtnAtIndex:(NSInteger)index;

@end

@class tabbarView;

@interface HDTabBarViewController : UIViewController <tabbarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController             *m_popoverController;
    UIImagePickerController         *m_pickerController;
}

@property(nonatomic,strong) HDTabHomeViewController *m_homeVC;
@property(nonatomic,strong) HDTabProfileViewController *m_profileVC;
@property(nonatomic,strong) HDTabShopViewController *m_shopVC;
@property(nonatomic,strong) HDTabMoreViewController *m_moreVC;

@property(nonatomic,strong) tabbarView *tabbar;
@property(nonatomic,strong) NSArray *arrayViewcontrollers;

@property (strong, nonatomic) IBOutlet UIView *m_viewTab;
@property (strong, nonatomic) IBOutlet UIView *m_viewMenu;

@property (strong, nonatomic) IBOutlet UIImageView *m_imgOverlay;
@property (strong, nonatomic) IBOutlet UIButton *m_btnClose;
@property (strong, nonatomic) IBOutlet UIButton *m_btnNewImage;
@property (strong, nonatomic) IBOutlet UIButton *m_btnNewPost;
@property (strong, nonatomic) IBOutlet UIButton *m_btnNewVoice;

- (void)goToPostDetails;
- (void)goToFeedback;
- (void)goToWhatsKarma;
- (void)goToTermsUse;
- (void)goToOffers;
- (void)goToInviteFriends;
- (void)goToOfferDetails;
- (void)goToPhotoDetails;

- (IBAction)unwindPostPhoto:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindPostVoice:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindGoToOffer:(UIStoryboardSegue *)unwindSegue;

@end
