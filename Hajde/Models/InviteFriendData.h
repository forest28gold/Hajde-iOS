//
//  InviteFriendData.h
//  Hajde
//
//  Created by AppsCreationTech on 6/28/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteFriendData : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) UIImage *userPhoto;
@property (assign, nonatomic) BOOL selectIsOn;

@end
