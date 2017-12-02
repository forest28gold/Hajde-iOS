//
//  HDOffersViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/28/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDOffersViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (strong, nonatomic) IBOutlet UIView *m_viewEmpty;
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgMark;
@property (strong, nonatomic) IBOutlet UITextView *m_txtDescription;

@end
