//
//  HDMostVotesViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDMostVotesViewController : UIViewController
{
    AudioPlayer *_audioPlayer;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UIView *m_viewEmpty;

@end
