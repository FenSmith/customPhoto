//
//  ShowImageView.h
//  customPhoto
//
//  Created by tangwei on 17/1/22.
//  Copyright © 2017年 tangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakePhotoView.h"

@interface ShowImageView : UIView

@property (nonatomic, copy) void (^didClickSaveBtn)(void);
@property (nonatomic, copy) void (^didClickCancelBtn)(void);
@property (nonatomic, strong) UIImageView *image;

@end
