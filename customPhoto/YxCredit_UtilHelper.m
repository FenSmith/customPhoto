//
//  YxCredit_UtilHelper.m
//  creditApp
//
//  Created by tangwei on 16/4/27.
//  Copyright © 2016年 tangwei. All rights reserved.
//
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>//md5、md4等
#import "YxCredit_UtilHelper.h"

@implementation YxCredit_UtilHelper

+ (NSString *) getImagePath:(NSString *) imageName
{
    NSString *bundlePath = [[ NSBundle mainBundle] pathForResource:@"YxCredit_bundle" ofType:@"bundle"];
    NSString *imgPath = [bundlePath stringByAppendingPathComponent:imageName];
    
    return imgPath;
}

+ (NSData *)scaleImage:(UIImage *)image withWidth:(int) width rate:(float) rate
{
    int height = image.size.height;
    if (image.size.width > width) {
        height = image.size.height / image.size.width * width;
    }
    else{
        width = image.size.width;
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImageJPEGRepresentation(scaledImage, rate);
}

+ (NSString *) getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    return dateTime;
}

+ (NSMutableArray *) getFilePath:(NSString *) filePath
{
    NSString *allPath = filePath;
    NSMutableArray *filePathArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ( [allPath rangeOfString:@","].location != NSNotFound ) {

        NSRange range = [allPath rangeOfString:@","];
        NSString *cutString = [allPath substringToIndex:range.location];
        [filePathArray addObject:cutString];
        allPath = [allPath substringFromIndex:(range.location + 1)];
    }
    [filePathArray addObject:allPath];
    
    return filePathArray;
}

+ (NSMutableArray *) getVersion:(NSString *) sdkVersion
{
    NSString *allPath = sdkVersion;
    NSMutableArray *filePathArray = [[NSMutableArray alloc] initWithCapacity:0];
    while ( [allPath rangeOfString:@"."].location != NSNotFound ) {
        
        NSRange range = [allPath rangeOfString:@"."];
        NSString *cutString = [allPath substringToIndex:range.location];
        [filePathArray addObject:cutString];
        allPath = [allPath substringFromIndex:(range.location + 1)];
    }
    [filePathArray addObject:allPath];
    
    return filePathArray;
}

//MD5对字符串加密
+ (NSString*)lowerMD5_32:(NSString *)str {
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    
    return destDate;
}

+ (BOOL) isPureInt:(NSString *) string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (void) defaultWorkspace
{
    
}

- (void) allApplications
{
    
}

- (void) applicationIdentifier
{
    
}

+ (NSMutableArray *) getAppList
{
    NSArray *withOutKeysArr =
    @[@"com.apple.gamecenter",
      @"com.apple.SharedWebCredentialViewService",
      @"com.apple.FacebookAccountMigrationDialog",
      @"com.apple.mobilesafari",
      @"com.apple.AdSheetPhone",
      @"com.apple.share",
      @"com.apple.SafariViewService",
      @"com.apple.appleaccount.AACredentialRecoveryDialog",
      @"com.apple.Preferences",
      @"com.apple.CloudKit.ShareBear",
      @"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI",
      @"com.apple.Passbook",
      @"com.apple.iCloudDriveApp",
      @"com.apple.WatchKitSettings",
      @"com.apple.TrustMe",
      @"com.apple.mobileslideshow",
      @"com.apple.mobilesms.compose",
      @"com.apple.CoreAuthUI",
      @"com.apple.iad.iAdOptOut",
      @"com.apple.TencentWeiboAccountMigrationDialog",
      @"com.apple.WebViewService",
      @"com.apple.MailCompositionService",
      @"com.apple.Maps",
      @"com.apple.MusicUIService",
      @"com.apple.social.SLYahooAuth",
      @"com.apple.AccountAuthenticationDialog",
      @"com.apple.PhotosViewService",
      @"com.apple.quicklook.quicklookd",
      @"com.apple.managedconfiguration.MDMRemoteAlertService",
      @"com.apple.LoginUI",
      @"com.apple.Health",
      @"com.apple.MobileAddressBook",
      @"com.apple.datadetectors.DDActionsService",
      @"com.apple.social.SLGoogleAuth",
      @"com.apple.DataActivation",
      @"com.apple.Home.HomeUIService",
      @"com.apple.ServerDocuments",
      @"com.apple.HealthPrivacyService",
      @"com.apple.WebSheet",
      @"com.apple.camera",
      @"com.apple.mobilecal",
      @"com.apple.news",
      @"smc.MHTeam",
      @"com.apple.ios.StoreKitUIService",
      @"com.apple.gamecenter.GameCenterUIService",
      @"com.apple.PrintKit.Print-Center",
      @"com.apple.webapp",
      @"com.apple.reminders",
      @"com.apple.PassbookUIService",
      @"com.apple.webapp1",
      @"com.apple.podcasts",
      @"com.apple.Music",
      @"com.apple.Fitness",
      @"com.apple.appleseed.FeedbackAssistant",
      @"com.apple.DemoApp",
      @"com.apple.AppStore",
      @"com.apple.mobiletimer",
      @"com.apple.mobileme.fmf1",
      @"com.apple.Bridge",
      @"com.apple.facetime",
      @"com.apple.InCallService",
      @"com.apple.VoiceMemos",
      @"com.apple.mobilephone",
      @"com.apple.CompassCalibrationViewService",
      @"com.apple.mobilemail",
      @"com.apple.family",
      @"com.apple.compass",
      @"com.apple.SiriViewService",
      @"com.apple.mobilesms.notification",
      @"com.apple.Diagnostics.Mitosis",
      @"com.apple.iosdiagnostics",
      @"com.apple.fieldtest",
      @"com.apple.tips",
      @"com.apple.iBooks",
      @"com.apple.MobileSMS",
      @"com.apple.weather",
      @"com.apple.GameController",
      @"com.apple.MobileReplayer",
      @"com.apple.mobileme.fmip1",
      @"com.apple.AskPermissionUI",
      @"com.apple.stocks",
      @"com.apple.videos",
      @"com.apple.StoreDemoViewService",
      @"com.apple.MobileStore",
      @"com.apple.purplebuddy",
      @"com.apple.Diagnostics",
      @"com.apple.PreBoard",
      @"com.apple.calculator",
      @"com.apple.mobilenotes",
      @"com.123"];
    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *appList = [workspace performSelector:@selector(allApplications)];
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    
    NSMutableArray *list = [NSMutableArray new];
    
    for (LSApplicationProxy_class in appList)
    {
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        NSObject *localizedName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
        
        bool isSystemApp = false;
        
        for ( NSString *id in withOutKeysArr ) {
            
            if ( bundleID.length == 0 ) {
                isSystemApp = true;
                break;
            }
            
            if ( [bundleID isEqualToString:id] ) {
                isSystemApp = true;
                break;
            }
        }
        
        if ( !isSystemApp ) {
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setValue:localizedName forKey:@"appName"];
            [dict setValue:bundleID forKey:@"appPkgName"];
            [dict setValue:@"" forKey:@"installTime"];
            [list addObject:dict];
        }
    }
    
    return list;
}

@end
