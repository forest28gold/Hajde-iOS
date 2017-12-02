//
//  STUReviewTableViewCell.m
//  StyleUp
//
//  Created by AppsCreationTech on 2/5/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//


#import "HDPostTableViewCell.h"

@interface HDPostTableViewCell ()

@end

@implementation HDPostTableViewCell

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
    
    self.backOverlayImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.backOverlayImage];
    
    self.labelPost = [[UILabel alloc] initWithFrame:CGRectZero];
    self.labelPost.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelPost.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
    self.labelPost.textColor = [UIColor whiteColor];
    self.labelPost.numberOfLines = 0;
    self.labelPost.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.labelPost];
    
    self.labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
    self.labelTime.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelTime.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    self.labelTime.textColor = [UIColor whiteColor];
    self.labelTime.numberOfLines = 0;
    self.labelTime.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelTime.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.labelTime];
    
    self.labelLocation = [[UILabel alloc] initWithFrame:CGRectZero];
    self.labelLocation.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelLocation.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    self.labelLocation.textColor = [UIColor whiteColor];
    self.labelLocation.numberOfLines = 0;
    self.labelLocation.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.labelLocation];
    
    self.labelComments = [[UILabel alloc] initWithFrame:CGRectZero];
    self.labelComments.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelComments.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    self.labelComments.textColor = [UIColor whiteColor];
    self.labelComments.numberOfLines = 0;
    self.labelComments.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelComments.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.labelComments];
    
    self.labelLikes = [[UILabel alloc] initWithFrame:CGRectZero];
    self.labelLikes.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelLikes.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    self.labelLikes.textColor = [UIColor whiteColor];
    self.labelLikes.numberOfLines = 0;
    self.labelLikes.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelLikes.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.labelLikes];
    
    
    self.imgLocation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 23)];
    self.imgLocation.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgLocation.contentMode = UIViewContentModeScaleAspectFill;
    self.imgLocation.image = [UIImage imageNamed:@"location"];
    [self.contentView addSubview:self.imgLocation];
    
    self.btnComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    self.btnComment.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnComment.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnComment setImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnComment];
    
    self.btnLike = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    self.btnLike.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnLike.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnLike setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnLike];
    
    self.btnDislike = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    self.btnDislike.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnDislike.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnDislike setImage:[UIImage imageNamed:@"dislike_normal"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnDislike];
    
    self.btnReport = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 23)];
    self.btnReport.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnReport.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnReport setImage:[UIImage imageNamed:@"report"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnReport];
    
    self.viewSeperate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
    self.viewSeperate.backgroundColor = [UIColor whiteColor];
    self.viewSeperate.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewSeperate.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.viewSeperate];
    
    self.backImage = [[UIImageView alloc] initWithFrame:CGRectZero];
//    self.backImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.backImage.contentMode = UIViewContentModeScaleAspectFill;
    self.backImage.backgroundColor = [UIColor colorWithHexString:@"#686767"];
    [self.contentView addSubview:self.backImage];

    
    // Constrain
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_labelPost, _labelTime, _labelLocation, _labelComments, _labelLikes, _imgLocation, _btnComment, _btnLike, _btnDislike, _viewSeperate, _btnReport);
    // Create a dictionary with buffer values
    NSDictionary *metricDict = @{@"sideBuffer" : @20, @"sidePostBuffer" : @48, @"sideCommentLabelBuffer" : @1, @"sideTimeBuffer" : @10, @"sideLocationBuffer" : @3, @"sideCommentBuffer" : @160, @"sideReportBuffer" : @82, @"sideLikeBuffer" : @240, @"sideLabelLikeBuffer" : @230, @"sideDislikeBuffer" : @285, @"verticalBuffer" : @10, @"verticalTimeBuffer" : @11.5, @"verticalInternalBuffer" : @20, @"verticalBottomBuffer" : @7, @"imageSize" : @14, @"buttonSize" : @23, @"buttonReportSize" : @32, @"footerHeight" : @23, @"seperateHeight" : @2};
        
    // Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_labelPost]-sidePostBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_labelPost]-[_labelTime]-sideTimeBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_imgLocation(imageSize)]-sideLocationBuffer-[_labelLocation]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideReportBuffer-[_btnReport(buttonReportSize)]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideCommentBuffer-[_btnComment(buttonSize)]-sideCommentLabelBuffer-[_labelComments]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideLikeBuffer-[_btnLike(buttonSize)]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideLabelLikeBuffer-[_labelLikes]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideDislikeBuffer-[_btnDislike(buttonSize)]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewSeperate]|" options:0 metrics:metricDict views:viewDict]];
    
    // Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalTimeBuffer-[_labelTime]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_imgLocation(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_labelLocation(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_btnReport(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_btnComment(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_labelComments(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_btnLike(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_labelLikes(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_btnDislike(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_labelLocation(footerHeight)]-verticalInternalBuffer-[_viewSeperate(seperateHeight)]|" options:0 metrics:metricDict views:viewDict]];
    
    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.reviewLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.reviewLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    
    [self.labelPost setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.labelPost setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.labelTime setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.labelTime setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.labelLocation setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.labelLocation setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.labelComments setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.labelComments setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.labelLikes setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.labelLikes setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.imgLocation setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.imgLocation setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnComment setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnComment setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnLike setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnLike setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnDislike setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnDislike setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.viewSeperate setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.btnReport setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.btnReport setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    self.labelPost.preferredMaxLayoutWidth = defaultSize.width - ([metricDict[@"sideRateBuffer"] floatValue] * 2);
}

