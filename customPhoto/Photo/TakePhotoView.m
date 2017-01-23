//
//  TakePhotoView.m
//  customPhoto
//
//  Created by tangwei on 17/1/17.
//  Copyright © 2017年 tangwei. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "TakePhotoView.h"
// 为了导入系统相册
#import <AssetsLibrary/AssetsLibrary.h>

#import <Photos/Photos.h>
#import "UIImage+info.h"
#import "CardBoxView.h"
#import "ShowImageView.h"

#define kIsAuthorizedString @"请在iOS - 设置 － 隐私 － 相机 中打开相机权限"
#define UIColorFromHexTakePhoto(HexColor) [UIColor colorWithRed:((float)((HexColor & 0xFF0000) >> 16))/255.0 green:((float)((HexColor & 0xFF00) >> 8))/255.0 blue:((float)(HexColor & 0xFF))/255.0 alpha:1.0]
#define iPhone4_4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define custom_iPhone4_4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define WeakSelf    __weak typeof(self) weakSelf = self;
#define StrongSelf  __strong typeof(weakSelf) self = weakSelf;

// 当前屏幕 width
#define CustomScreenWidth [UIScreen mainScreen].bounds.size.width

// 当前屏幕 height
#define CustomScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TakePhotoView ()
<
    UIAlertViewDelegate
>
{
    CGRect _imageRect;
}
@property (nonatomic, strong) AVCaptureSession *session;/**< 输入和输出设备之间的数据传递 */
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;/**< 输入设备 */
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;/**< 照片输出流 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;/**< 预览图片层 */
@property (nonatomic, strong) UIImage *image;
@property (strong, nonatomic) CardBoxView *boxLayer;
@property (strong, nonatomic) ShowImageView *showImageView;
@property (strong, nonatomic) UIImage *imageGet;

@end

@implementation TakePhotoView

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initCameraOverlayView];
    [self initAVCaptureSession];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self isCameraIsAuthorized]) {
         [self startRunning];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"相机权限提示" message:kIsAuthorizedString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        alert.tag = 1;
        [alert show];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopRunning];
}

- (void)startRunning
{
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)stopRunning
{
    if (self.session) {
        [self.session stopRunning];
    }
}

#pragma mark - The Camera is Authorized

/** 是否授权 */
- (BOOL)isCameraIsAuthorized {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusDenied){
        return NO;
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return YES;
}

- (void)initCameraOverlayView
{
    float rat = custom_iPhone4_4s ? 0.18 : 0.12;
    float rectLeft = custom_iPhone4_4s ? CustomScreenHeight * 0.08 : CustomScreenHeight * 0.1;
    float rectTop = CustomScreenWidth * rat;
    float rect_h = CustomScreenWidth * (1 - rat * 2);
    float bottom_h = CustomScreenHeight - (rectLeft + rect_h / 0.63);
    
    CGRect IDCardBoxRect = CGRectMake(rectLeft,
                                      rectTop,
                                      rect_h / 0.63,
                                      rect_h);
    _imageRect = IDCardBoxRect;
    
    self.boxLayer.IDCardBoxRect = IDCardBoxRect;
    self.boxLayer = [[CardBoxView alloc] initWithFrame:CGRectMake(0, 0, CustomScreenHeight, CustomScreenWidth)];
    [self.boxLayer setIDCardBoxRect:IDCardBoxRect];
    [self.view addSubview:self.boxLayer];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(CustomScreenHeight - 100, rectTop, 40, 20.0)];
    btnCancel.center = CGPointMake(CustomScreenHeight - bottom_h / 2, btnCancel.frame.origin.y);
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:UIColorFromHexTakePhoto(0xBDBDBD) forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCancel];
    
    UIButton *btnTakePhoto = [[UIButton alloc] initWithFrame:CGRectMake(CustomScreenHeight - 100, rectTop, 80, 80)];
    btnTakePhoto.center = CGPointMake(btnCancel.center.x, CustomScreenWidth / 2);
    [btnTakePhoto setImage:[UIImage imageWithContentsOfFile:[YxCredit_UtilHelper getImagePath:@"YxCredit_takePhotoBtn.png"]] forState:UIControlStateNormal];
    [btnTakePhoto addTarget:self action:@selector(takeAPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTakePhoto];
    
    self.showImageView = [[ShowImageView alloc] initWithFrame:CGRectMake(0, 0, CustomScreenHeight, CustomScreenWidth)];
    self.showImageView.hidden = YES;
    
    WeakSelf
    _showImageView.didClickCancelBtn = ^ (void) {
        StrongSelf
        self.showImageView.hidden = YES;
    };
    
    _showImageView.didClickSaveBtn = ^ (void) {
        StrongSelf
        self.getImage(self.imageGet);
        [self dismissViewControllerAnimated:YES completion:nil];
    };

    
    [self.view addSubview:self.showImageView];
    
    CATransform3D transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1.0);
    self.view.layer.transform = transform;
}

