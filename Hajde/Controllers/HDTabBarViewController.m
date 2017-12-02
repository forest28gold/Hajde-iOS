//
//  HDTabBarViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDTabBarViewController.h"
#import "tabbarView.h"
#import "HDPostDetailsViewController.h"
#import "HDImageEditViewController.h"


#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface HDTabBarViewController () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    
    UINavigationController *m_homeNC;
    UINavigationController *m_profileNC;
    UINavigationController *m_shopNC;
    UINavigationController *m_moreNC;
    Boolean countryIsOn;
}

@end

@implementation HDTabBarViewController

@synthesize m_viewTab, m_viewMenu;
@synthesize m_btnClose, m_btnNewImage, m_btnNewPost, m_btnNewVoice, m_imgOverlay;
@synthesize m_shopVC, m_profileVC, m_moreVC, m_homeVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    countryIsOn = false;
    
    [self setupLocationManager];
    [_locationManager startUpdatingLocation];
    
    CGFloat orginHeight = self.view.frame.size.height- 48;
    
    _tabbar = [[tabbarView alloc]initWithFrame:CGRectMake(0,  orginHeight, 320, 48)];
    _tabbar.delegate = self;
    [self.m_viewTab addSubview:_tabbar];
    
    m_viewMenu.hidden = YES;
    
    _arrayViewcontrollers = [self getViewcontrollers];
    [self touchBtnAtIndex:0];
    
    [GlobalData sharedGlobalData].g_tabBar = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPost)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.m_viewMenu addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([GlobalData sharedGlobalData].g_toggleLanguageIsOn) {
        
        _arrayViewcontrollers = [self getViewcontrollers];
        [self touchBtnAtIndex:3];
        
        if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANG_ALB]) {
            [_tabbar.tabbarView setImage:[UIImage imageNamed:@"tabbar_4_alb"]];
        } else {
            [_tabbar.tabbarView setImage:[UIImage imageNamed:@"tabbar_4"]];
        }
        
        [GlobalData sharedGlobalData].g_toggleLanguageIsOn = false;
    }
    
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
        
//        [self getAddressFromLocation:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
        
        if (!countryIsOn) {
            countryIsOn = true;
            [self getCurrentCountryName];
        }
        
        NSLog(@"latitude -> %f,  longitude -> %f", [GlobalData sharedGlobalData].g_userInfo.latitude, [GlobalData sharedGlobalData].g_userInfo.longitude);
        
    }
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    //    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Application failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //
    //    [errorAlert show];
}

- (void)getCurrentCountryName {
    
    NSError *error = nil;
    NSString* lookUpString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true_or_false",
                              [GlobalData sharedGlobalData].g_userInfo.latitude,
                              [GlobalData sharedGlobalData].g_userInfo.longitude];
    
