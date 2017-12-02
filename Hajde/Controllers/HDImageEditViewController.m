//
//  HDImageEditViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/28/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDImageEditViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "SYEmojiPopover.h"
#import "SYEmojiCharacters.h"
#import "DIImageView.h"
#import "CGStretchView.h"


@interface HDImageEditViewController () <CLLocationManagerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, DKVerticalColorPickerDelegate, CGStretchViewDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *currentLocation;
    BOOL toggleEditIsOn;
    BOOL toggleEmojiIsOn;
    BOOL toggleDrawIsOn;
    BOOL toggleTextIsOn;
    CGFloat color_R;
    CGFloat color_G;
    CGFloat color_B;
    DIImageView *m_imgText;
}

@property (nonatomic,assign) CGPoint previousPoint1;
@property (nonatomic,assign) CGPoint previousPoint2;
@property (nonatomic,assign) CGPoint currentPoint;

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation HDImageEditViewController

@synthesize m_imgBack, m_imgDraw;
@synthesize m_btnText, m_btnEmoji, m_btnPaint, m_btnDelete, m_btnBack, m_viewColor;
@synthesize m_viewTools, m_viewSend, vertPicker, m_viewOverlay;
@synthesize previousPoint1, previousPoint2, currentPoint;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupLocationManager];
    [_locationManager startUpdatingLocation];
    
    m_imgBack.image = [GlobalData sharedGlobalData].g_imgPostBack;
    
    m_viewColor.layer.masksToBounds = YES;
    m_viewColor.layer.cornerRadius = m_viewColor.frame.size.height / 2;
    m_viewColor.layer.borderWidth = 2.f;
    m_viewColor.layer.borderColor = [UIColor whiteColor].CGColor;
    
    vertPicker.layer.masksToBounds = YES;
    vertPicker.layer.cornerRadius = vertPicker.frame.size.width / 2;
    vertPicker.layer.borderWidth = 2.f;
    vertPicker.layer.borderColor = [UIColor whiteColor].CGColor;
    
    vertPicker.selectedColor = [UIColor colorWithHexString:COLOR_8];
    [m_viewColor setBackgroundColor:[UIColor colorWithHexString:COLOR_8]];
    [self getRGBColor:[UIColor colorWithHexString:COLOR_8]];
    
    m_imgText = [[DIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];   
    [self.view insertSubview:m_imgText belowSubview:m_viewOverlay];
    
    [self initDrawSet];
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

- (void)setupLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        
        [_locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark Location methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        
        [GlobalData sharedGlobalData].g_userInfo.latitude = currentLocation.coordinate.latitude;
        [GlobalData sharedGlobalData].g_userInfo.longitude = currentLocation.coordinate.longitude;
        
        NSLog(@"latitude -> %f,  longitude -> %f", [GlobalData sharedGlobalData].g_userInfo.latitude, [GlobalData sharedGlobalData].g_userInfo.longitude);
        
    }
    [_locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    //    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Application failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //
    //    [errorAlert show];
}

//======================================================================================================

-(void)colorPicked:(UIColor *)color {
    
    if (toggleDrawIsOn) {
        
        m_viewColor.backgroundColor = color;
        [self getRGBColor:color];
        
    } else if (toggleTextIsOn) {
        
        [m_imgText.caption setTextColor:color];
        m_viewColor.backgroundColor = color;
        [self getRGBColor:color];
    }
}

- (void)getRGBColor:(UIColor *)color {
    
    color_R = 0.0, color_G = 0.0, color_B = 0.0;
    
    CGColorRef cg_color = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cg_color);
    color_R = components[0];
    color_G = components[1];
    color_B = components[2];
    
     NSLog(@"Selected Color ------->  R = %f   G = %f   B = %f", components[0], components[1], components[2]);
}

