//
//  HDUtility.m
//  Hajde
//
//  Created by AppsCreationTech on 5/7/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDUtility.h"
#import <Social/Social.h>

@implementation HDUtility

+ (NSString*)setCommentBackColor:(NSString *)postColor {
    
    if ([postColor isEqualToString:COLOR_1]) {
        return COMMENT_COLOR_1;
    } else if ([postColor isEqualToString:COLOR_2]) {
        return COMMENT_COLOR_2;
    } else if ([postColor isEqualToString:COLOR_3]) {
        return COMMENT_COLOR_3;
    } else if ([postColor isEqualToString:COLOR_4]) {
        return COMMENT_COLOR_4;
    } else if ([postColor isEqualToString:COLOR_5]) {
        return COMMENT_COLOR_5;
    } else if ([postColor isEqualToString:COLOR_6]) {
        return COMMENT_COLOR_6;
    } else if ([postColor isEqualToString:COLOR_7]) {
        return COMMENT_COLOR_7;
    } else if ([postColor isEqualToString:COLOR_8]) {
        return COMMENT_COLOR_8;
    } else if ([postColor isEqualToString:COLOR_9]) {
        return COMMENT_COLOR_9;
    } else if ([postColor isEqualToString:COLOR_10]) {
        return COMMENT_COLOR_10;
    } else if ([postColor isEqualToString:COLOR_11]) {
        return COMMENT_COLOR_11;
    } else {
        return COMMENT_COLOR_1;
    }
}

+ (void)likePostInBackground:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray {
    
    PostData *record = [[PostData alloc] init];
    record.commentTypeArray = [[NSMutableArray alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    record = dataArray[indexPath.row];
    
    if (![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, LIKE_TYPE]] && ![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, DISLIKE_TYPE]]) {
        
        NSString *item = [NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, LIKE_TYPE];
        [record.likeTypeArray addObject:item];
        record.likeCount = record.likeCount + 1;
        
        record.likeType = @"";
        if (record.likeTypeArray.count > 1) {
            record.likeType = record.likeTypeArray[0];
            for (int i = 1; i < record.likeTypeArray.count; i++) {
                record.likeType = [NSString stringWithFormat:@"%@;%@", record.likeType, record.likeTypeArray[i]];
            }
        } else if (record.likeTypeArray.count == 1) {
            record.likeType = record.likeTypeArray[0];
        }
        
        [dataArray replaceObjectAtIndex:indexPath.row withObject:record];
        
        
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_VOTE_LIKE;
        [GlobalData sharedGlobalData].g_userInfo.voteCount ++;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [self karmaInBackground:KARMA_VOTE_LIKE];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BackendlessDataQuery *query = [BackendlessDataQuery query];
            query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.objectId];
            [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
                
                if (posts.data.count > 0) {
                    
                    Post *updatedData = posts.data[0];
                    
                    [updatedData setLikeCount:record.likeCount];
                    [updatedData setLikeType:record.likeType];
                    
                    [[backendless.persistenceService of:[Post class]] save:updatedData response:^(id response) {
                        
                        NSLog(@"******************* Post Like is succeed!********************");
                        
                    } error:^(Fault *fault) {
                        
                        NSLog(@"******************* Post Like is failed!********************");
                        
                    }];
                    
                } else {
                    
                    NSLog(@"******************* Post Like is not found!********************");
                }
                
            } error:^(Fault *fault) {
                
                NSLog(@"******************* Post Like is time out!********************");
                
            }];
            
        });
    }
}

