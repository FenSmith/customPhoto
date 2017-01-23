//
//  YxCredit_UtilHelper.h
//  creditApp
//
//  Created by tangwei on 16/4/27.
//  Copyright © 2016年 tangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YxCredit_UtilHelper : NSObject

+ (NSString *) getImagePath:(NSString *) imageName;

+ (void) showMBProgress:(NSString *) msg inView:(UIView *) view;

+ (NSData *)scaleImage:(UIImage *)image withWidth:(int) width rate:(float) rate;

+ (NSString *) getCurrentTime;

+ (NSMutableArray *) getFilePath:(NSString *) filePath;

+ (NSMutableArray *) getVersion:(NSString *) sdkVersion;

+ (NSString *)lowerMD5_32:(NSString *)str;//32位小写不带keyMD5加密

+ (NSDate *)dateFromString:(NSString *)dateString;

+ (BOOL) isPureInt:(NSString *) string;

+ (BOOL)stringContainsEmoji:(NSString *)string;

//获取手机上所装app信息
+ (NSMutableArray *) getAppList;

@end
