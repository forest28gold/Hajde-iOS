//
//  HDOfferDetailsViewController.h
//  Hajde
//
//  Created by AppsCreationTech on 3/28/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDOfferDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *m_btnBack;

@property (strong, nonatomic) IBOutlet UIImageView *m_imgProduct;
@property (strong, nonatomic) IBOutlet UIImageView *m_imgMark;
@property (strong, nonatomic) IBOutlet UILabel *m_lblName;
@property (strong, nonatomic) IBOutlet UILabel *m_lblIndex;
@property (strong, nonatomic) IBOutlet UILabel *m_lblOffPercent;
@property (strong, nonatomic) IBOutlet UILabel *m_lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *m_lblBeforePrice;
@property (strong, nonatomic) IBOutlet UILabel *m_lblOfferName;
@property (strong, nonatomic) IBOutlet UILabel *m_lblOfferSpec;
@property (strong, nonatomic) IBOutlet UITextView *m_txtSpecDescription;


@end