+ (void)dislikePostInBackground:(id)sender indexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray {
    
    UIButton *btn = (UIButton*)sender;
    
    PostData *record = [[PostData alloc] init];
    record.commentTypeArray = [[NSMutableArray alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    record = dataArray[indexPath.row];
    
    if (![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, DISLIKE_TYPE]] && ![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, LIKE_TYPE]]) {
        
        if ([[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"dislike_normal"]]) {
            
            if (record.likeCount == -4 && ![record.userID isEqualToString:ADMIN_EMAIL]) {
                
                [dataArray removeObjectAtIndex:indexPath.row];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[backendless.persistenceService of:[Post class]] removeID:record.objectId];
                    
                });
                
                if ([record.userID isEqualToString:[GlobalData sharedGlobalData].g_userInfo.userID]) {
                    
                    [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
                    [[GlobalData sharedGlobalData] updateUserDataDB];
                    [self karmaDecreaseInBackground:KARMA_DECREASE_DELETE_POST];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                                    message:NSLocalizedString(@"karma_post_5_downvotes", "")
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"ok", "")
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                } else {
                    
                    [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_VOTE_DISLIKE;
//                    [GlobalData sharedGlobalData].g_userInfo.voteCount ++;
                    [[GlobalData sharedGlobalData] updateUserDataDB];
                    [self karmaInBackground:KARMA_VOTE_DISLIKE];
                 
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
                        
                        [deviceIDArray addObject:record.userID];
                        
                        PublishOptions *options = [PublishOptions new];
//                        options.headers = @{@"ios-alert":NSLocalizedString(@"ios_post_deleted", ""),
//                                            @"ios-badge":PUSH_BADGE,
//                                            @"ios-sound":PUSH_SOUND};
                        
                        options.headers = @{@"ios-alert":NSLocalizedString(@"karma_post_5_downvotes", ""),
                                            @"ios-badge":PUSH_BADGE,
                                            @"ios-sound":PUSH_SOUND,
                                            @"android-ticker-text":NSLocalizedString(@"ios_post_deleted", ""),
                                            @"android-content-title":NSLocalizedString(@"ios_post_deleted", ""),
                                            @"android-content-text":NSLocalizedString(@"karma_post_5_downvotes", "")};
                        
                        DeliveryOptions *deliveryOptions = [DeliveryOptions new];
                        deliveryOptions.pushSinglecast = deviceIDArray;
                        
                        [backendless.messagingService publish:MESSAGING_CHANNEL message:NSLocalizedString(@"karma_post_5_downvotes", "") publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                            NSLog(@"showMessageStatus: %@", res.status);
                        } error:^(Fault *fault) {
                            NSLog(@"sendMessage: fault = %@", fault);
                        }];
                        
                    });
                }
                
            } else {
                
                [btn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
                
                NSString *item = [NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, DISLIKE_TYPE];
                [record.likeTypeArray addObject:item];
                record.likeCount = record.likeCount - 1;
                
                record.likeType = @"";
                if (record.likeTypeArray.count > 1) {
                    record.likeType = record.likeTypeArray[0];
                    for (int i = 1; i < record.likeTypeArray.count; i++) {
                        record.likeType = [NSString stringWithFormat:@"%@;%@", record.likeType, record.likeTypeArray[i]];
                    }
                } else if (record.likeTypeArray.count == 1) {
                    record.likeType = record.likeTypeArray[0];
                }
                
                [dataArray replaceObjectAtIndex:indexPath.row withObject:record];
                
                
                [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_VOTE_DISLIKE;
                [GlobalData sharedGlobalData].g_userInfo.voteCount ++;
                [[GlobalData sharedGlobalData] updateUserDataDB];
                [self karmaInBackground:KARMA_VOTE_DISLIKE];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    BackendlessDataQuery *query = [BackendlessDataQuery query];
                    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.objectId];
                    [[backendless.persistenceService of:[Post class]] find:query response:^(BackendlessCollection *posts) {
                        
                        if (posts.data.count > 0) {
                            
                            Post *updatedData = posts.data[0];
                            
                            [updatedData setLikeCount:record.likeCount];
                            [updatedData setLikeType:record.likeType];
                            
                            [[backendless.persistenceService of:[Post class]] save:updatedData response:^(id response) {
                                
                                NSLog(@"******************* Post Disike is succeed!********************");
                                
                            } error:^(Fault *fault) {
                                
                                NSLog(@"******************* Post Disike is failed!********************");
                                
                            }];
                            
                        } else {
                            
                            NSLog(@"******************* Post Disike is not found!********************");
                        }
                        
                    } error:^(Fault *fault) {
                        
                        NSLog(@"******************* Post Disike is time out!********************");
                        
                    }];
                    
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
                    
                    [deviceIDArray addObject:record.userID];
//                    [deviceIDArray addObject:@"24CC1F30-3EDD-4454-93C0-C84A7D09566F"];
                    
                    PublishOptions *options = [PublishOptions new];
//                    options.headers = @{@"ios-alert":NSLocalizedString(@"karma_decreased", ""),
//                                        @"ios-badge":PUSH_BADGE,
//                                        @"ios-sound":PUSH_SOUND};
                    
                    options.headers = @{@"ios-alert":NSLocalizedString(@"karma_someone_downvote_post", ""),
                                        @"ios-badge":PUSH_BADGE,
                                        @"ios-sound":PUSH_SOUND,
                                        @"android-ticker-text":NSLocalizedString(@"karma_decreased", ""),
                                        @"android-content-title":NSLocalizedString(@"karma_decreased", ""),
                                        @"android-content-text":NSLocalizedString(@"karma_someone_downvote_post", "")};
                    
                    DeliveryOptions *deliveryOptions = [DeliveryOptions new];
                    deliveryOptions.pushSinglecast = deviceIDArray;
                    
                    [backendless.messagingService publish:MESSAGING_CHANNEL message:NSLocalizedString(@"karma_someone_downvote_post", "") publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                        NSLog(@"showMessageStatus: %@", res.status);
                    } error:^(Fault *fault) {
                        NSLog(@"sendMessage: fault = %@", fault);
                    }];
                    
                });
                
            }
            
        }
        
    }
    
}