- (void)setupCellWithData:(PostData *)postData {
    
    // Pull out sample data
    NSString *postType = postData.type;
    NSString *postString = postData.content;
    NSString *colorString = postData.backColor;
    NSString *filePath = postData.filePath;
    NSString *time = postData.time;
    int commentCount = postData.commentCount;
    int likeCount = postData.likeCount;
    double latitude = [postData.latitude doubleValue];
    double longitude = [postData.longitude doubleValue];
    
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[GlobalData sharedGlobalData].g_userInfo.latitude longitude:[GlobalData sharedGlobalData].g_userInfo.longitude];
//    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:50.4481127 longitude:30.4290111];

    
    if ([postType isEqualToString:POST_TYPE_TEXT]) {
     
        self.backgroundColor = [UIColor colorWithHexString:colorString];
        
        postString = [postString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *postValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        
        self.labelTime.text = [[GlobalData sharedGlobalData] getFormattedTimeStamp:time];
        self.labelLocation.text = [[GlobalData sharedGlobalData] getFormattedDistance:loc1 toLocation:loc2];
        self.labelComments.text = [[GlobalData sharedGlobalData] getFormattedCount:commentCount];
        self.labelLikes.text = [[GlobalData sharedGlobalData] getFormattedCount:likeCount];
        self.backImage.hidden = YES;
        self.backOverlayImage.hidden = YES;
        
        NSString *empty = @"\n\n\n";
        
        if (postValue.length < 80 && [postString rangeOfString:@"\n"].location == NSNotFound) {
            self.labelPost.text = [NSString stringWithFormat:@"%@ %@", postValue, empty];
        } else {
            self.labelPost.text = [NSString stringWithFormat:@"%@ \n", postValue];
        }
        
    } else if ([postType isEqualToString:POST_TYPE_PHOTO]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"43b9f6"];
        
        NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *postValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        
        self.labelTime.text = [[GlobalData sharedGlobalData] getFormattedTimeStamp:time];
        self.labelLocation.text = [[GlobalData sharedGlobalData] getFormattedDistance:loc1 toLocation:loc2];
        self.labelComments.text = [[GlobalData sharedGlobalData] getFormattedCount:commentCount];
        self.labelLikes.text = [[GlobalData sharedGlobalData] getFormattedCount:likeCount];
        self.backImage.hidden = NO;
        self.backOverlayImage.hidden = NO;
        self.backOverlayImage.image = [UIImage imageNamed:@"post_overlay_image"];
        self.backOverlayImage.frame = self.contentView.frame;
        
        NSString *empty = @"\n\n\n";
        
        if (postValue.length < 80) {
            self.labelPost.text = [NSString stringWithFormat:@"%@ %@", postValue, empty];
        } else {
            self.labelPost.text = [NSString stringWithFormat:@"%@ \n\n", postValue];
        }
        
        NSURL *imageURL = [NSURL URLWithString:filePath];
        [self.backImage setShowActivityIndicatorView:YES];
        [self.backImage setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.backImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"post_image.png"]];
        
        self.backImage.frame = self.contentView.frame;
        [self.contentView sendSubviewToBack:self.backImage];
    }
    
    if ([postData.commentTypeArray containsObject:[GlobalData sharedGlobalData].g_userInfo.userID]) {
        [self.btnComment setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    } else {
        [self.btnComment setImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal];
    }
    
    if ([postData.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, LIKE_TYPE]]) {
        [self.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [self.btnDislike setImage:[UIImage imageNamed:@"dislike_normal"] forState:UIControlStateNormal];
    } else if ([postData.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, DISLIKE_TYPE]]) {
        [self.btnLike setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        [self.btnDislike setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    } else {
        [self.btnLike setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        [self.btnDislike setImage:[UIImage imageNamed:@"dislike_normal"] forState:UIControlStateNormal];
    }
    
}


@end

