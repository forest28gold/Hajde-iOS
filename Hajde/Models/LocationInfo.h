//
//  LocationInfo.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfo : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* address;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* contact;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

@end
