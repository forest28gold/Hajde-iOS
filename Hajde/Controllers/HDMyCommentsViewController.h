//
//  HDMyCommentsViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 5/3/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDMyCommentsViewController : UIViewController
{
    AudioPlayer *_audioPlayer;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UIView *m_viewEmpty;

@end