//    NSString* lookUpString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true_or_false",
//                              47.425682,
//                              8.36207];
    
    lookUpString = [lookUpString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSData* jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:lookUpString]];
    if (jsonResponse) {
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
        NSArray* jsonResults = [jsonDict objectForKey:@"results"];
        
        if (jsonResults && jsonResults.count > 0) {
            NSDictionary* addressInfo = jsonResults[0];
            if (addressInfo) {
                NSArray* addressComponents = addressInfo[@"address_components"];
                if (addressComponents && addressComponents.count > 0) {
                    for (NSDictionary* info in addressComponents) {
                        NSArray* types = info[@"types"];
                        if (types && types.count > 0) {
                            for (NSString* type in types) {
                                if (type && [type.lowercaseString isEqualToString:@"country"]) {
                                    NSString *countryCode = info[@"short_name"];  //@"short_name"  (AL)
                                    [GlobalData sharedGlobalData].g_userInfo.country = [self getCountryName:countryCode];
                                    NSLog(@"===========I am currently at ===> %@ =================", [GlobalData sharedGlobalData].g_userInfo.country);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

- (NSString *)getCountryName:(NSString*)countryCode {
    
    NSString *strCountry = COUNTRY_OTHERS;
    
    if ([countryCode isEqualToString:@"AL"]) {
        strCountry = COUNTRY_ALBANIA;
    } else if ([countryCode isEqualToString:@"BA"]) {
        strCountry = COUNTRY_BOSNIA_HEREZE;
    } else if ([countryCode isEqualToString:@"MK"]) {
        strCountry = COUNTRY_MACEDONIA;
    } else if ([countryCode isEqualToString:@"ME"]) {
        strCountry = COUNTRY_MONTENEGRO;
    } else if ([countryCode isEqualToString:@"RS"]) {
        strCountry = COUNTRY_SERBIA;
    } else if ([countryCode isEqualToString:@"CH"]) {
        strCountry = COUNTRY_SWISS;
    } else if ([countryCode isEqualToString:@"TR"]) {
        strCountry = COUNTRY_TURKEY;
    } else {
        strCountry = COUNTRY_OTHERS;
    }
    
    return strCountry;
}

- (void)getAddressFromLocation:(CGFloat)lat longitude:(CGFloat)lng {
    
//    lat = 41.0569239; // albania
//    lng = 19.9020164;
//
//    lat = 44.5896595; // Bosnia and Herzegovina
//    lng = 17.5182841;
//
//    lat = 42.5918186; // Kosovo =============
//    lng = 20.8399809;
//    
//    lat = 41.59501; // Macedonia (FYROM)
//    lng = 21.6374677;
//    
//    lat = 42.9977434; // Montenegro
//    lng = 18.7607756;
//    
//    lat = 44.2494354; // Serbia
//    lng = 20.7459236;
//    
//    lat = 47.425682; // Switzerland
//    lng = 8.36207;
//
//    lat = 38.8798727; // Turkey
//    lng = 30.752753;
//    
//    lat = 51.7138268;
//    lng = 39.1429834; // Russia
//
//    lat = 34.0674;
//    lng = -118.2423; // Los Angelse
//    
//    lat = 43.649052;
//    lng = -79.4486917;  // Toronto Canada

    CLGeocoder *ceo = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    
    [ceo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            
            NSLog(@"get location is failed.");
            
            NSLog(@"%@", [error description]);
            
            if ([GlobalData sharedGlobalData].g_userInfo.country != NULL && ![[GlobalData sharedGlobalData].g_userInfo.country isEqualToString:@""]) {
                
            } else {
                [GlobalData sharedGlobalData].g_userInfo.country = COUNTRY_OTHERS;
            }
            
        } else {
            
            NSLog(@"get location is succeed.");
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"placemark %@", placemark);
            
//            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@","];
//            NSLog(@"addressDictionary %@", placemark.addressDictionary);
//            
//            NSLog(@"placemark %@", placemark.country); //country
//            NSLog(@"placemark %@", placemark.locality); //city, locality
//            NSLog(@"location %@", placemark.subLocality); //address
//            NSLog(@"location %@", placemark.name); //address
//            NSLog(@"location %@", placemark.administrativeArea);
//            NSLog(@"location %@", placemark.thoroughfare);
//            NSLog(@"location %@", placemark.subThoroughfare);
//            
//            NSLog(@"========= location ISOcountryCode    %@", placemark.ISOcountryCode);
//            
//            NSLog(@"I am currently at %@", locatedAt);
            
//            NSString *country = placemark.country;
            
            NSString *countryCode = [placemark ISOcountryCode];
            //Obtains a locale identifier. This will handle every language
            NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject:countryCode forKey: NSLocaleCountryCode]];
            //Obtains the country name from the locale BUT IN ENGLISH (you can set it as "en_UK" also)
            NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] displayNameForKey: NSLocaleIdentifier value:identifier];
            
            NSLog(@"I am currently at %@", country);
            
            [GlobalData sharedGlobalData].g_userInfo.country = country;
            
        }
        
    }];

}

-(void)touchBtnAtIndex:(NSInteger)index
{
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    NSDictionary* data = [_arrayViewcontrollers objectAtIndex:index];
    
    UIViewController *viewController = data[@"viewController"];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 48);
    
    [self.m_viewTab insertSubview:viewController.view belowSubview:_tabbar];
}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    m_homeVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TAB_HOME];
    m_homeNC = [[UINavigationController alloc] initWithRootViewController:m_homeVC];
    m_homeNC.navigationBarHidden = YES;
    
    m_profileVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TAB_PROFILE];
    m_profileNC = [[UINavigationController alloc] initWithRootViewController:m_profileVC];
    m_profileNC.navigationBarHidden = YES;
    
    m_shopVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TAB_SHOP];
    m_shopNC = [[UINavigationController alloc] initWithRootViewController:m_shopVC];
    m_shopNC.navigationBarHidden = YES;
    
    m_moreVC = [self.storyboard instantiateViewControllerWithIdentifier:VIEW_TAB_MORE];
    m_moreNC = [[UINavigationController alloc] initWithRootViewController:m_moreVC];
    m_moreNC.navigationBarHidden = YES;
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANG_ALB]) {
        tabBarItems = [NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_0_alb", @"image", @"tabbar_0_alb", @"image_locked", m_homeNC, @"viewController", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_1_alb", @"image", @"tabbar_1_alb", @"image_locked", m_profileNC, @"viewController", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_3_alb", @"image", @"tabbar_3_alb", @"image_locked", m_shopNC, @"viewController", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_4_alb", @"image", @"tabbar_4_alb", @"image_locked", m_moreNC, @"viewController", nil], nil];
    } else {
        tabBarItems = [NSArray arrayWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_0", @"image", @"tabbar_0", @"image_locked", m_homeNC, @"viewController", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_1", @"image", @"tabbar_1", @"image_locked", m_profileNC, @"viewController", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_3", @"image", @"tabbar_3", @"image_locked", m_shopNC, @"viewController", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"tabbar_4", @"image", @"tabbar_4", @"image_locked", m_moreNC, @"viewController", nil], nil];
    }
    
    
    return tabBarItems;    
}

