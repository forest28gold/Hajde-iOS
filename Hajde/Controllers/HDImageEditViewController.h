//
//  HDImageEditViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/28/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKVerticalColorPicker.h"
#import "SYEmojiPopover.h"

@interface HDImageEditViewController : UIViewController <SYEmojiPopoverDelegate, UIGestureRecognizerDelegate>
{
@private SYEmojiPopover *_emojiPopover;
}

@property (strong, nonatomic) IBOutlet UIImageView *m_imgBack;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgDraw;

@property (strong, nonatomic) IBOutlet UIButton *m_btnBack;
@property (strong, nonatomic) IBOutlet UIButton *m_btnEmoji;
@property (strong, nonatomic) IBOutlet UIButton *m_btnText;
@property (strong, nonatomic) IBOutlet UIView *m_viewColor;
@property (strong, nonatomic) IBOutlet UIButton *m_btnPaint;
@property (strong, nonatomic) IBOutlet UIButton *m_btnDelete;
@property (strong, nonatomic) IBOutlet UIView *m_viewTools;
@property (strong, nonatomic) IBOutlet UIView *m_viewSend;
@property (strong, nonatomic) IBOutlet UIView *m_viewOverlay;
@property (strong, nonatomic) IBOutlet UIView *m_viewEmoji;
@property (nonatomic, weak) IBOutlet DKVerticalColorPicker *vertPicker;

-(void)colorPicked:(UIColor *)color;

@end
