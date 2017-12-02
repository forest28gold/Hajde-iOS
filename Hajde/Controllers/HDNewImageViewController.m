//
//  HDNewImageViewController.m
//  Hajde
//
//  Created by AppsCreationTech on 3/13/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "HDNewImageViewController.h"
#import "HDImageEditViewController.h"

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface HDNewImageViewController ()

@property(nonatomic,strong) AVCaptureSession *captureSession;
@property(nonatomic,strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic,strong) AVCaptureDevice *captureDevice;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(nonatomic,assign) BOOL isCapturingImage;
@property(nonatomic,strong) UIImageView *capturedImageView;
@property(nonatomic,strong) UIView *imageSelectedView;
@property(nonatomic,strong) UIImage *selectedImage;

@end

@implementation HDNewImageViewController
{
    UIButton *flashBtn;
    UIButton *cameraBtn;
    
    float preLayerWidth;
    float preLayerHeight;
    float preLayerHWRate;
}

#pragma mark - init
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    preLayerWidth = SCREEN_WIDTH;
    preLayerHeight = SCREEN_HEIGHT;
    preLayerHWRate =SCREEN_HEIGHT/SCREEN_WIDTH;
    
    [self setupConfiguration];
    
    [self initCaptureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [_captureSession startRunning];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_captureSession stopRunning];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private
- (void)setupConfiguration
{
    _captureSession = [[AVCaptureSession alloc]init];
    _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    _capturedImageView = [[UIImageView alloc] init];
    _capturedImageView.frame = self.view.frame; // just to even it out
    _capturedImageView.backgroundColor = [UIColor clearColor];
    _capturedImageView.userInteractionEnabled = YES;
    _capturedImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _captureVideoPreviewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_captureVideoPreviewLayer];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count > 0) {
        _captureDevice = devices[0];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
        
        [_captureSession addInput:input];
        
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [_stillImageOutput setOutputSettings:outputSettings];
        [_captureSession addOutput:_stillImageOutput];
    }
}

-(void)initCaptureUI
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    topView.backgroundColor = [UIColor clearColor];
    topView.alpha = 1.0;
    [self.view addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
    bottomView.backgroundColor = UIColorFromRGB(0x1d1e20);
    bottomView.alpha = 0.5;
    [self.view addSubview:bottomView];
    
    _captureBtn = [[LeafButton alloc]initWithFrame:CGRectMake(0, 0, 132/2, 132/2)];
    _captureBtn.center = CGPointMake(SCREEN_WIDTH/2, preLayerHeight-48);
    _captureBtn.type = LeafButtonTypeCamera;
    [self.view addSubview:_captureBtn];
    
    __weak HDNewImageViewController *weakSelf = self;
    [_captureBtn setClickedBlock:^(LeafButton *button) {

        [weakSelf captureBtnClick];
    }];
    
    flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 34, 34)];
    [flashBtn setBackgroundImage:[UIImage imageNamed:@"camera_flash"] forState:UIControlStateNormal];
    [flashBtn makeCornerRadius:34/2 borderColor:nil borderWidth:0];
    [flashBtn addTarget:self action:@selector(flashBtTap:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:flashBtn];
    
    
    UIImageView *imgLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 33)];
    imgLogo.image = [UIImage imageNamed:@"logo_camera"];
    imgLogo.center = CGPointMake(SCREEN_WIDTH/2, 30);
    [topView addSubview:imgLogo];
    
    cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-55, 15, 34, 34)];
    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"camera_switch"] forState:UIControlStateNormal];
    [cameraBtn makeCornerRadius:34/2 borderColor:nil borderWidth:0];
    [cameraBtn addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cameraBtn];
    
    _dismissBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    _dismissBtn.center = CGPointMake(45, SCREEN_HEIGHT - 48);
    [_dismissBtn setTitle:NSLocalizedString(@"cancel", "") forState:UIControlStateNormal];
    [_dismissBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dismissBtn addTarget:self action:@selector(dismissBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dismissBtn];
    
    [_dismissBtn setEnlargeEdge:20];
    
    _libraryImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 55, 55)];
    _libraryImage.center = CGPointMake(SCREEN_WIDTH-45, SCREEN_HEIGHT - 48);
    _libraryImage.contentMode = UIViewContentModeScaleAspectFill;
    _libraryImage.clipsToBounds = YES;
    _libraryImage.layer.borderWidth = 1.5f;
    _libraryImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:_libraryImage];
    
    if ([GlobalData sharedGlobalData].g_imgPostBack != nil) {
        _libraryImage.image = [GlobalData sharedGlobalData].g_imgPostBack;
    } else {
        _libraryImage.image = [UIImage imageNamed:@"camera_lib"];
    }
    
    _libraryImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap_photo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(libraryImageClick:)];
    [_libraryImage addGestureRecognizer:tap_photo];
    
    [_dismissBtn setEnlargeEdge:20];
    
    
    [self initImageSelectedView];
}

