//
//  Public_Macro.h
//  creditApp
//
//  Created by tangwei on 16/9/28.
//  Copyright © 2016年 tangwei. All rights reserved.
//

#ifndef Public_Macro_h
#define Public_Macro_h

// 当前屏幕 width
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

// 当前屏幕 height
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//判断版本
#define IOS8  ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 )
#define IOS7  ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 )
#define IOS6  ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 )
#define IOS5  ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 )

//判断机型
#define iPhone4_4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5_5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) //判断手机规格
#define isIphone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO) //判断iphone6plus手机规格
#define isIphone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO) //判断手机规格
//iPhone4 5
#define   isIphone4_5  [UIScreen mainScreen].bounds.size.width < 350

//字号
#define MHFont(int)  [UIFont systemFontOfSize:int]

//颜色
#define UIColorFromHex(HexColor) [UIColor colorWithRed:((float)((HexColor & 0xFF0000) >> 16))/255.0 green:((float)((HexColor & 0xFF00) >> 8))/255.0 blue:((float)(HexColor & 0xFF))/255.0 alpha:1.0]
#define UIColorFromHexA(HexColor,A) [UIColor colorWithRed:((float)((HexColor & 0xFF0000) >> 16))/255.0 green:((float)((HexColor & 0xFF00) >> 8))/255.0 blue:((float)(HexColor & 0xFF))/255.0 alpha:A]
#define UIColorFromRGBA(R,G,B,A) [UIColor colorWithRed:(R/255.0) green:(G/255.0) blue:(B/255.0) alpha:A]
#define UIColorFromRGB(R,G,B) [UIColor colorWithRed:(R/255.0) green:(G/255.0) blue:(B/255.0) alpha:1.0]
#define kRandomColor KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成

//弱引用/强引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//判断字符串是否为空,YES:字符串为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1)

//判断数组是否为空，YES:数组为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//判断字典是否为空,YES:字典为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//判断是否是iphone设备
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否是ipad设备
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒temp路径
#define kTempPath NSTemporaryDirectory()

//获取沙盒Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#if TARGET_OS_IPHONE
//真机
#endif
#if TARGET_IPHONE_SIMULATOR
//模拟器
#endif

/*调试模式日志输出*/
//打印日志,输出当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
# define TESTLog(format, ...) NSLog((@"" format),    ##__VA_ARGS__);
#else
#   define DLog(...)
# define TESTLog(...);
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc]\
initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] essage:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#endif /* Public_Macro_h */
