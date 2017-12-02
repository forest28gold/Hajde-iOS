//
//  HDHajdeFeedbackViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDHajdeFeedbackViewController.h"

@interface HDHajdeFeedbackViewController () <UITextViewDelegate>
{
    BOOL toggleKeyboardIsOn;
}


@end

@implementation HDHajdeFeedbackViewController

@synthesize m_txtFromEmail, m_txtMessage, m_txtSubject, m_txtToEmail, m_viewMessage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    toggleKeyboardIsOn = false;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];

    m_txtToEmail.enabled = false;
    [m_txtMessage setTextColor:[UIColor colorWithHexString:@"#d0d1d2"]];
    
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

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([m_txtMessage.text isEqualToString:NSLocalizedString(@"enter_message", "")]) {
        m_txtMessage.text = @"";
        [m_txtMessage setTextColor:[UIColor darkGrayColor]];
    }
    
    if (toggleKeyboardIsOn) {
        
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.m_viewMessage.frame = CGRectMake(self.m_viewMessage.frame.origin.x, (self.m_viewMessage.frame.origin.y - 100.0), self.m_viewMessage.frame.size.width, self.m_viewMessage.frame.size.height);
        [UIView commitAnimations];
        toggleKeyboardIsOn = true;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([m_txtMessage.text isEqualToString:@""]) {
        m_txtMessage.text = NSLocalizedString(@"enter_message", "");
        [m_txtMessage setTextColor:[UIColor colorWithHexString:@"#d0d1d2"]];
    }
}

#pragma mark Keyboard

- (void)dismissKeyboard {
    [self.view endEditing:YES];
    
    if (toggleKeyboardIsOn) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.m_viewMessage.frame = CGRectMake(self.m_viewMessage.frame.origin.x, (self.m_viewMessage.frame.origin.y + 100.0), self.m_viewMessage.frame.size.width, self.m_viewMessage.frame.size.height);
        [UIView commitAnimations];
        toggleKeyboardIsOn = false;
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSend:(id)sender {
    
    NSString *strSubject = m_txtSubject.text;
    NSString *strFromEmail = m_txtFromEmail.text;
    NSString *strToEmail = m_txtToEmail.text;
    NSString *strMessage = m_txtMessage.text;
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,8}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([strSubject isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_input_subject", "")];
        return;
    } else if ([strFromEmail isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_input_from_email", "")];
        return;
    } else if(![emailTest evaluateWithObject:strFromEmail]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_input_from_email_correctly", "")];
        return;
    } else if ([strToEmail isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_input_to_email", "")];
        return;
    } else if(![emailTest evaluateWithObject:strToEmail]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_input_to_email_correctly", "")];
        return;
    } else if ([strMessage isEqualToString:@""]) {
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_input_message", "")];
        return;
    }
    
    [self dismissKeyboard];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
