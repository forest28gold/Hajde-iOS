//
//  HDUtility.h
//  Hajde
//
//  Created by AppsCreationTech on 5/7/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDUtility : NSObject

+ (NSString*)setCommentBackColor:(NSString *)postColor;

+ (void)likePostInBackground:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray;
+ (void)dislikePostInBackground:(id)sender indexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray;

+ (void)likeCommentInBackground:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray;
+ (void)dislikeCommentInBackground:(id)sender indexPath:(NSIndexPath *)indexPath dataArray:(NSMutableArray *)dataArray;

+ (void)karmaInBackground:(NSString *)karmaType;
+ (void)karmaDecreaseInBackground:(NSString *)objectID;
+ (void)shareToSicial:(NSInteger)type viewCtrl:(UIViewController*)viewController image:(UIImage*)image;

@end