#pragma mark - Drawing
CGPoint midPoint(CGPoint p1, CGPoint p2) {
    
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (toggleDrawIsOn) {
        
        UITouch *touch = [touches anyObject];
        
        previousPoint1 = [touch previousLocationInView:self.view];
        previousPoint2 = [touch previousLocationInView:self.view];
        currentPoint = [touch locationInView:self.view];
        
        m_btnDelete.enabled = true;
        [m_btnDelete setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [self touchesMoved:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (toggleDrawIsOn) {
        
        UITouch *touch = [touches anyObject];
        
        previousPoint2 = previousPoint1;
        previousPoint1 = [touch previousLocationInView:self.view];
        currentPoint = [touch locationInView:self.view];
        
        // calculate mid point
        CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
        CGPoint mid2 = midPoint(currentPoint, previousPoint1);
        
        UIGraphicsBeginImageContext(self.m_imgBack.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self.m_imgDraw.image drawInRect:CGRectMake(0, 0, self.m_imgDraw.frame.size.width, self.m_imgDraw.frame.size.height)];
        
        CGContextMoveToPoint(context, mid1.x, mid1.y);
        
        // Use QuadCurve is the key
        CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
        
        CGContextSetLineCap(context, kCGLineCapRound);
        
        CGContextSetRGBStrokeColor(context, color_R, color_G, color_B, 1.0);
        
        CGContextSetLineWidth(context, 5.0);
        
        CGContextStrokePath(context);
        
        self.m_imgDraw.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
}

#pragma mark - SYEmojiPopoverDelegate methods

-(void)emojiPopover:(SYEmojiPopover*)emojiPopover didClickedOnCharacter:(NSString*)character {
    
    [self initDrawSet];
    
    CGStretchView *emojiView = [[CGStretchView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    emojiView.labelText = character;
    emojiView.labelFont = [UIFont fontWithName:@"AppleColorEmoji" size:90.f];
    emojiView.center = CGPointMake(self.m_viewEmoji.frame.size.width/2, self.m_viewEmoji.frame.size.height/2);
    emojiView.cornerButtonHidden = YES;
    emojiView.delegate = self;
    emojiView.cornerButtonOriginallyHidden = YES;
    emojiView.backgroundColor = [UIColor clearColor];
    [self.m_viewEmoji addSubview:emojiView];
}

#pragma mark - CGStretchViewDelegate methods

- (void)stretchViewTapped:(CGStretchView *)stretchView {
    
    
}

- (void)cornerButtonPressed:(UIButton *)cornerButton withStretchView:(CGStretchView *)stretchView {
    
}

- (void)popoverDismissPopover {
    
    [self initDrawSet];
}

- (void)initDrawSet {
    
    toggleEditIsOn = false;
    toggleEmojiIsOn = false;
    toggleTextIsOn = false;
    toggleDrawIsOn = false;
    
    [m_btnBack setImage:[UIImage imageNamed:@"camera_close"] forState:UIControlStateNormal];
    
    [m_btnEmoji setImage:[UIImage imageNamed:@"camera_smile"] forState:UIControlStateNormal];
    [m_btnText setImage:[UIImage imageNamed:@"camera_text"] forState:UIControlStateNormal];
    [m_btnPaint setImage:[UIImage imageNamed:@"camera_edit"] forState:UIControlStateNormal];
    m_viewColor.hidden = YES;
    m_viewSend.hidden = NO;
    vertPicker.hidden = YES;
    m_viewOverlay.hidden = YES;
    m_btnDelete.hidden = YES;
    
    m_viewTools.backgroundColor = [UIColor clearColor];
    
    _m_viewEmoji.userInteractionEnabled = YES;
    m_imgText.userInteractionEnabled = NO;
    [m_imgText.caption resignFirstResponder];
    m_imgText.caption.backgroundColor = [UIColor clearColor];
    
    if(self->_emojiPopover)
        [self->_emojiPopover removeEmojiPopover];
}

- (IBAction)onCancel:(id)sender {
    
    if (toggleEditIsOn) {
        [self initDrawSet];
    } else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
//    [self performSegueWithIdentifier:UNWIND_POST_PHOTO sender:nil];
}

- (IBAction)onInsertEmoji:(id)sender {
    
    if (toggleEmojiIsOn) {
        
        [self initDrawSet];
        
    } else {
        
        _m_viewEmoji.userInteractionEnabled = YES;
        m_imgText.userInteractionEnabled = NO;
        [m_imgText.caption resignFirstResponder];
        m_imgText.caption.backgroundColor = [UIColor clearColor];
        
        toggleEmojiIsOn = true;
        toggleTextIsOn = false;
        toggleDrawIsOn = false;
        toggleEditIsOn = true;
        [m_btnBack setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
        
        [m_btnEmoji setImage:[UIImage imageNamed:@"camera_smile"] forState:UIControlStateNormal];
        [m_btnText setImage:[UIImage imageNamed:@"camera_text_normal"] forState:UIControlStateNormal];
        [m_btnPaint setImage:[UIImage imageNamed:@"camera_edit_normal"] forState:UIControlStateNormal];
        m_viewColor.hidden = YES;
        m_viewSend.hidden = YES;
        vertPicker.hidden = YES;
        m_viewOverlay.hidden = NO;
        m_btnDelete.hidden = YES;
        [m_btnDelete setImage:[UIImage imageNamed:@"edit_delete_normal"] forState:UIControlStateNormal];
        
//        m_viewTools.backgroundColor = [UIColor colorWithRed:0./255. green:0./255. blue:0./255. alpha:0.65];
        
        if(!self->_emojiPopover)
            self->_emojiPopover = [[SYEmojiPopover alloc] init];
        
        [self->_emojiPopover setDelegate:self];
        CGPoint p = self.m_btnEmoji.center;
        p.y += self.m_btnEmoji.frame.size.height / 2.f;
        [self->_emojiPopover showFromPoint:p inView:self.view];
    }
}

- (IBAction)onInsertText:(id)sender {
    
    if (toggleTextIsOn) {
        
        [self initDrawSet];
        
    } else {
        
        if(self->_emojiPopover)
            [self->_emojiPopover removeEmojiPopover];
        
        toggleTextIsOn = true;
        toggleEmojiIsOn = false;
        toggleDrawIsOn = false;
        toggleEditIsOn = true;
        [m_btnBack setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
        
        [m_btnEmoji setImage:[UIImage imageNamed:@"camera_smile_normal"] forState:UIControlStateNormal];
        [m_btnText setImage:[UIImage imageNamed:@"camera_text"] forState:UIControlStateNormal];
        [m_btnPaint setImage:[UIImage imageNamed:@"camera_edit_normal"] forState:UIControlStateNormal];
        m_viewColor.hidden = YES;
        m_viewSend.hidden = YES;
        vertPicker.hidden = NO;
        m_viewOverlay.hidden = YES;
        m_btnDelete.hidden = YES;
        [m_btnDelete setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        
        m_viewTools.backgroundColor = [UIColor clearColor];
        
        _m_viewEmoji.userInteractionEnabled = NO;
        m_imgText.userInteractionEnabled = YES;
        [m_imgText imageViewTapped];
        
        if ([m_imgText.caption.text isEqualToString:@""]) {
            m_imgText.caption.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        } else {
            m_imgText.caption.backgroundColor = [UIColor clearColor];
        }
        
    }
    
}

- (IBAction)onInsertDraw:(id)sender {
    
    if (toggleDrawIsOn) {
        
        [self initDrawSet];
        
    } else {
        
        _m_viewEmoji.userInteractionEnabled = NO;
        m_imgText.userInteractionEnabled = NO;
        [m_imgText.caption resignFirstResponder];
        m_imgText.caption.backgroundColor = [UIColor clearColor];
        
        if(self->_emojiPopover)
            [self->_emojiPopover removeEmojiPopover];
        
        toggleDrawIsOn = true;
        toggleEmojiIsOn = false;
        toggleTextIsOn = false;
        toggleEditIsOn = true;
        [m_btnBack setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
        
        [m_btnEmoji setImage:[UIImage imageNamed:@"camera_smile_normal"] forState:UIControlStateNormal];
        [m_btnText setImage:[UIImage imageNamed:@"camera_text_normal"] forState:UIControlStateNormal];
        [m_btnPaint setImage:[UIImage imageNamed:@"edit_color"] forState:UIControlStateNormal];
        m_viewColor.hidden = NO;
        m_viewSend.hidden = YES;
        vertPicker.hidden = NO;
        m_viewOverlay.hidden = YES;
        m_btnDelete.hidden = NO;
        
        m_viewTools.backgroundColor = [UIColor clearColor];
        
        if (m_imgDraw.image == nil) {
            m_btnDelete.enabled = false;
            [m_btnDelete setImage:[UIImage imageNamed:@"edit_delete_normal"] forState:UIControlStateNormal];
        } else {
            m_btnDelete.enabled = true;
            [m_btnDelete setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        }

    }
    
    //    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:m_imgBack.image delegate:self];
    //    [self presentViewController:editor animated:YES completion:nil];
}

- (IBAction)onDrawDelete:(id)sender {
    
    if (toggleDrawIsOn) {
        
        m_btnDelete.enabled = false;
        m_imgDraw.image = nil;
        [m_btnDelete setImage:[UIImage imageNamed:@"edit_delete_normal"] forState:UIControlStateNormal];
        
    } else if (toggleTextIsOn) {
        
        m_imgText.caption.text = @"";
        [m_btnDelete setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        
    }
}

//======================================================================================================

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 2016;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (IBAction)onSave:(id)sender {
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    
    [m_imgBack.layer renderInContext:UIGraphicsGetCurrentContext()];
    [m_imgDraw.layer renderInContext:UIGraphicsGetCurrentContext()];
    [_m_viewEmoji.layer renderInContext:UIGraphicsGetCurrentContext()];
    [m_imgText.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(viewImage){
        NSArray *excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage];
        
        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[viewImage] applicationActivities:nil];
        
        activityView.excludedActivityTypes = excludedActivityTypes;
        activityView.completionHandler = ^(NSString *activityType, BOOL completed){
            if(completed && [activityType isEqualToString:UIActivityTypeSaveToCameraRoll]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"saved_successfully", "") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", "") otherButtonTitles:nil];
                [alert show];
            }
        };
        
        [self presentViewController:activityView animated:YES completion:nil];
    }
}

- (IBAction)onSend:(id)sender {

    SVPROGRESSHUD_SHOW;
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    
    [m_imgBack.layer renderInContext:UIGraphicsGetCurrentContext()];
    [m_imgDraw.layer renderInContext:UIGraphicsGetCurrentContext()];
    [_m_viewEmoji.layer renderInContext:UIGraphicsGetCurrentContext()];
    [m_imgText.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    float imgPostWidth = viewImage.size.width;
    float imgPostHeight = viewImage.size.height;
    float scaleHeight = imgPostWidth / 320;
    
    if (scaleHeight > 5) {
        viewImage = [self scaleAndRotateImage:viewImage];
        
        imgPostWidth = viewImage.size.width;
        imgPostHeight = viewImage.size.height;
        scaleHeight = imgPostWidth / 320;
    }
    
    imgPostHeight = imgPostHeight / scaleHeight;
    
    int randomID = arc4random() % 900000000 + 100000000;
    NSString *prefixName = [NSString stringWithFormat:@"%i", randomID];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/%@_%0.0f.jpeg", BACKEND_URL_IMAGE, prefixName, [[NSDate date] timeIntervalSince1970]];
    NSData *fileData = UIImageJPEGRepresentation(viewImage, 1.0);
    
    [backendless.fileService saveFile:fileName content:fileData response:^(BackendlessFile *uploadFile) {
        
        NSLog(@"image file -> %@", uploadFile.fileURL);
        
        Post *post = [Post new];
        post.type = POST_TYPE_PHOTO;
        post.filePath = uploadFile.fileURL;
        post.userID = [GlobalData sharedGlobalData].g_userInfo.userID;
        post.latitude = [NSString stringWithFormat: @"%f", [GlobalData sharedGlobalData].g_userInfo.latitude];
        post.longitude = [NSString stringWithFormat: @"%f", [GlobalData sharedGlobalData].g_userInfo.longitude];
        post.time = [[GlobalData sharedGlobalData] getCurrentDate];
        post.commentCount = 0;
        post.likeCount = 0;
        post.reportCount = 0;
        post.imgHeight = imgPostHeight;
        post.reportType = @"";
        post.likeType = @"";
        post.commentType = @"";
        
        [backendless.persistenceService save:post response:^(id response) {
            
            NSLog(@"saved new image post data");
            
            SVPROGRESSHUD_DISMISS;
            
            [GlobalData sharedGlobalData].g_userInfo.karmaScore += KARMA_SCORE_POST;
            [GlobalData sharedGlobalData].g_userInfo.postCount ++;
            [[GlobalData sharedGlobalData] updateUserDataDB];
            
            [HDUtility karmaInBackground:KARMA_POST];
            
            [self performSegueWithIdentifier:UNWIND_POST_PHOTO sender:nil];
            
        } error:^(Fault *fault) {
            
            NSLog(@"Failed save in background of post data, = %@ <%@>", fault.message, fault.detail);
            
            SVPROGRESSHUD_DISMISS;
            [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_new_posting_failed", "")];
            
        }];
        
    } error:^(Fault *fault) {
        
        NSLog(@"Failed save in background of photo data, = %@ <%@>", fault.message, fault.detail);
        
        SVPROGRESSHUD_DISMISS;
        [[GlobalData sharedGlobalData] onErrorAlert:NSLocalizedString(@"alert_new_posting_failed", "")];
        
    }];
    
}

@end
