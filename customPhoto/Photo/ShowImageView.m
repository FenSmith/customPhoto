//
//  ShowImageView.m
//  customPhoto
//
//  Created by tangwei on 17/1/22.
//  Copyright © 2017年 tangwei. All rights reserved.
//

#import "ShowImageView.h"
#import "CardBoxView.h"

#define custom_iPhone4_4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 当前屏幕 width
#define CustomScreenWidth [UIScreen mainScreen].bounds.size.width

// 当前屏幕 height
#define CustomScreenHeight [UIScreen mainScreen].bounds.size.height

static ShowImageView *showImageViewInstance;

@interface ShowImageView()

@property (strong, nonatomic) CardBoxView *boxLayer;

@end

@implementation ShowImageView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.backgroundColor = [UIColor blackColor];
        [self init_data];
        [self init_ui];
    }

    return self;
}

- (void) init_data
{
}

- (void) init_ui
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
    
    UIButton *btnGet = [[UIButton alloc] initWithFrame:CGRectMake(CustomScreenHeight - 100, rectTop, 45, 30.0)];
    btnGet.center = CGPointMake(CustomScreenHeight - bottom_h / 2, btnGet.frame.origin.y);
    [btnGet setImage:[UIImage imageWithContentsOfFile:[YxCredit_UtilHelper getImagePath:@"YxCredit_confirmPhoto.png"]] forState:UIControlStateNormal];
    [btnGet addTarget:self action:@selector(get) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnGet];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(CustomScreenHeight - 100, rectTop + rect_h - 22, 45, 30)];
    btnCancel.center = CGPointMake(btnGet.center.x, btnCancel.center.y);
    [btnCancel setImage:[UIImage imageWithContentsOfFile:[YxCredit_UtilHelper getImagePath:@"YxCredit_cancelPhoto.png"]] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCancel];
    
    self.image = [[UIImageView alloc] initWithFrame:IDCardBoxRect];
    [self addSubview:self.image];
}

- (void) cancel
{
    self.didClickCancelBtn();
}

- (void) get
{
    self.didClickSaveBtn();
}

@end
