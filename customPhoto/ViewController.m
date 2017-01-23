//
//  ViewController.m
//  customPhoto
//
//  Created by tangwei on 17/1/17.
//  Copyright © 2017年 tangwei. All rights reserved.
//

#import "ViewController.h"
#import "TakePhotoView.h"
#import "ShowImageView.h"

#define WeakSelf    __weak typeof(self) weakSelf = self;
#define StrongSelf  __strong typeof(weakSelf) self = weakSelf;

@interface ViewController ()

@property (strong, nonatomic) TakePhotoView *takePhotoVC;
@property (strong, nonatomic) ShowImageView *showImageView;
@property (strong, nonatomic) UIImageView   *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 120) / 2, 100, 120, 40)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"自定义相机" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showCarera) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 10.0;
    [self.view addSubview:btn];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 250) / 2, 150, 250, 120)];
    [self.view addSubview:self.image];
}

- (void) showCarera
{
    self.takePhotoVC = [[TakePhotoView alloc] init];
    WeakSelf
    self.takePhotoVC.getImage = ^(UIImage *image){
        StrongSelf
        [self.image setImage:image];
    };

    [self presentViewController:self.takePhotoVC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
