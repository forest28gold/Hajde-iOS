//
//  Offer.h
//  Hajde
//
//  Created by AppsCreationTech on 5/14/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *shopID;
@property (strong, nonatomic) NSString *markFilePath;
@property (strong, nonatomic) NSString *productFilePath;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *offPercent;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *beforePrice;
@property (strong, nonatomic) NSString *specTitle;
@property (strong, nonatomic) NSString *specDescription;

@end
