//
//  HDPhotoDetailsViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 6/29/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "HDPhotoDetailsViewController.h"

@interface HDPhotoDetailsViewController ()

@end

@implementation HDPhotoDetailsViewController

@synthesize m_imgPhoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *imageURL = [NSURL URLWithString:[GlobalData sharedGlobalData].g_strPhotoUrl];
    [m_imgPhoto setShowActivityIndicatorView:YES];
    [m_imgPhoto setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [m_imgPhoto sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"post_image.png"]];
    
    m_imgPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_photo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPhoto)];
    [m_imgPhoto addGestureRecognizer:tap_photo];
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

- (void)onTapPhoto {
    
    [GlobalData sharedGlobalData].g_togglePhotoIsOn = true;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