- (void)initImageSelectedView
{
    _imageSelectedView = [[UIView alloc]initWithFrame:self.view.frame];
    [_imageSelectedView setBackgroundColor:[UIColor clearColor]];
    [_imageSelectedView addSubview:_capturedImageView];

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
    bottomView.backgroundColor = UIColorFromRGB(0x1d1e20);
    bottomView.alpha = 0.5;
    [_imageSelectedView addSubview:bottomView];
    

    UIButton *retakeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 60)];
    retakeBtn.center = CGPointMake(45, SCREEN_HEIGHT - 48);
    [retakeBtn setTitle:NSLocalizedString(@"retake", "") forState:UIControlStateNormal];
    [retakeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [retakeBtn addTarget:self action:@selector(retakeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_imageSelectedView addSubview:retakeBtn];

    [retakeBtn setEnlargeEdge:20];
    

    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    doneBtn.center = CGPointMake(SCREEN_WIDTH-55, SCREEN_HEIGHT - 48);
    [doneBtn setTitle:NSLocalizedString(@"use_photo", "") forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_imageSelectedView addSubview:doneBtn];

    [doneBtn setEnlargeEdge:20];
}

#pragma mark - tool
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
    NSError *error;

    if ([_captureDevice lockForConfiguration:&error]) {
        propertyChange(_captureDevice);
        [_captureDevice unlockForConfiguration];
    }else{
        NSLog(@"Error, error information setting device properties takes place：%@",error.localizedDescription);
    }
}

-(void)setTorchMode:(AVCaptureTorchMode )torchMode
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isTorchModeSupported:torchMode]) {
            [captureDevice setTorchMode:torchMode];
        }
    }];
}

-(void)setFocusMode:(AVCaptureFocusMode )focusMode
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

- (void)retakeBtnClick:(id)sender
{
    [_imageSelectedView removeFromSuperview];
}

- (void)doneBtnClick:(id)sender
{
    [_imageSelectedView removeFromSuperview];
    
    [GlobalData sharedGlobalData].g_imgPostBack = _selectedImage;
    
    [self performSegueWithIdentifier:SEGUE_IMAGE_EDIT sender:nil];
    
}

#pragma mark - target action

-(void)flashBtTap:(UIButton *)btn
{
    if (btn.selected == YES) {
        btn.selected = NO;

        [flashBtn setBackgroundImage:[UIImage imageNamed:@"camera_flash"] forState:UIControlStateNormal];
        [self setTorchMode:AVCaptureTorchModeOff];
    }
    else
    {
        btn.selected = YES;

        [flashBtn setBackgroundImage:[UIImage imageNamed:@"camera_flash_off"] forState:UIControlStateNormal];
        [self setTorchMode:AVCaptureTorchModeOn];
    }
}