- (void)ShowMenu {
    
    m_viewMenu.hidden = NO;
    m_viewMenu.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        m_viewMenu.alpha = 1;
    }];
}

- (void)dismissPost {
    
    [UIView animateWithDuration:.3 animations:^{
        m_viewMenu.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            m_viewMenu.hidden = YES;
        }
    }];
}

-(IBAction)onCloseMenu:(id)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        m_viewMenu.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            m_viewMenu.hidden = YES;
        }
    }];

}

-(IBAction)onSetNewImage:(id)sender {

    [UIView animateWithDuration:.2 animations:^{
        m_viewMenu.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            m_viewMenu.hidden = YES;            
            [self performSegueWithIdentifier:SEGUE_NEW_IMAGE sender:nil];
            
//            UIImage *image = [UIImage imageNamed:@"logo_camera"];
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            picker.navigationController.tabBarItem.image = image;
//            picker.delegate = self;
//            
//            [self presentViewController:picker animated:YES completion:nil];
            
            
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
//            
//            UIImage *image = [UIImage imageNamed:@"logo_camera"];
//            imagePicker.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
//
//            [imagePicker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//            if(m_popoverController != nil) {
//                [m_popoverController dismissPopoverAnimated:YES];
//                m_popoverController = nil;
//            }
//            
//            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//                    m_popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
//                    m_popoverController.delegate = self;
//                    [m_popoverController presentPopoverFromRect:CGRectMake(0, 0, 1024, 160)
//                                                         inView:self.view
//                                       permittedArrowDirections:UIPopoverArrowDirectionAny
//                                                       animated:YES];
//                } else {
//                    
//                    [self presentViewController:imagePicker animated:YES completion:nil];
//                }
//            }
            
        }
    }];
}

#pragma mark - image picker controller

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [GlobalData sharedGlobalData].g_imgPostBack = info[@"UIImagePickerControllerEditedImage"];
    [GlobalData sharedGlobalData].g_imgPostBack = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    m_pickerController = picker;
    
    HDImageEditViewController *controller = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_IMAGE_EDIT];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [m_pickerController presentViewController:navigationController animated:YES completion:nil];
}

-(IBAction)onSetNewPost:(id)sender {
    
    [UIView animateWithDuration:.2 animations:^{
        m_viewMenu.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            m_viewMenu.hidden = YES;
            [self performSegueWithIdentifier:SEGUE_NEW_POST sender:nil];
        }
    }];
}

-(IBAction)onSetNewVoice:(id)sender {
    
    [UIView animateWithDuration:.2 animations:^{
        m_viewMenu.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            m_viewMenu.hidden = YES;
            [self performSegueWithIdentifier:SEGUE_NEW_VOICE sender:nil];
        }
    }];
}

- (void)goToPostDetails {
    
    HDPostDetailsViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_POST_DETAILS];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (void)goToFeedback {
    
    [self performSegueWithIdentifier:SEGUE_FEEDBACK sender:nil];
}

- (void)goToWhatsKarma {
    
    [self performSegueWithIdentifier:SEGUE_WHATS_KARMA sender:nil];
}

- (void)goToTermsUse {
    
    [self performSegueWithIdentifier:SEGUE_TERMS_USE sender:nil];
}

- (void)goToOffers {
    
    [self performSegueWithIdentifier:SEGUE_OFFERS sender:nil];
}

- (void)goToInviteFriends {
    
    [self performSegueWithIdentifier:SEGUE_INVITE_FRIENDS sender:nil];
}

- (void)goToOfferDetails {
    
    [self performSegueWithIdentifier:SEGUE_OFFER_DETAILS sender:nil];
}

- (void)goToPhotoDetails {
    
    [self performSegueWithIdentifier:SEGUE_PHOTO sender:nil];
}

- (IBAction)unwindPostPhoto:(UIStoryboardSegue *)unwindSegue {
    
    
}

- (IBAction)unwindPostVoice:(UIStoryboardSegue *)unwindSegue {
    
    
}

- (IBAction)unwindGoToOffer:(UIStoryboardSegue *)unwindSegue {
    
    [self touchBtnAtIndex:2];
    
    if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANG_ALB]) {
        [_tabbar.tabbarView setImage:[UIImage imageNamed:@"tabbar_3_alb"]];
    } else {
        [_tabbar.tabbarView setImage:[UIImage imageNamed:@"tabbar_3"]];
    }
}

@end
