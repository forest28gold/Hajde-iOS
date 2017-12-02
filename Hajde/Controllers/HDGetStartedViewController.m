//
//  HDGetStartedViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDGetStartedViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HDTabBarViewController.h"
#import "HDPrivacyPolicyViewController.h"
#import "HDTermsOfUseViewController.h"

@interface HDGetStartedViewController () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    NSString *deviceID;
    BOOL signupIsOn;
    Boolean countryIsOn;
}

@property (nonatomic, strong) AVPlayer *avplayer;
@property (strong, nonatomic) IBOutlet UIView *movieView;

@end

@implementation HDGetStartedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    signupIsOn = false;
    countryIsOn = false;
    
    [self setupLocationManager];
    [_locationManager startUpdatingLocation];
    
    @try {
        [backendless initAppFault];
        [backendless.messaging registerForRemoteNotifications];
        deviceID = [backendless.messagingService getRegistrations].deviceId;
        NSLog(@"viewDidLoad -> registerDevice: %@", deviceID);
    } @catch (Fault *fault) {
        deviceID = @"";
        NSLog(@"viewDidLoad -> register of Device is failed: %@", fault);
        
//        [backendless.messagingService unregisterDeviceAsync:^(id result) {
//            NSLog(@"%@", result);
//            
//            [backendless.messaging registerForRemoteNotifications];
//            deviceID = [backendless.messagingService getRegistrations].deviceId;
//            
//        } error:^(Fault *fault) {
//            NSLog(@"FAULT (ASYNC): %@", fault);
//        }];
        
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Not affecting background music playing
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"hajde" ofType:@"mov"]];
//    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mov"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [self.movieView.layer addSublayer:avPlayerLayer];
    
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self.avplayer play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.avplayer pause];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}

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
    
//    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"\"Hajde\" failed to get your location. Please allow \"Hajde\" to access your location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    [errorAlert show];
}

- (void)getCurrentCountryName {
    
    NSError *error = nil;
    NSString* lookUpString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true_or_false",
                              [GlobalData sharedGlobalData].g_userInfo.latitude,
                              [GlobalData sharedGlobalData].g_userInfo.longitude];
    
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
            
            NSString *countryCode = [placemark ISOcountryCode];
            //Obtains a locale identifier. This will handle every language
            NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
            //Obtains the country name from the locale BUT IN ENGLISH (you can set it as "en_UK" also)
            NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] displayNameForKey: NSLocaleIdentifier value:identifier];
            
            NSLog(@"I am currently at %@", country);
            
            [GlobalData sharedGlobalData].g_userInfo.country = country;
                        
        }
        
    }];
}

- (IBAction)onTermsOfUse:(id)sender {
    
//    HDTermsOfUseViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_TERMS_USE];
//    [self.navigationController pushViewController:nextCtrl animated:true];
    
    [GlobalData sharedGlobalData].g_toggleTermsIsOn = true;
    
    HDPrivacyPolicyViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_PRIVACY_POLICY];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onPrivacyPolicy:(id)sender {
    
    [GlobalData sharedGlobalData].g_toggleTermsIsOn = false;
    
    HDPrivacyPolicyViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_PRIVACY_POLICY];
    [self.navigationController pushViewController:nextCtrl animated:true];
}

- (IBAction)onGetStarted:(id)sender {
    
    if ([deviceID isEqualToString:@""]) {
        
        @try {
            [backendless.messagingService registerDevice];
            deviceID = [backendless.messagingService getRegistrations].deviceId;
            NSLog(@"viewDidLoad -> registerDevice: %@", deviceID);
        } @catch (Fault *fault) {
            deviceID = @"";
            NSLog(@"viewDidLoad -> register of Device is failed: %@", fault);
        }
        
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_allow_notification", "")];
        return;
    }
    
    [self signupWithAnonymous:deviceID password:HAJDE_PASSWORD];
//    [self signupWithAnonymous:@"2D498E77-5D46-4205-BCCC-2558D2EDCA0D" password:HAJDE_PASSWORD];

}

- (void)signupWithAnonymous:(NSString*)deviceUUID password:(NSString*)password {
    
    NSLog(@"========= Signup with Anonymous ================");
    
    SVPROGRESSHUD_SHOW;
    
    BackendlessUser *user = [BackendlessUser new];
    user.password = password;
    [user setProperty:KEY_DEVICE_UUID object:deviceUUID];
    [backendless.userService registering:user response:^(BackendlessUser *user) {
        
        NSLog(@"========= Signup is Success! ================");
        NSLog(@"signup user -> %@", user);
        
        SVPROGRESSHUD_DISMISS;
        
        [GlobalData sharedGlobalData].g_userInfo.userID = deviceUUID;
        [GlobalData sharedGlobalData].g_userInfo.deviceUUID = deviceUUID;
        [GlobalData sharedGlobalData].g_userInfo.password = password;
        [GlobalData sharedGlobalData].g_userInfo.signup = USER_LOGIN;
        
        [GlobalData sharedGlobalData].g_userInfo.spentTime = 0;
        [GlobalData sharedGlobalData].g_userInfo.karmaScore = 0;
        [GlobalData sharedGlobalData].g_userInfo.postCount = 0;
        [GlobalData sharedGlobalData].g_userInfo.commentCount = 0;
        [GlobalData sharedGlobalData].g_userInfo.voteCount = 0;
        [GlobalData sharedGlobalData].g_userInfo.dailyLoginCount = 0;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        
        [GlobalData sharedGlobalData].g_userInfo.lastLogin = [formatter stringFromDate:[user getProperty:@"created"]];
        
        [[GlobalData sharedGlobalData] updateUserDataDB];
        
        HDTabBarViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_TAB];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } error:^(Fault *fault) {
        
        NSLog(@"Failed save in background of user,= %@ <%@>", fault.message, fault.detail);
        
        signupIsOn = true;
        
        [self loginWithAnonymous:deviceUUID password:password];
        
    }];
    
}

- (void)loginWithAnonymous:(NSString*)deviceUUID password:(NSString*)password {
    
    SVPROGRESSHUD_SHOW;
    
    [backendless.userService login:deviceUUID password:password response:^(BackendlessUser *user) {
        
        SVPROGRESSHUD_DISMISS;
        
        NSLog(@"========= Login is Succeed! ================");
        NSLog(@"login user -> %@", user);
        
        [GlobalData sharedGlobalData].g_userInfo.userID = deviceUUID;
        [GlobalData sharedGlobalData].g_userInfo.deviceUUID = deviceUUID;
        [GlobalData sharedGlobalData].g_userInfo.password = password;
        [GlobalData sharedGlobalData].g_userInfo.signup = USER_LOGIN;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        [GlobalData sharedGlobalData].g_userInfo.lastLogin = [formatter stringFromDate:[user getProperty:@"created"]];
        NSString *currentLoginTime = [formatter stringFromDate:[user getProperty:KEY_LAST_LOGIN]];
        
        if (!signupIsOn) {
            
            if ([[GlobalData sharedGlobalData] getDailyLoginIsOn:currentLoginTime createdTime:[GlobalData sharedGlobalData].g_userInfo.lastLogin]) {
                
                [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_LOGIN;
                [HDUtility karmaInBackground:KARMA_LOGIN];
            }
        }
        
        [GlobalData sharedGlobalData].g_userInfo.lastLogin = (NSString*)currentLoginTime;
        
        [[GlobalData sharedGlobalData] updateUserDataDB];
        
        HDTabBarViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_TAB];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } error:^(Fault *fault) {
        
        NSLog(@"========= Login is failed! ================");
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_network_error", "")];
        
    }];
    
}

@end
