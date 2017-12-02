//
//  HDInviteFriendsViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 5/16/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDInviteFriendsViewController.h"
#import "KTSContactsManager.h"
#import <MessageUI/MessageUI.h>

@interface HDInviteFriendsViewController () <KTSContactsManagerDelegate, MFMessageComposeViewControllerDelegate> {
    NSIndexPath* checkedIndexPath;
    NSArray *indexesABC;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) NSMutableArray *contactArray;
@property (strong, nonatomic) NSMutableArray *selectedUsers;
@property (strong, nonatomic) KTSContactsManager *contactsManager;

@end

@implementation HDInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.delegate = self;
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES] ];
    [self loadData];
    
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

- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.tableData = contacts;
         
         self.contactArray = [[NSMutableArray alloc] init];
         
         for (NSDictionary *contact in contacts) {
             
             InviteFriendData *record = [[InviteFriendData alloc] init];
             
             NSString *firstName = contact[@"firstName"];
             record.userName = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@", contact[@"lastName"]]];
             
             NSArray *emails = contact[@"emails"];
             
             if ([emails count] > 0) {
                 NSDictionary *emailItem = emails[0];
                 record.phoneNumber = emailItem[@"value"];
             } else {
                 
                 NSArray *phones = contact[@"phones"];
                 
                 if ([phones count] > 0) {
                     NSDictionary *phoneItem = phones[0];
                     record.phoneNumber = phoneItem[@"value"];
                 } else {
                     record.phoneNumber = @"";
                 }
             }            
             
             
             UIImage *image = contact[@"image"];
             record.userPhoto = (image != nil) ? image : [UIImage imageNamed:@"avatar"];
             
             record.selectIsOn = false;
             
             [self.contactArray addObject:record];
         }
         
         [self.tableView reloadData];
         NSLog(@"contacts: %@",contacts);
     }];
}

-(void)addressBookDidChange
{
    NSLog(@"Address Book Change");
    [self loadData];
}

-(BOOL)filterToContact:(NSDictionary *)contact
{
    return YES;
    return ![contact[@"company"] isEqualToString:@""];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contactArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"contactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    InviteFriendData *contact = [self.contactArray objectAtIndex:indexPath.row];
    
    /* create cell here */
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    nameLabel.text = contact.userName;
    
    UILabel *phoneNumber = (UILabel *)[cell viewWithTag:2];
    phoneNumber.text = contact.phoneNumber;
    
    UIImageView *cellIconView = (UIImageView *)[cell.contentView viewWithTag:888];
    
    cellIconView.image = contact.userPhoto;
    cellIconView.contentScaleFactor = UIViewContentModeScaleAspectFill;
    cellIconView.layer.cornerRadius = CGRectGetHeight(cellIconView.frame) / 2;
    
    
    if(contact.selectIsOn) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma didSelectRowAtIndexPath

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    InviteFriendData *contact = [self.contactArray objectAtIndex:indexPath.row];
    
    if (contact.selectIsOn) {
        contact.selectIsOn = false;
    } else {
        contact.selectIsOn = true;
    }
    
    [self.contactArray replaceObjectAtIndex:indexPath.row withObject:contact];
    
    [self.tableView reloadData];
}

#pragma SMS

- (void)showSMS:(NSArray *)selectedItems {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "") message:NSLocalizedString(@"alert_device_doesnt_support_sms", "") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", "") otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    // Please Download Bold at www.applestore.com/bold/
    NSString *message = [NSString stringWithFormat:@"%@   %@", NSLocalizedString(@"signup_hajde", ""), HAJDE_APP_LINK];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:selectedItems];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "") message:NSLocalizedString(@"alert_failed_sms", "") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", "") otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            
            SVPROGRESSHUD_SUCCESS(NSLocalizedString(@"alert_invite_sent", ""));
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSendSMS:(id)sender {
    
    self.selectedUsers = [[NSMutableArray alloc] init];
    
    for (InviteFriendData *contact in self.contactArray) {
        
        if (contact.selectIsOn) {
            [self.selectedUsers addObject:contact.phoneNumber];
        }
    }
    
    [self showSMS:self.selectedUsers];

}


@end