-(void)changeCamera:(id)sender
{
    // Need to reset flash btn
    AVCaptureDevicePosition currentPosition=[_captureDevice position];
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront)
    {
        flashBtn.hidden = NO;
    }
    else
    {
        flashBtn.hidden = YES;
    }
    
    
    if (_isCapturingImage != YES) {
        if (_captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
            // rear active, switch to front
            _captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1];
            
            [_captureSession beginConfiguration];
            AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:nil];
            for (AVCaptureInput * oldInput in _captureSession.inputs) {
                [_captureSession removeInput:oldInput];
            }
            [_captureSession addInput:newInput];
            [_captureSession commitConfiguration];
        }
        else if (_captureDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1]) {
            // front active, switch to rear
            _captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
            [_captureSession beginConfiguration];
            AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:nil];
            for (AVCaptureInput * oldInput in _captureSession.inputs) {
                [_captureSession removeInput:oldInput];
            }
            [_captureSession addInput:newInput];
            [_captureSession commitConfiguration];
        }
    }
    
    flashBtn.selected = NO;
    [flashBtn setBackgroundImage:[UIImage imageNamed:@"camera_flash"] forState:UIControlStateNormal];
    [self setTorchMode:AVCaptureTorchModeOff];
}

-(void)captureBtnClick
{
    _isCapturingImage = YES;
//    AVCaptureConnection *videoConnection = nil;
//    for (AVCaptureConnection *connection in _stillImageOutput.connections)
//    {
//        for (AVCaptureInputPort *port in [connection inputPorts])
//        {
//            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
//            {
//                videoConnection = connection;
//                break;
//            }
//        }
//        if (videoConnection) {
//            break;
//        }
//    }
    
    AVCaptureConnection *videoConnection = _stillImageOutput.connections[0];   
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            UIImage *capturedImage = [[UIImage alloc] initWithData:imageData scale:1.0];
            _isCapturingImage = NO;
//            _capturedImageView.image = capturedImage;
//            _selectedImage = capturedImage;
//            imageData = nil;
            
            _libraryImage.image = capturedImage;
            [GlobalData sharedGlobalData].g_imgPostBack = capturedImage;
            
            if (flashBtn.hidden) {
                [GlobalData sharedGlobalData].g_imgPostBack = [self reverseImage:capturedImage];
            }
            
            [self performSegueWithIdentifier:SEGUE_IMAGE_EDIT sender:nil];
            
//            [self.view addSubview:_imageSelectedView];
        }
    }];

}

- (UIImage*)reverseImage:(UIImage*)theImage {
    
    CGSize imageSize = theImage.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextRotateCTM(ctx, M_PI/2);
    CGContextTranslateCTM(ctx, 0, -imageSize.width);
    CGContextScaleCTM(ctx, imageSize.height/imageSize.width, imageSize.width/imageSize.height);
    CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, imageSize.width, imageSize.height), theImage.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)dismissBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)libraryImageClick:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    [imagePicker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    if(m_popoverController != nil) {
        [m_popoverController dismissPopoverAnimated:YES];
        m_popoverController = nil;
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            m_popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            m_popoverController.delegate = self;
            [m_popoverController presentPopoverFromRect:CGRectMake(0, 0, 1024, 160)
                                                 inView:self.view
                               permittedArrowDirections:UIPopoverArrowDirectionAny
                                               animated:YES];
        } else {
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }

}

#pragma mark - image picker controller

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [GlobalData sharedGlobalData].g_imgPostBack = [info objectForKey:UIImagePickerControllerOriginalImage];
    _libraryImage.image = [GlobalData sharedGlobalData].g_imgPostBack;
    
    m_pickerController = picker;
    
    HDImageEditViewController *controller = [[self storyboard]instantiateViewControllerWithIdentifier:VIEW_IMAGE_EDIT];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [m_pickerController presentViewController:navigationController animated:YES completion:^(void) {

    }];
    
}

@end
