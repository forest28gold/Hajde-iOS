//
//  GlobalData.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData

static GlobalData *_globalData = nil;

+ (GlobalData *) sharedGlobalData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_globalData == nil) {
            _globalData = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _globalData;
}

- (id) init
{
    self = [super init];
    
    if (self) {
        [self setG_appDelegate:[[UIApplication sharedApplication] delegate]];       
    }
    
    return self;
}

#pragma mark - checking validate email

- (BOOL) checkingVaildateEmailWithString:(NSString *)strEmail
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,8}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:strEmail];
}

# pragma mark - Trim string

- (NSString *) trimString:(NSString *) string
{   
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - converting date

- (NSDate *)dateFromString:(NSString *)strDate DateFormat:(NSString *)strDateFormat TimeZone:(NSTimeZone *) timeZone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (strDateFormat == nil || [@"" isEqualToString:strDateFormat]) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:strDateFormat];
    }
    
    if (timeZone != nil) {
        
        dateFormatter.timeZone = timeZone;
    }
    
    return [dateFormatter dateFromString:strDate];
}

#pragma mark - saving to user defaults

- (void) saveToUserDefaultsWithValue:(id)value
                                 Key:(NSString *)strKey
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:strKey];
        [standardUserDefaults synchronize];
    }
}

- (id) userDefaultWithKey:(NSString *)strKey
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        return [standardUserDefaults objectForKey:strKey];
    }
    
    return nil;
}

- (void) removeValueFromUserDefaults:(NSString *)strKey
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults removeObjectForKey:strKey];
        [standardUserDefaults synchronize];
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)colorWithHexString:(NSString *)colorString
{
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if (colorString.length == 3)
        colorString = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                       [colorString characterAtIndex:0], [colorString characterAtIndex:0],
                       [colorString characterAtIndex:1], [colorString characterAtIndex:1],
                       [colorString characterAtIndex:2], [colorString characterAtIndex:2]];
    
    if (colorString.length == 6)
    {
        int r, g, b;
        sscanf([colorString UTF8String], "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
    }
    return nil;
}

- (NSString*)getCurrentDate {
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentyearString = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    
    // Get Current  Month
    [formatter setDateFormat:@"MM"];
    NSString *currentMonthString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Date
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Hour
    [formatter setDateFormat:@"HH"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Min
    [formatter setDateFormat:@"mm"];
    NSString *currentMinString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Second
    [formatter setDateFormat:@"ss"];
    NSString *currentSecondString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    return [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@", currentMonthString, currentDateString, currentyearString, currentHourString, currentMinString, currentSecondString];
}

- (NSString*)getFormattedCount:(int)count {
    
    NSString *strCount = @"0";
    
    if (count == 0) {
        strCount = @"0";
    } else if (count < 1000) {
        strCount = [NSString stringWithFormat:@"%i", count];
    } else if (count >= 1000 && count < 1000000) {
        float count_dec = count / 1000;
        strCount = [NSString stringWithFormat:@"%0.0fK", count_dec];
    } else {
        float count_dec = count / 1000000;
        strCount = [NSString stringWithFormat:@"%0.0fM", count_dec];
    }
    
    return strCount;
}

- (NSString*)getFormattedTimeStamp:(NSString*)time {

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDate* firstDate = [dateFormatter dateFromString:[self getCurrentDate]];
    NSDate* secondDate = [dateFormatter dateFromString:time];
    
    NSTimeInterval timeDifference = -(int)[secondDate timeIntervalSinceDate:firstDate];
    
    return [NSDate mysqlDatetimeFormattedAsTimeAgo:time interval:timeDifference];
}

- (BOOL)getDailyLoginIsOn:(NSString*)currentLoginTime createdTime:(NSString*)createdTime {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDate* firstDate = [dateFormatter dateFromString:currentLoginTime];
    NSDate* secondDate = [dateFormatter dateFromString:createdTime];
    
    NSTimeInterval timeDifference = -(int)[secondDate timeIntervalSinceDate:firstDate];
    
    int daySince = (int)timeDifference / (3600 * 24);
    
    NSLog(@"Daily Login Count = %d,   Last Login Count = %d", daySince, [GlobalData sharedGlobalData].g_userInfo.dailyLoginCount);
    
    if (daySince > [GlobalData sharedGlobalData].g_userInfo.dailyLoginCount) {
        
        [GlobalData sharedGlobalData].g_userInfo.dailyLoginCount = daySince;
        NSLog(@"******************** Daily Login is OK ****************************");
        return YES;
    } else {
        NSLog(@"===================== Daily Login is Bad ==========================");
        return NO;
    }
    
}

- (void)getSpentTimeStamp:(int)spentTime {
    
    NSTimeInterval elapsedTime = spentTime;
    
    div_t d = div(elapsedTime, 3600 * 24);
    self.g_spentDays = d.quot;
    
    // Divide the interval by 3600 and keep the quotient and remainder
    div_t h = div(d.rem, 3600);
    self.g_spentHours = h.quot;
    // Divide the remainder by 60; the quotient is minutes, the remainder
    // is seconds.
    div_t m = div(h.rem, 60);
    self.g_spentMins = m.quot;
    int seconds = m.rem;
    
    // If you want to get the individual digits of the units, use div again
    // with a divisor of 10.
    
//    NSLog(@"%d:%d:%d:%d", self.g_spentDays, self.g_spentHours, self.g_spentMins, seconds);

}

- (NSString*)getFormattedDistance:(CLLocation*)fromLocation toLocation:(CLLocation*)toLocation {
    
    NSString *strDistance = @"";
    
    // calculate distance between them
    CLLocationDistance distance = [fromLocation distanceFromLocation:toLocation]; // CLLocationDistance is in Meter
//    NSLog(@"Distance between two locations in Meter = %f \n Mile = %f \n KiloMeter = %f", distance, distance * 0.000621371192, distance /1000);
    // 1 Meter = 0.000621371192 Miles
    // 1 Mile = 1609.344 Meters
    
    if (distance < 1000) {
        strDistance = [NSString stringWithFormat:@"%0.0fm", distance];
    } else {
        strDistance = [NSString stringWithFormat:@"%0.0fkm", distance/1000];
    }
    
    return strDistance;
}

- (int)getDistance:(CLLocation*)fromLocation toLocation:(CLLocation*)toLocation {
    
    // calculate distance between them
    CLLocationDistance distance = [fromLocation distanceFromLocation:toLocation]; // CLLocationDistance is in Meter
    //    NSLog(@"Distance between two locations in Meter = %f \n Mile = %f \n KiloMeter = %f", distance, distance * 0.000621371192, distance /1000);
    // 1 Meter = 0.000621371192 Miles
    // 1 Mile = 1609.344 Meters
    
    CLLocationDistance kilometers = distance / 1000.0;
    
    int num = kilometers;
    
    return num;
}

- (void)onErrorAlert:(NSString*)errorString {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", "")
                                                    message:errorString
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", "")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)updateUserDataDB {
    
    [GlobalData sharedGlobalData].g_userDataModel = [[UserData alloc] init];
    [GlobalData sharedGlobalData].g_userDataModel = [GlobalData sharedGlobalData].g_userInfo;
    
    [[GlobalData sharedGlobalData].g_dataModel updateUserDB];
    
}

@end
