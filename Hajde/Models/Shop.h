//
//  Shop.h
//  Hajde
//
//  Created by AppsCreationTech on 5/14/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *shopDescription;
@property (strong, nonatomic) NSString *shopTitle;
@property (strong, nonatomic) NSString *submarkFilePath;
@property (strong, nonatomic) NSString *markFilePath;
@property (strong, nonatomic) NSString *country;

@end