- (void)initAVCaptureSession {
    self.session = [[AVCaptureSession alloc] init];
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    
    // 设置闪光灯自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    // 照片输出流
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    // 设置输出图片格式
    NSDictionary *outputSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };//@{AVVideoCodecKey : AVVideoCodecJPEG};//@{ (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    // 初始化预览层
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0, CustomScreenHeight, CustomScreenWidth);
    //[self.view.layer addSublayer:self.previewLayer];
    [self.view.layer insertSublayer:self.previewLayer below:[[self.view.layer sublayers] objectAtIndex:0]];
    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
}

// 获取设备方向
- (AVCaptureVideoOrientation)getOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        return AVCaptureVideoOrientationLandscapeRight;
    } else if ( deviceOrientation == UIDeviceOrientationLandscapeRight){
        return AVCaptureVideoOrientationLandscapeLeft;
    }
    return (AVCaptureVideoOrientation)deviceOrientation;
}

// 拍照
- (void)takeAPicture
{
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
//    AVCaptureVideoOrientation avOrientation = [self getOrientationForDeviceOrientation:curDeviceOrientation];
//    [stillImageConnection setVideoOrientation:avOrientation];
    [stillImageConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//        UIImage *image = [UIImage imageWithData:jpegData];
        
        UIImage *image = [self imageFromSampleBuffer:imageDataSampleBuffer];//= [UIImage imageWithData:jpegData];
        
        image = [UIImage image:image scaleToSize:CGSizeMake(CustomScreenHeight, CustomScreenWidth)];
        
        image = [UIImage imageFromImage:image inRect:_imageRect];
        self.imageGet = image;
        [self confirm:image];
        
//        // 写入相册
//        if (self.shouldWriteToSavedPhotos) {
//            [self writeToSavedPhotos];
//        }
        
    }];
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    // Release the Quartz image
    CGImageRelease(quartzImage);
    return (image);
}

- (void) confirm:(UIImage *) image
{
    if ( self.showImageView.image != nil ) {
        [self.showImageView.image setImage:image];
    }
    self.showImageView.hidden = NO;
}

- (void)writeToSavedPhotos
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        NSLog(@"无权限访问相册");
        return;
    }
    
    // 首先判断权限
    if ([self haveAlbumAuthority]) {
        //写入相册
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image: didFinishSavingWithError:contextInfo:), nil);
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"写入相册失败%@", error);
    } else {
        self.image = image;
        // 需要修改相册
        NSLog(@"写入相册成功");
    }
}

- (BOOL)haveAlbumAuthority
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
    
}

- (void)setFrontOrBackFacingCamera:(BOOL)isUsingFrontFacingCamera {
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
    } else {
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
}

- (void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        switch( buttonIndex ) {
            case 0:{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
                break;
                
            case 1:{
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }else{
                    }
                }
                else{
                    NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }else{
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
}

@end
