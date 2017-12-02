//
//  DIImageView.m
//  DIImageView
//
//  Created by Daniel Inoa Llenas on 8/18/14.
//  Copyright (c) 2014 Daniel Inoa Llenas. All rights reserved.
//

#import "DIImageView.h"

@implementation DIImageView

@synthesize caption;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initCaption];

        // Tap Gesture for ImageView
        UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
        imageViewTap.delegate = self;
        [self addGestureRecognizer:imageViewTap];
        [self setUserInteractionEnabled:YES];
        
        // Drag Gesture for Caption
        UIPanGestureRecognizer *drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(captionDrag:)];
        [self setDefaultGestureProperties:drag];
        drag.enabled = YES;
        [self addGestureRecognizer:drag];
        
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(captionRotate:)];
        rotation.delegate = self;
        rotation.enabled = YES;
        [self addGestureRecognizer:rotation];
        
        UIPinchGestureRecognizer *zoom = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(captionZoom:)];
        zoom.delegate = self;
        zoom.enabled = YES;
        [self addGestureRecognizer:zoom];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    // Caption
    [self initCaption];
}

- (void)initCaption{
    
    // Caption
    caption = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                            [UIScreen mainScreen].applicationFrame.size.height/2 - 50,
                                                            [UIScreen mainScreen].applicationFrame.size.width,
                                                            50)];
    caption.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    caption.textAlignment = NSTextAlignmentCenter;
    caption.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    caption.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    caption.textColor = [UIColor whiteColor];
    [caption setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30.f]];
    caption.alpha = 0;
    caption.tintColor = [UIColor whiteColor];
    caption.delegate = self;
    [self addSubview:caption];
}

- (void) imageViewTapped{
    
    caption.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    caption.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    if([caption isFirstResponder]){
        [caption resignFirstResponder];
        caption.alpha = ([caption.text isEqualToString:@""]) ? 0 : caption.alpha;
        caption.backgroundColor = [UIColor clearColor];
    } else {
        [caption becomeFirstResponder];
        caption.alpha = 1;
        
        if ([caption.text isEqualToString:@""]) {
            
            caption.transform=CGAffineTransformMakeRotation(0);
            
            caption.frame = CGRectMake(0,
                                       [UIScreen mainScreen].applicationFrame.size.height/2 - 50,
                                       [UIScreen mainScreen].applicationFrame.size.width,
                                       50);
            [caption setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30.f]];
            caption.textColor = [UIColor whiteColor];
            caption.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            caption.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            caption.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        }
    }
}

- (void)setDefaultGestureProperties:(UIPanGestureRecognizer*)recognizer {
    recognizer.minimumNumberOfTouches = 1;
    recognizer.delaysTouchesBegan = NO;
    recognizer.delegate = self;
}

- (void)captionDrag: (UIPanGestureRecognizer*)panGesture{
    
    caption.backgroundColor = [UIColor clearColor];
    
    CGPoint panLocation = [panGesture locationInView:self.superview];
    caption.center = panLocation;
    
}

- (void)captionRotate: (UIRotationGestureRecognizer*)rotationGesture{
    
    caption.backgroundColor = [UIColor clearColor];
    
    CGFloat rotation = [rotationGesture rotation];
    [caption setTransform:CGAffineTransformRotate(caption.transform, rotation)];
    [rotationGesture setRotation:0];
    
}

- (void)captionZoom: (UIPinchGestureRecognizer*)pinchGesture{
    
    caption.backgroundColor = [UIColor clearColor];
    
    CGFloat scale = [pinchGesture scale];
    [caption setTransform:CGAffineTransformScale(caption.transform, scale, scale)];
    [pinchGesture setScale:1.0];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    CGSize textSize = [text sizeWithAttributes: @{NSFontAttributeName:textField.font}];
    return (textSize.width + 10 < textField.bounds.size.width) ? true : false;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [caption resignFirstResponder];
    caption.backgroundColor = [UIColor clearColor];
    return true;
}

@end
