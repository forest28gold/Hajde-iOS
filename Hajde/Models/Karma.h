//
//  Karma.h
//  Hajde
//
//  Created by AppsCreationTech on 5/8/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Karma : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *time;
@property (nonatomic, assign) int score;
@property (strong, nonatomic) NSString *backColor;

@end