+ (void)likeCommentInBackground:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray {
    
    ActivityPostData *record = [[ActivityPostData alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    record = dataArray[indexPath.row];
    
    if (![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, LIKE_TYPE]] && ![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, DISLIKE_TYPE]]) {
        
        NSString *item = [NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, LIKE_TYPE];
        [record.likeTypeArray addObject:item];
        record.likeCount = record.likeCount + 1;
        
        record.likeType = @"";
        if (record.likeTypeArray.count > 1) {
            record.likeType = record.likeTypeArray[0];
            for (int i = 1; i < record.likeTypeArray.count; i++) {
                record.likeType = [NSString stringWithFormat:@"%@;%@", record.likeType, record.likeTypeArray[i]];
            }
        } else if (record.likeTypeArray.count == 1) {
            record.likeType = record.likeTypeArray[0];
        }
        
        [dataArray replaceObjectAtIndex:indexPath.row withObject:record];
     
        [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_VOTE_LIKE;
        [GlobalData sharedGlobalData].g_userInfo.voteCount ++;
        [[GlobalData sharedGlobalData] updateUserDataDB];
        [self karmaInBackground:KARMA_COMMENT_LIKE];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BackendlessDataQuery *query = [BackendlessDataQuery query];
            query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.objectId];
            [[backendless.persistenceService of:[ActivityPost class]] find:query response:^(BackendlessCollection *comments) {
                
                if (comments.data.count > 0) {
                    
                    ActivityPost *updatedData = comments.data[0];
                    
                    [updatedData setLikeCount:record.likeCount];
                    [updatedData setLikeType:record.likeType];
                    
                    [[backendless.persistenceService of:[ActivityPost class]] save:updatedData response:^(id response) {
                        
                        NSLog(@"******************* Comment Like is succeed!********************");
                        
                    } error:^(Fault *fault) {
                        
                        NSLog(@"******************* Comment Like is failed!********************");
                        
                    }];
                    
                } else {
                    
                    NSLog(@"******************* Comment Like is not found!********************");
                }
                
            } error:^(Fault *fault) {
                
                NSLog(@"******************* Comment Like is time out!********************");
                
            }];
            
        });
    }
    
}

