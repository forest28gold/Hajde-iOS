//
//  HDNewImageViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
#import "UIView+Utils.h"
#import "UIButton+Utils.h"
#import "LeafButton.h"

@class HDNewImageViewController;
@protocol HDNewImageViewControllerDelegate <NSObject>

- (void)imagePickerController:(HDNewImageViewController *)picker didFinishPickingImage:(UIImage *)image;

@end

@interface HDNewImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController             *m_popoverController;
    UIImagePickerController         *m_pickerController;
}

@property (strong, nonatomic) UIButton *dismissBtn;
@property (strong, nonatomic) LeafButton *captureBtn;
@property (strong, nonatomic) UIImageView *libraryImage;

@property (weak,   nonatomic) id<HDNewImageViewControllerDelegate> delegate;

@end
