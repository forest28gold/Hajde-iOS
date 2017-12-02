//
//  HDPostDetailsViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/27/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface HDPostDetailsViewController : UIViewController <HPGrowingTextViewDelegate>
{
    AudioPlayer *_audioPlayer;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet HPGrowingTextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *m_btnSend;
@property (strong, nonatomic) IBOutlet UILabel *m_lblTitle;

@end
