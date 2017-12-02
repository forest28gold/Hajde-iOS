//
//  HDPreviewRecordingViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDPreviewRecordingViewController.h"

@interface HDPreviewRecordingViewController () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    
    int timeCounter;
    int audioLength;
    NSTimer *timerPlay;
    
    NSArray *colorArray;
    int color_count;
    NSString *strBackColor;
}

@end

@implementation HDPreviewRecordingViewController

@synthesize m_btnPlay, m_lblAudioTime, m_viewPostAudio, m_imgWave;
@synthesize m_btnColor1, m_btnColor2, m_btnColor3, m_btnColor4, m_btnColor5;
@synthesize m_btnColor6, m_btnColor7, m_btnColor8, m_btnColor9, m_btnColor10, m_btnColor11;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupLocationManager];
    [_locationManager startUpdatingLocation];
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[GlobalData sharedGlobalData].g_strRecordFileUrl error:nil];
    self.audioPlay = player;
    self.audioPlay.delegate = self;
    self.audioPlay.meteringEnabled = YES;
    audioLength = self.audioPlay.duration;
    
    timeCounter = audioLength;
    m_lblAudioTime.text = [NSString stringWithFormat:@"0:%02d", audioLength];
    [m_btnPlay setImage:[UIImage imageNamed:@"voice_play"] forState:UIControlStateNormal];
    
//    m_imgWave.hidden = YES;    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    colorArray = [NSArray arrayWithObjects:COLOR_1, COLOR_2, COLOR_3, COLOR_4, COLOR_5, COLOR_6, COLOR_7, COLOR_8, COLOR_9, COLOR_10, COLOR_11, nil];
    color_count = 0;
    strBackColor = COLOR_1;
    
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:COLOR_1];
    
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
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
    m_viewPostAudio.backgroundColor = [UIColor colorWithHexString:strBackColor];
    [self onSetSwipeColor:color_count];
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    if (flag) {
        [timerPlay invalidate];
        m_lblAudioTime.text = [NSString stringWithFormat:@"0:%02d", audioLength];
        [m_btnPlay setImage:[UIImage imageNamed:@"voice_play"] forState:UIControlStateNormal];
        timeCounter = audioLength;
//        m_imgWave.hidden = YES;
    }
}

- (IBAction)onBack:(id)sender {
    [self removeRecord:[NSString stringWithFormat:@"hajde%@.%@", [GlobalData sharedGlobalData].g_strRecordFileName, RECORD_FILE_FORMAT]];
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

- (IBAction)onAudioPlay:(id)sender {
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    
    if (self.audioPlay.playing) {
        [m_btnPlay setImage:[UIImage imageNamed:@"voice_play"] forState:UIControlStateNormal];
        [self.audioPlay stop];
        [timerPlay invalidate];
//        m_imgWave.hidden = YES;
        return;
    } else {
        [m_btnPlay setImage:[UIImage imageNamed:@"voice_pause"] forState:UIControlStateNormal];
        timerPlay = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCounting) userInfo:nil repeats:YES];
        [self.audioPlay play];
//        m_imgWave.hidden = NO;
    }
    
}

- (void)timerCounting {
    
    if (timeCounter == 0) {
        
        NSLog(@"Timer is end.");
        [timerPlay invalidate];
        
        timeCounter = audioLength;
        
    } else {
        
        NSLog(@"Timer => %02d", timeCounter);
        
        timeCounter--;
        m_lblAudioTime.text = [NSString stringWithFormat:@"0:%02d", timeCounter];
    }
}

- (void)removeRecord:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    if (fileExists) {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (success) {
            NSLog(@"Successfully removed");
        } else {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
    }
    
    [GlobalData sharedGlobalData].g_toggleRecordFileIsOn = false;
}

- (IBAction)onPost:(id)sender {
    
    SVPROGRESSHUD_SHOW;
    
    int randomID = arc4random() % 900000000 + 100000000;
    NSString *prefixName = [NSString stringWithFormat:@"%i", randomID];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_%0.0f.m4a", BACKEND_URL_AUDIO, prefixName, [[NSDate date] timeIntervalSince1970]];
    NSData *fileData = [NSData dataWithContentsOfURL:[GlobalData sharedGlobalData].g_strRecordFileUrl];
    
    [backendless.fileService saveFile:fileName content:fileData response:^(BackendlessFile *uploadFile) {
        
        NSLog(@"audio file -> %@", uploadFile.fileURL);
        
        Post *post = [Post new];
        post.type = POST_TYPE_AUDIO;
        post.filePath = uploadFile.fileURL;
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
        post.period = [NSString stringWithFormat:@"0:%02d", audioLength];
        
        [backendless.persistenceService save:post response:^(id response) {
            
            NSLog(@"saved new audio post data");
            
            SVPROGRESSHUD_DISMISS;
            
            [self removeRecord:[NSString stringWithFormat:@"hajde%@.%@", [GlobalData sharedGlobalData].g_strRecordFileName, RECORD_FILE_FORMAT]];
            
            [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_POST;
            [GlobalData sharedGlobalData].g_userInfo.postCount ++;
            [[GlobalData sharedGlobalData] updateUserDataDB];
            
            [HDUtility karmaInBackground:KARMA_POST];
            
            [self performSegueWithIdentifier:UNWIND_POST_VOICE sender:nil];
            
        } error:^(Fault *fault) {
            
            NSLog(@"Failed save in background of audio post data, = %@ <%@>", fault.message, fault.detail);
            
            SVPROGRESSHUD_DISMISS;
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_new_posting_failed", "")];
            
        }];
        
    } error:^(Fault *fault) {
        
        NSLog(@"Failed save in background of audio data, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_new_posting_failed", "")];
        
    }];
    
}

@end