+ (void)dislikeCommentInBackground:(id)sender indexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray {
    
    UIButton *btn = (UIButton*)sender;
    
    ActivityPostData *record = [[ActivityPostData alloc] init];
    record.likeTypeArray = [[NSMutableArray alloc] init];
    record.reportTypeArray = [[NSMutableArray alloc] init];
    record = dataArray[indexPath.row];
    
    if (![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, DISLIKE_TYPE]] && ![record.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, LIKE_TYPE]]) {
        
        if ([[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"dislike_normal"]]) {
            
            if (record.likeCount == -4) {
                
                [dataArray removeObjectAtIndex:indexPath.row];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[backendless.persistenceService of:[ActivityPost class]] removeID:record.objectId];
                    
                });
                
                if ([record.toUser isEqualToString:[GlobalData sharedGlobalData].g_userInfo.userID]) {
                    
                    [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_DELETE_POST;
                    [[GlobalData sharedGlobalData] updateUserDataDB];
                    [self karmaDecreaseInBackground:KARMA_DECREASE_DELETE_COMMENT];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"karma", "")
                                                                    message:NSLocalizedString(@"karma_comment_5_downvotes", "")
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"ok", "")
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                } else {
                    
                    [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_VOTE_DISLIKE;
//                    [GlobalData sharedGlobalData].g_userInfo.voteCount ++;
                    [[GlobalData sharedGlobalData] updateUserDataDB];
                    [self karmaInBackground:KARMA_COMMENT_DISLIKE];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
                        
                        [deviceIDArray addObject:record.toUser];
                        
                        PublishOptions *options = [PublishOptions new];
//                        options.headers = @{@"ios-alert":NSLocalizedString(@"ios_comment_deleted", ""),
//                                            @"ios-badge":PUSH_BADGE,
//                                            @"ios-sound":PUSH_SOUND};
                        
                        options.headers = @{@"ios-alert":NSLocalizedString(@"karma_comment_5_downvotes", ""),
                                            @"ios-badge":PUSH_BADGE,
                                            @"ios-sound":PUSH_SOUND,
                                            @"android-ticker-text":NSLocalizedString(@"ios_comment_deleted", ""),
                                            @"android-content-title":NSLocalizedString(@"ios_comment_deleted", ""),
                                            @"android-content-text":NSLocalizedString(@"karma_comment_5_downvotes", "")};
                        
                        DeliveryOptions *deliveryOptions = [DeliveryOptions new];
                        deliveryOptions.pushSinglecast = deviceIDArray;
                        
                        [backendless.messagingService publish:MESSAGING_CHANNEL message:NSLocalizedString(@"karma_comment_5_downvotes", "") publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                            NSLog(@"showMessageStatus: %@", res);
                        } error:^(Fault *fault) {
                            NSLog(@"sendMessage: fault = %@", fault);
                        }];
                        
                    });
                    
                }
                
            } else {
                
                [btn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
                
                NSString *item = [NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, DISLIKE_TYPE];
                [record.likeTypeArray addObject:item];
                record.likeCount = record.likeCount - 1;
                
                record.likeType = @"";
                if (record.likeTypeArray.count > 1) {
                    record.likeType = record.likeTypeArray[0];
                    for (int i = 1; i < record.likeTypeArray.count; i++) {
                        record.likeType = [NSString stringWithFormat:@"%@;%@", record.likeType, record.likeTypeArray[i]];
                    }
                } else if (record.likeTypeArray.count == 1) {
                    record.likeType = record.likeTypeArray[0];
                }
                
                [dataArray replaceObjectAtIndex:indexPath.row withObject:record];
                
                
                [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_VOTE_DISLIKE;
                [GlobalData sharedGlobalData].g_userInfo.voteCount ++;
                [[GlobalData sharedGlobalData] updateUserDataDB];
                [self karmaInBackground:KARMA_COMMENT_DISLIKE];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    BackendlessDataQuery *query = [BackendlessDataQuery query];
                    query.whereClause = [NSString stringWithFormat:@"%@ = \'%@\'", KEY_OBJECT_ID, record.objectId];
                    [[backendless.persistenceService of:[ActivityPost class]] find:query response:^(BackendlessCollection *comments) {
                        
                        if (comments.data.count > 0) {
                            
                            ActivityPost *updatedData = comments.data[0];
                            
                            [updatedData setLikeCount:record.likeCount];
                            [updatedData setLikeType:record.likeType];
                            
                            [[backendless.persistenceService of:[ActivityPost class]] save:updatedData response:^(id response) {
                                
                                NSLog(@"******************* Comment Disike is succeed!********************");
                                
                            } error:^(Fault *fault) {
                                
                                NSLog(@"******************* Comment Disike is failed!********************");
                                
                            }];
                            
                        } else {
                            
                            NSLog(@"******************* Comment Disike is not found!********************");
                        }
                        
                    } error:^(Fault *fault) {
                        
                        NSLog(@"******************* Comment Disike is time out!********************");
                        
                    }];
                    
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSMutableArray *deviceIDArray = [[NSMutableArray alloc] init];
                    
                    [deviceIDArray addObject:record.toUser];
                    
                    PublishOptions *options = [PublishOptions new];
//                    options.headers = @{@"ios-alert":NSLocalizedString(@"karma_decreased", ""),
//                                        @"ios-badge":PUSH_BADGE,
//                                        @"ios-sound":PUSH_SOUND};
                    
                    options.headers = @{@"ios-alert":NSLocalizedString(@"karma_someone_downvote_comment", ""),
                                        @"ios-badge":PUSH_BADGE,
                                        @"ios-sound":PUSH_SOUND,
                                        @"android-ticker-text":NSLocalizedString(@"karma_decreased", ""),
                                        @"android-content-title":NSLocalizedString(@"karma_decreased", ""),
                                        @"android-content-text":NSLocalizedString(@"karma_someone_downvote_comment", "")};
                    
                    DeliveryOptions *deliveryOptions = [DeliveryOptions new];
                    deliveryOptions.pushSinglecast = deviceIDArray;
                    
                    [backendless.messagingService publish:MESSAGING_CHANNEL message:NSLocalizedString(@"karma_someone_downvote_comment", "") publishOptions:options deliveryOptions:deliveryOptions response:^(MessageStatus *res) {
                        NSLog(@"showMessageStatus: %@", res);
                    } error:^(Fault *fault) {
                        NSLog(@"sendMessage: fault = %@", fault);
                    }];
                    
                });
                
            }
        }
    }
}

