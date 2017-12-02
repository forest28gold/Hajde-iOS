//
//  HDNewVoiceViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDNewVoiceViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder *recorder;
    NSTimer *timerRec;
}
@property (retain, nonatomic) AVAudioPlayer *audioPlay;
@property (strong, nonatomic) IBOutlet UILabel *m_lblTabHold;
@property (strong, nonatomic) IBOutlet UILabel *m_lblTime;
@property (strong, nonatomic) IBOutlet UILabel *m_lblCondition;
@property (strong, nonatomic) IBOutlet UIButton *m_btnRecord;

@end
