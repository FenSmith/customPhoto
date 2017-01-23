//
//  TakePhotoView.h
//  customPhoto
//
//  Created by tangwei on 17/1/17.
//  Copyright © 2017年 tangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePhotoView : UIViewController

- (void)startRunning;
- (void)stopRunning;

//// 拍照
//- (void)takeAPicture;

// 切换前后镜头
- (void)setFrontOrBackFacingCamera:(BOOL)isUsingFrontFacingCamera;

// 写入本地
- (void)writeToSavedPhotos;

// 获取拍照后的图片
@property (nonatomic, copy) void (^getImage)(UIImage *image);

// 是否写入本地
@property (nonatomic, assign) BOOL shouldWriteToSavedPhotos;

@end