+ (void)karmaInBackground:(NSString *)karmaType {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        Karma *karma = [Karma new];

        karma.userID = [GlobalData sharedGlobalData].g_userInfo.userID;
        karma.time = [[GlobalData sharedGlobalData] getCurrentDate];
        karma.type = karmaType;
        
        if ([karmaType isEqualToString:KARMA_POST]) {
            karma.backColor = COLOR_1;  //green  36d7b7
            karma.score = KARMA_SCORE_POST;
        } else if ([karmaType isEqualToString:KARMA_COMMENT]) {
            karma.backColor = COLOR_9;  //fuchsia   9878ff
            karma.score = KARMA_SCORE_COMMENT;
        } else if ([karmaType isEqualToString:KARMA_VOTE_LIKE] || [karmaType isEqualToString:KARMA_COMMENT_LIKE]) {
            karma.backColor = COLOR_10; //blue     43b9f6
            karma.score = KARMA_SCORE_VOTE_LIKE;
        } else if ([karmaType isEqualToString:KARMA_VOTE_DISLIKE] || [karmaType isEqualToString:KARMA_COMMENT_DISLIKE]) {
            karma.backColor = COLOR_5; //orion     6686ff
            karma.score = KARMA_SCORE_VOTE_DISLIKE;
        } else if ([karmaType isEqualToString:KARMA_ABUSE] || [karmaType isEqualToString:KARMA_COMMENT_ABUSE]) {
            karma.backColor = COLOR_7;  //yellowish     fe824c
            karma.score = KARMA_SCORE_ABUSE;
        } else if ([karmaType isEqualToString:KARMA_LOGIN]) {
            karma.backColor = COLOR_3;  //grey      aab2bd
            karma.score = KARMA_SCORE_LOGIN;
        }

        [backendless.persistenceService save:karma response:^(id response) {
            NSLog(@"saved karma data");
        } error:^(Fault *fault) {
            NSLog(@"Failed save in background of karma data, = %@ <%@>", fault.message, fault.detail);
        }];
        
    });
}

+ (void)karmaDecreaseInBackground:(NSString *)karmaType {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        Karma *karma = [Karma new];
        
        karma.userID = [GlobalData sharedGlobalData].g_userInfo.userID;
        karma.time = [[GlobalData sharedGlobalData] getCurrentDate];
        karma.type = karmaType;
        
        if ([karmaType isEqualToString:KARMA_DECREASE_POST] || [karmaType isEqualToString:KARMA_DECREASE_COMMENT]) {
            karma.backColor = COLOR_4;  //red   fe4c4c
            karma.score = KARMA_SCORE_DECREASE_POST;
        } else if ([karmaType isEqualToString:KARMA_DECREASE_DELETE_POST] || [karmaType isEqualToString:KARMA_DECREASE_DELETE_COMMENT]) {
            karma.backColor = COLOR_4;  //red   fe4c4c
            karma.score = KARMA_SCORE_DELETE_POST;
        } else if ([karmaType isEqualToString:KARMA_REPORT_DELETE_POST] || [karmaType isEqualToString:KARMA_REPORT_DELETE_COMMENT]) {
            karma.backColor = COLOR_4;  //red   fe4c4c
            karma.score = KARMA_SCORE_DELETE_POST;
        }
        
        [backendless.persistenceService save:karma response:^(id response) {
            NSLog(@"saved decreased karma data");
        } error:^(Fault *fault) {
            NSLog(@"Failed save in background of decreased karma data, = %@ <%@>", fault.message, fault.detail);
        }];
        
    });

}

+ (void)shareToSicial:(NSInteger)type viewCtrl:(UIViewController*)viewController image:(UIImage*)image {
    
    switch (type) {
        case 0: // FB
            
            if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] ) {
                SLComposeViewController* fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [fbSheet addImage:image];
                [fbSheet setInitialText:HAJDE_APP_LINK];
                
                [viewController presentViewController:fbSheet animated:true completion:nil];
            }
            
            break;
        case 1: // Twitter
            if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter] ) {
                SLComposeViewController* twSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                [twSheet addImage:image];
                [twSheet setInitialText:HAJDE_APP_LINK];
                
                [viewController presentViewController:twSheet animated:true completion:nil];
            }
            break;
        case 2: // Google +
            
            
            break;
        default:
            break;
    }
}

@end
