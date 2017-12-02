//
//  HDNewVoiceViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDNewVoiceViewController.h"
#import "HDPreviewRecordingViewController.h"
#import <AudioToolbox/AudioServices.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface HDNewVoiceViewController ()
{
    int timeCounter;
    int audioLength;
}

@end

@implementation HDNewVoiceViewController

@synthesize m_btnRecord, m_lblCondition, m_lblTabHold, m_lblTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initRecord];
    
    UILongPressGestureRecognizer *btn_LongPress_gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleBtnLongPressGesture:)];
    [m_btnRecord addGestureRecognizer:btn_LongPress_gesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initRecord];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initRecord {
    
    timeCounter = 0;
    
    m_lblCondition.hidden = NO;
    m_lblTabHold.text = NSLocalizedString(@"tap_hold", "");
    m_lblTime.text = NSLocalizedString(@"recording_button_start", "");
    [m_lblTime setTextColor:[UIColor lightGrayColor]];
    [m_btnRecord setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    
    if ([GlobalData sharedGlobalData].g_toggleRecordFileIsOn) {
        [self removeRecord:[NSString stringWithFormat:@"hajde%@.%@", [GlobalData sharedGlobalData].g_strRecordFileName, RECORD_FILE_FORMAT]];
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

- (void)initRecorder {
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride),&audioRouteOverride);
    
    //init Record
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //AVSampleRateKey==8000/44100/96000
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    //    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [GlobalData sharedGlobalData].g_strRecordFileName = [self getCurrentTime];
    [GlobalData sharedGlobalData].g_strRecordFileName = [[GlobalData sharedGlobalData].g_strRecordFileName stringByReplacingOccurrencesOfString:@":" withString:@""];
    [GlobalData sharedGlobalData].g_strRecordFileName = [[GlobalData sharedGlobalData].g_strRecordFileName stringByReplacingOccurrencesOfString:@"  " withString:@""];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/hajde%@.%@", DOCUMENTS_FOLDER, [GlobalData sharedGlobalData].g_strRecordFileName, RECORD_FILE_FORMAT]];
    [GlobalData sharedGlobalData].g_strRecordFileUrl = url;
    
    NSLog(@"Record file Path ->%@", [NSString stringWithFormat:@"%@/hajde%@.%@", DOCUMENTS_FOLDER, [GlobalData sharedGlobalData].g_strRecordFileName, RECORD_FILE_FORMAT]);
    
    NSError *error;
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

- (NSString*)getCurrentTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd  hh:mm:ss"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleBtnLongPressGesture:(UILongPressGestureRecognizer *)recognizer {
    
    //as you hold the button this would fire
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long Press...");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self onRecordingStart];
        });
    }
    
    // as you release the button this would fire
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"End Press.");
        
        [self onPreviewRecording];
    }
}

- (void)onRecordingStart {

    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    
    [self initRecorder];

    m_lblCondition.hidden = YES;
    m_lblTabHold.text = NSLocalizedString(@"recording", "");
    m_lblTime.text = @"0:00 / 0:15";
    [m_btnRecord setImage:[UIImage imageNamed:@"recording"] forState:UIControlStateNormal];
    
    timerRec = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCounting) userInfo:nil repeats:YES];
    
    [recorder prepareToRecord];
    [recorder record];
    
}

- (void)timerCounting {
    
    if (timeCounter == 15) {
        
        NSLog(@"Timer is end.");
        
        m_lblTabHold.text = NSLocalizedString(@"recording_end", "");
        m_lblTime.text = @"0:15 / 0:15";
        [m_lblTime setTextColor:[UIColor redColor]];
        
        [self onPreviewRecording];
        
    } else {
        
        NSLog(@"Timer => %02d", timeCounter);
        
        timeCounter++;
        m_lblTime.text = [NSString stringWithFormat:@"0:%02d / 0:15", timeCounter];
    }
}

- (void)onPreviewRecording {
    
    [timerRec invalidate];
    
    if (recorder != nil && recorder.isRecording) {
        [recorder stop];
    }
    
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[GlobalData sharedGlobalData].g_strRecordFileUrl error:nil];
    self.audioPlay = player;
    self.audioPlay.delegate = self;
    self.audioPlay.meteringEnabled = YES;
    [self.audioPlay play];
    
    audioLength = self.audioPlay.duration;
    
    if (audioLength > 0) {
        
        [GlobalData sharedGlobalData].g_toggleRecordFileIsOn = true;
        
        HDPreviewRecordingViewController *nextCtrl = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_PREVIEW_RECORDING];
        [self.navigationController pushViewController:nextCtrl animated:true];
        
    } else {
        
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_record_audio", "")];
        [self initRecord];
        return;
    }
    
}

@end
