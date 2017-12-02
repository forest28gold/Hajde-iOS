//
//  HDNewPostViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDNewPostViewController.h"

@interface HDNewPostViewController () <UITextViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    
    BOOL toggleKeyboardIsOn;
    NSArray *colorArray;
    int color_count;
    NSString *strBackColor;
}

@end

@implementation HDNewPostViewController

@synthesize m_txtPost, m_viewPost, m_viewPostText;
@synthesize m_btnColor1, m_btnColor2, m_btnColor3, m_btnColor4, m_btnColor5;
@synthesize m_btnColor6, m_btnColor7, m_btnColor8, m_btnColor9, m_btnColor10, m_btnColor11;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupLocationManager];
    [_locationManager startUpdatingLocation];
    
    toggleKeyboardIsOn = false;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *tapGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    m_txtPost.text = NSLocalizedString(@"share_yout_thoughts", "");
    
    colorArray = [NSArray arrayWithObjects:COLOR_1, COLOR_2, COLOR_3, COLOR_4, COLOR_5, COLOR_6, COLOR_7, COLOR_8, COLOR_9, COLOR_10, COLOR_11, nil];
    color_count = 0;
    strBackColor = COLOR_1;
    
    [m_btnColor1 setBackgroundColor:[UIColor colorWithHexString:COLOR_1]];
    [m_btnColor2 setBackgroundColor:[UIColor colorWithHexString:COLOR_2]];
    [m_btnColor3 setBackgroundColor:[UIColor colorWithHexString:COLOR_3]];
    [m_btnColor4 setBackgroundColor:[UIColor colorWithHexString:COLOR_4]];
    [m_btnColor5 setBackgroundColor:[UIColor colorWithHexString:COLOR_5]];
    [m_btnColor6 setBackgroundColor:[UIColor colorWithHexString:COLOR_6]];
    [m_btnColor7 setBackgroundColor:[UIColor colorWithHexString:COLOR_7]];
    [m_btnColor8 setBackgroundColor:[UIColor colorWithHexString:COLOR_8]];
    [m_btnColor9 setBackgroundColor:[UIColor colorWithHexString:COLOR_9]];
    [m_btnColor10 setBackgroundColor:[UIColor colorWithHexString:COLOR_10]];
    [m_btnColor11 setBackgroundColor:[UIColor colorWithHexString:COLOR_11]];
    
    m_btnColor1.layer.cornerRadius = m_btnColor1.frame.size.height / 2;
    m_btnColor2.layer.cornerRadius = m_btnColor2.frame.size.height / 2;
    m_btnColor3.layer.cornerRadius = m_btnColor3.frame.size.height / 2;
    m_btnColor4.layer.cornerRadius = m_btnColor4.frame.size.height / 2;
    m_btnColor5.layer.cornerRadius = m_btnColor5.frame.size.height / 2;
    m_btnColor6.layer.cornerRadius = m_btnColor6.frame.size.height / 2;
    m_btnColor7.layer.cornerRadius = m_btnColor7.frame.size.height / 2;
    m_btnColor8.layer.cornerRadius = m_btnColor8.frame.size.height / 2;
    m_btnColor9.layer.cornerRadius = m_btnColor9.frame.size.height / 2;
    m_btnColor10.layer.cornerRadius = m_btnColor10.frame.size.height / 2;
    m_btnColor11.layer.cornerRadius = m_btnColor11.frame.size.height / 2;
    
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:COLOR_1];
    
    [self onSetColor1];
    
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

- (void)onSetColor1 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 0;
    strBackColor = COLOR_1;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor2 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 1;
    strBackColor = COLOR_2;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor3 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 2;
    strBackColor = COLOR_3;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor4 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 3;
    strBackColor = COLOR_4;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor5 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 4;
    strBackColor = COLOR_5;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor6 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 5;
    strBackColor = COLOR_6;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor7 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 6;
    strBackColor = COLOR_7;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor8 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 7;
    strBackColor = COLOR_8;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor9 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 8;
    strBackColor = COLOR_9;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor10 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.3, 1.3);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    color_count = 9;
    strBackColor = COLOR_10;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetColor11 {
    
    m_btnColor1.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor2.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor3.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor4.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor5.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor6.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor7.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor8.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor9.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor10.transform = CGAffineTransformMakeScale(1.0, 1.0);
    m_btnColor11.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    color_count = 10;
    strBackColor = COLOR_11;
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
}

- (void)onSetSwipeColor:(int)colorNumber {
    
    switch (colorNumber) {
        case 0:
            [self onSetColor1];
            break;
        case 1:
            [self onSetColor2];
            break;
        case 2:
            [self onSetColor3];
            break;
        case 3:
            [self onSetColor4];
            break;
        case 4:
            [self onSetColor5];
            break;
        case 5:
            [self onSetColor6];
            break;
        case 6:
            [self onSetColor7];
            break;
        case 7:
            [self onSetColor8];
            break;
        case 8:
            [self onSetColor9];
            break;
        case 9:
            [self onSetColor10];
            break;
        case 10:
            [self onSetColor11];
            break;
        default:
            [self onSetColor1];
            break;
    }
    
}

- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left"); //Next
        
        if (color_count == 10) {
            color_count = 0;
        } else {
            color_count++;
        }
        
        
        
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right"); //Before
        
        if (color_count == 0) {
            color_count = 10;
        } else {
            color_count--;
        }
    }
    
    strBackColor = colorArray[color_count];
    m_viewPostText.backgroundColor = [UIColor colorWithHexString:strBackColor];
    [self onSetSwipeColor:color_count];
    
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([m_txtPost.text isEqualToString:NSLocalizedString(@"share_yout_thoughts", "")]) {
        m_txtPost.text = @"";
    }
    
    if (toggleKeyboardIsOn) {
        
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.m_viewPost.frame = CGRectMake(self.m_viewPost.frame.origin.x, (self.m_viewPost.frame.origin.y - 250.0), self.m_viewPost.frame.size.width, self.m_viewPost.frame.size.height);
        [UIView commitAnimations];
        toggleKeyboardIsOn = true;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([m_txtPost.text isEqualToString:@""]) {
        m_txtPost.text = NSLocalizedString(@"share_yout_thoughts", "");
    } else if (textView.text.length > 250) {
        textView.text = [textView.text substringToIndex:250];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView.text.length > 250) {
        textView.text = [textView.text substringToIndex:250];
    }
    
    int numLines = textView.contentSize.height / textView.font.lineHeight;
    
    if (numLines > 9) {
        textView.text = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }
    
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return true;
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    
    if (toggleKeyboardIsOn) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.m_viewPost.frame = CGRectMake(self.m_viewPost.frame.origin.x, (self.m_viewPost.frame.origin.y + 250.0), self.m_viewPost.frame.size.width, self.m_viewPost.frame.size.height);
        [UIView commitAnimations];
        toggleKeyboardIsOn = false;
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSelectColor1:(id)sender {
    [self onSetColor1];
}

- (IBAction)onSelectColor2:(id)sender {
    [self onSetColor2];
}

- (IBAction)onSelectColor3:(id)sender {
    [self onSetColor3];
}

- (IBAction)onSelectColor4:(id)sender {
    [self onSetColor4];
}

- (IBAction)onSelectColor5:(id)sender {
    [self onSetColor5];
}

- (IBAction)onSelectColor6:(id)sender {
    [self onSetColor6];
}

- (IBAction)onSelectColor7:(id)sender {
    [self onSetColor7];
}

- (IBAction)onSelectColor8:(id)sender {
    [self onSetColor8];
}

- (IBAction)onSelectColor9:(id)sender {
    [self onSetColor9];
}

- (IBAction)onSelectColor10:(id)sender {
    [self onSetColor10];
}

- (IBAction)onSelectColor11:(id)sender {
    [self onSetColor11];
}

- (IBAction)onPost:(id)sender {
    
//    [self onRemovePostData];
//    [self onRemoveCommentData];
//    [self onRemoveKarmaData];
//    [self onGetUserIDs];
    
    [GlobalData sharedGlobalData].g_userInfo.latitude = _locationManager.location.coordinate.latitude;
    [GlobalData sharedGlobalData].g_userInfo.longitude = _locationManager.location.coordinate.longitude;
    
    NSLog(@"latitude -> %f,  longitude -> %f", [GlobalData sharedGlobalData].g_userInfo.latitude, [GlobalData sharedGlobalData].g_userInfo.longitude);
    
    NSString *strPost = m_txtPost.text;
    
    if ([strPost isEqualToString:NSLocalizedString(@"share_yout_thoughts", "")] || [strPost isEqualToString:@""]) {
        [self dismissKeyboard];
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_input_post", "")];
        return;
    }
    
    NSData *data = [strPost dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *postValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    Post *post = [Post new];
    post.type = POST_TYPE_TEXT;
    post.content = postValue;
    post.userID = [GlobalData sharedGlobalData].g_userInfo.userID;
    post.backColor = colorArray[color_count];
    post.latitude = [NSString stringWithFormat: @"%f", [GlobalData sharedGlobalData].g_userInfo.latitude];
    post.longitude = [NSString stringWithFormat: @"%f", [GlobalData sharedGlobalData].g_userInfo.longitude];
    post.time = [[GlobalData sharedGlobalData] getCurrentDate];
    post.commentCount = 0;
    post.likeCount = 0;
    post.reportCount = 0;
    post.reportType = @"";
    post.likeType = @"";
    post.commentType = @"";
    
    SVPROGRESSHUD_SHOW;
    
    [backendless.persistenceService save:post response:^(id response) {
        
        NSLog(@"saved new post data");
        
        SVPROGRESSHUD_DISMISS;
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_POST;
        [GlobalData sharedGlobalData].g_userInfo.postCount ++;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        
        [HDUtility karmaInBackground:KARMA_POST];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } error:^(Fault *fault) {
        
        NSLog(@"Failed save in background of post data, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_new_posting_failed", "")];
        
    }];

}

- (void)onFakePost {
    
    Post *post = [Post new];
    post.type = POST_TYPE_TEXT;
    post.content = @"bvb";
    post.userID = @"481320fa6907724e";
    post.backColor = @"";
    post.latitude = @"0.0";
    post.longitude = @"0.0";
    post.time = @"11/23/2016 02:30:24";
//    post.commentCount = 0;
//    post.likeCount = 0;
//    post.reportCount = 0;
//    post.reportType = @"";
//    post.likeType = @"";
//    post.commentType = @"";
    
    SVPROGRESSHUD_SHOW;
    
    [backendless.persistenceService save:post response:^(id response) {
        
        NSLog(@"saved new post data");
        
        SVPROGRESSHUD_DISMISS;
        
    } error:^(Fault *fault) {
        
        NSLog(@"Failed save in background of post data, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_new_posting_failed", "")];
        
    }];
    
}

