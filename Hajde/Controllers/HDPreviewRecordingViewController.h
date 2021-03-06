//
//  HDPreviewRecordingViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDPreviewRecordingViewController : UIViewController <AVAudioPlayerDelegate>

@property (retain, nonatomic) AVAudioPlayer *audioPlay;
@property (strong, nonatomic) IBOutlet UIButton *m_btnPlay;
@property (strong, nonatomic) IBOutlet UILabel *m_lblAudioTime;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgWave;
@property (strong, nonatomic) IBOutlet UIView *m_viewPostAudio;

@property (strong, nonatomic) IBOutlet UIButton *m_btnColor1;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor2;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor3;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor4;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor5;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor6;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor7;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor8;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor9;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor10;
@property (strong, nonatomic) IBOutlet UIButton *m_btnColor11;

@end
