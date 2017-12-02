//
//  STUReviewTableViewCell.m
//  StyleUp
//
//  Created by AppsCreationTech on 2/5/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//


#import "HDCommentTableViewCell.h"

@interface HDCommentTableViewCell ()

@end

@implementation HDCommentTableViewCell

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
    
    self.btnReport = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 23)];
    self.btnReport.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnReport.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnReport setImage:[UIImage imageNamed:@"report"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnReport];
    
    self.imgMyComment = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 23)];
    self.imgMyComment.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgMyComment.contentMode = UIViewContentModeScaleAspectFill;
    self.imgMyComment.image = [UIImage imageNamed:@"mycomment"];
    [self.contentView addSubview:self.imgMyComment];
    
    self.labelMyComment = [[UILabel alloc] initWithFrame:CGRectZero];
    self.labelMyComment.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelMyComment.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    self.labelMyComment.textColor = [UIColor whiteColor];
    self.labelMyComment.text = @"My comment";
    self.labelMyComment.numberOfLines = 0;
    self.labelMyComment.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelMyComment.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.labelMyComment];
    
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
    
    self.viewSeperate = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    self.viewSeperate.backgroundColor = [UIColor whiteColor];
    self.viewSeperate.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewSeperate.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.viewSeperate];
    
    // Constrain
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_labelPost, _labelTime, _labelLocation, _labelLikes, _imgLocation, _imgMyComment, _labelMyComment, _btnLike, _btnDislike, _viewSeperate, _btnReport);
    // Create a dictionary with buffer values
    NSDictionary *metricDict = @{@"sideBuffer" : @20, @"sidePostBuffer" : @48, @"sideCommentLabelBuffer" : @1, @"sideTimeBuffer" : @10, @"sideLocationBuffer" : @3, @"sideCommentBuffer" : @130, @"sideReportBuffer" : @82, @"sideLikeBuffer" : @240, @"sideLabelLikeBuffer" : @230, @"sideDislikeBuffer" : @285, @"verticalBuffer" : @10, @"verticalTimeBuffer" : @11.5, @"verticalInternalBuffer" : @20, @"verticalBottomBuffer" : @7, @"imageSize" : @14, @"imageCommentSize" : @10, @"buttonSize" : @23, @"buttonReportSize" : @32, @"footerHeight" : @23, @"seperateHeight" : @1};
        
    // Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_labelPost]-sidePostBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_labelPost]-sideTimeBuffer-[_labelTime]-sideTimeBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_imgLocation(imageSize)]-sideLocationBuffer-[_labelLocation]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideReportBuffer-[_btnReport(buttonReportSize)]|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideCommentBuffer-[_imgMyComment(imageCommentSize)]-seperateHeight-[_labelMyComment]|" options:0 metrics:metricDict views:viewDict]];
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
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_imgMyComment(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_labelPost]-[_labelMyComment(footerHeight)]-verticalBottomBuffer-|" options:0 metrics:metricDict views:viewDict]];
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
    [self.labelLikes setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.labelLikes setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.imgLocation setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.imgLocation setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.imgMyComment setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.imgMyComment setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.labelMyComment setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.labelMyComment setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
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

- (void)setupCellWithData:(ActivityPostData *)commentData {
    
    // Pull out sample data
    NSString *commentString = commentData.comment;
    NSString *time = commentData.time;
    NSString *colorString = commentData.backColor;
    int likeCount = commentData.likeCount;
    double latitude = [commentData.latitude doubleValue];
    double longitude = [commentData.longitude doubleValue];
    
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:[GlobalData sharedGlobalData].g_userInfo.latitude longitude:[GlobalData sharedGlobalData].g_userInfo.longitude];
//    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:50.4481127 longitude:30.4290111];

    self.backgroundColor = [UIColor colorWithHexString:colorString];
    
    commentString = [commentString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    NSData *data = [commentString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *commentValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    
    self.labelTime.text = [[GlobalData sharedGlobalData] getFormattedTimeStamp:time];
    self.labelLocation.text = [[GlobalData sharedGlobalData] getFormattedDistance:loc1 toLocation:loc2];
    self.labelLikes.text = [[GlobalData sharedGlobalData] getFormattedCount:likeCount];
    
    NSString *empty = @"\n\n\n";
        
    if (commentValue.length < 80 && [commentString rangeOfString:@"\n"].location == NSNotFound) {
        self.labelPost.text = [NSString stringWithFormat:@"%@ %@", commentValue, empty];
    } else {
        self.labelPost.text = [NSString stringWithFormat:@"%@ \n", commentValue];
    }
    
    if ([commentData.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, LIKE_TYPE]]) {
        [self.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [self.btnDislike setImage:[UIImage imageNamed:@"dislike_normal"] forState:UIControlStateNormal];
    } else if ([commentData.likeTypeArray containsObject:[NSString stringWithFormat:@"%@:%@", [GlobalData sharedGlobalData].g_userInfo.userID, DISLIKE_TYPE]]) {
        [self.btnLike setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        [self.btnDislike setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    } else {
        [self.btnLike setImage:[UIImage imageNamed:@"like_normal"] forState:UIControlStateNormal];
        [self.btnDislike setImage:[UIImage imageNamed:@"dislike_normal"] forState:UIControlStateNormal];
    }
    
}


@end

