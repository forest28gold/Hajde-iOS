//
//  HDHajdeFeedbackViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDHajdeFeedbackViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *m_viewMessage;
@property (strong, nonatomic) IBOutlet UITextField *m_txtFromEmail;
@property (strong, nonatomic) IBOutlet UITextField *m_txtToEmail;
@property (strong, nonatomic) IBOutlet UITextField *m_txtSubject;
@property (strong, nonatomic) IBOutlet UITextView *m_txtMessage;

@end
