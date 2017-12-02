//
//  STUReviewTableViewCell.m
//  StyleUp
//
//  Created by AppsCreationTech on 2/5/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//


#import "HDPrivacyTableViewCell.h"

@interface HDPrivacyTableViewCell ()

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelContent;
@property (nonatomic, strong) UIView *viewSeperate;

@end

@implementation HDPrivacyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Fix for contentView constraint warning
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    self.labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    self.labelTitle.textColor = [UIColor darkGrayColor];
    self.labelTitle.numberOfLines = 0;
    self.labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.labelTitle];
    
    self.labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
    self.labelContent.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelContent.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.labelContent.textColor = [UIColor grayColor];
    self.labelContent.numberOfLines = 0;
    self.labelContent.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.labelContent];
    
    self.viewSeperate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
    self.viewSeperate.backgroundColor = [UIColor colorWithHexString:@"#d8d9db"];
    self.viewSeperate.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewSeperate.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.viewSeperate];
    
    // Constrain
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_labelTitle, _labelContent, _viewSeperate);
    // Create a dictionary with buffer values
    NSDictionary *metricDict = @{@"sideBuffer" : @12, @"verticalBuffer" : @10, @"verticalTitleBuffer" : @5, @"seperateHeight" : @2};
    
    
    // Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_labelTitle]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_labelContent]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewSeperate]|" options:0 metrics:metricDict views:viewDict]];
    
    // Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelTitle]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelTitle]-[_labelContent]-verticalBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelTitle]-[_labelContent]-verticalBuffer-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    [self.labelTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.labelTitle setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.labelContent setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.labelContent setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    self.labelContent.preferredMaxLayoutWidth = defaultSize.width - ([metricDict[@"sideRateBuffer"] floatValue] * 2);
}

- (void)setupCellWithData:(TermsOfUse *)data {

    // Set values
    
    NSString *myNewLineStr = @"\n";
    
    if ([data.content isEqualToString:@""] || data.content == nil) {
        
        self.labelTitle.text = [data.title stringByReplacingOccurrencesOfString:@"\\n" withString:myNewLineStr];
        self.labelTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
        self.labelContent.hidden = YES;
        self.viewSeperate.hidden = YES;
        self.labelContent.text = @"";
        
    } else {
        
        self.labelTitle.text = [data.title stringByReplacingOccurrencesOfString:@"\\n" withString:myNewLineStr];
        self.labelContent.text = [data.content stringByReplacingOccurrencesOfString:@"\\n" withString:myNewLineStr];
        self.labelTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        
        self.labelContent.hidden = NO;
        self.viewSeperate.hidden = NO;
    }
    
}


@end