- (void)onDeletePostData {
    
    SVPROGRESSHUD_SHOW;
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, @"5A9205BB-F54F-797C-FF96-943EA8C4B300"];
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (posts.data.count > 0) {
            
            for (Post *post in posts.data) {
                
                [[backendless.persistenceService of:[Post class]] removeID:post.objectId];
            }
            
        }
        
        NSLog(@"================ Success =====================");
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        NSLog(@"Failed finding of post data, = %@ <%@>", fault.message, fault.detail);
        
    }];
    
}

//lat   :  37.785834   ,  lng   :  -122.406417

- (void)onRemovePostData {
    
    SVPROGRESSHUD_SHOW;

    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ LIKE \'%%%@%%\'", KEY_LONGITUDE, @"-122."];
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (posts.data.count > 0) {
            
            for (Post *post in posts.data) {
                
                [[backendless.persistenceService of:[Post class]] removeID:post.objectId];
            }
            
        }
        
        NSLog(@"================ Success =====================");
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        NSLog(@"Failed finding of post data, = %@ <%@>", fault.message, fault.detail);
        
    }];
    
}

- (void)onRemoveCommentData {
    
    SVPROGRESSHUD_SHOW;
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
//    query.whereClause = [NSString stringWithFormat:@"%@ LIKE \'%%%@%%\'", KEY_LONGITUDE, @"-122."];
    query.whereClause = [NSString stringWithFormat:@"fromUser = \'%@\'", @"42f7630204a0afc3"];
    [[backendless.persistenceService of:[ActivityPost class]] find:query response:^(BackendlessCollection *posts) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (posts.data.count > 0) {
            
            for (Post *post in posts.data) {
                
                [[backendless.persistenceService of:[ActivityPost class]] removeID:post.objectId];
            }
            
        }
        
        NSLog(@"================ Success =====================");
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        NSLog(@"Failed finding of post data, = %@ <%@>", fault.message, fault.detail);
        
    }];
    
}

//42f7630204a0afc3
//
//39E2E697-1358-49CD-BA3E-1A7BE4E0A4B7
//
//791B9E70-734F-492A-8C19-268886855E7D
//
//8959C265-E033-4A1E-A6B8-07BE536A69EA
//
//EF882CD4-1844-4890-B3FB-F6E586CFBF7E


- (void)onRemoveKarmaData {
    
    SVPROGRESSHUD_SHOW;
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
    query.whereClause = [NSString stringWithFormat:@"%@ LIKE \'%%%@%%\'", KEY_USER_ID, @"42f7630204a0afc3"];
    [[backendless.persistenceService of:[Karma class]] find:query response:^(BackendlessCollection *posts) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (posts.data.count > 0) {
            
            for (Post *post in posts.data) {
                
                [[backendless.persistenceService of:[Karma class]] removeID:post.objectId];
            }
            
        }
        
        NSLog(@"================ Success =====================");
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        NSLog(@"Failed finding of post data, = %@ <%@>", fault.message, fault.detail);
        
    }];
    
}

- (void)onGetUserIDs {
    
    SVPROGRESSHUD_SHOW;
    
    BackendlessDataQuery *query = [BackendlessDataQuery query];
//    query.whereClause = [NSString stringWithFormat:@"%@ LIKE \'%%%@%%\'", KEY_USER_ID, @"8959C265-E033-4A1E-A6B8-07BE536A69EA"];
    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
        
        SVPROGRESSHUD_DISMISS;
        
        if (posts.data.count > 0) {
            
            NSMutableArray *array_userID = [[NSMutableArray alloc] init];
            
            for (Post *post in posts.data) {
                
                if (![array_userID containsObject:post.userID]) {
                    [array_userID addObject:post.userID];
                    NSLog(@"==== userID   :    %@ ========", post.userID);
                    NSLog(@"========= lat   :  %@   ,  lng   :  %@=======", post.latitude, post.longitude);
                }
            }
            
        }
        
        NSLog(@"================ Success =====================");
        
    } error:^(Fault *fault) {
        
        SVPROGRESSHUD_DISMISS;
        NSLog(@"Failed finding of post data, = %@ <%@>", fault.message, fault.detail);
        
    }];
    
}


@end
