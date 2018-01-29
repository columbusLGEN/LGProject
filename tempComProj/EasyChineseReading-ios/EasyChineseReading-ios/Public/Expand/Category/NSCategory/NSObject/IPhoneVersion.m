//
//  IPhoneVersion.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/6.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "IPhoneVersion.h"

@implementation IPhoneVersion

+(NSDictionary*)deviceNamesByCode {
    
    static NSDictionary* deviceNamesByCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceNamesByCode = @{
                              //iPhones
                              @"iPhone3,1" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone3,3" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone4,1" :[NSNumber numberWithInteger:iPhone4S],
                              @"iPhone5,1" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,2" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,3" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone5,4" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone6,1" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone6,2" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone7,1" :[NSNumber numberWithInteger:iPhone6Plus],
                              @"iPhone7,2" :[NSNumber numberWithInteger:iPhone6],
                              @"iPhone8,1" :[NSNumber numberWithInteger:iphone6s],
                              @"iPhone8,2" :[NSNumber numberWithInteger:iPhone6sPlus],
                              @"iPhone8,4" :[NSNumber numberWithInteger:iPhoneSE],
                              @"iPhone9,1" :[NSNumber numberWithInteger:iphone7],
                              @"iPhone9,2" :[NSNumber numberWithInteger:iphone7Plus],
                              @"iPhone10,1" :[NSNumber numberWithInteger:iphone8],
                              @"iPhone10,2" :[NSNumber numberWithInteger:iphone8Plus],
                              @"iPhone10,3" :[NSNumber numberWithInteger:iphoneX],
                              @"iPhone10,4" :[NSNumber numberWithInteger:iphone8],
                              @"iPhone10,5" :[NSNumber numberWithInteger:iphone8Plus],
                              @"iPhone10,6" :[NSNumber numberWithInteger:iphoneX],

                              @"i386"      :[NSNumber numberWithInteger:Simulator],
                              @"x86_64"    :[NSNumber numberWithInteger:Simulator],
                              
                              //iPads
                              @"iPad1,1" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,1" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,2" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,3" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,4" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,5" :[NSNumber numberWithInteger:iPadMini],
                              @"iPad2,6" :[NSNumber numberWithInteger:iPadMini],
                              @"iPad2,7" :[NSNumber numberWithInteger:iPadMini],
                              @"iPad3,1" :[NSNumber numberWithInteger:iPad3],
                              @"iPad3,2" :[NSNumber numberWithInteger:iPad3],
                              @"iPad3,3" :[NSNumber numberWithInteger:iPad3],
                              @"iPad3,4" :[NSNumber numberWithInteger:iPad4],
                              @"iPad3,5" :[NSNumber numberWithInteger:iPad4],
                              @"iPad3,6" :[NSNumber numberWithInteger:iPad4],
                              @"iPad4,1" :[NSNumber numberWithInteger:iPadAir],
                              @"iPad4,2" :[NSNumber numberWithInteger:iPadAir],
                              @"iPad4,4" :[NSNumber numberWithInteger:iPadMiniRetina],
                              @"iPad4,5" :[NSNumber numberWithInteger:iPadMiniRetina]
                              
                              
                              };
    });
    
    return deviceNamesByCode;
}

+(DeviceVersion)deviceVersion {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    DeviceVersion version = (DeviceVersion)[[self.deviceNamesByCode objectForKey:code] integerValue];
    
    return version;
}

+ (DeviceSize)deviceSize {
    
    CGFloat screenHeight = [self deviceScreenSize].height;
    
    if (screenHeight == 480)
        return iPhone35inch;
    else if(screenHeight == 568)
        return iPhone4inch;
    else if(screenHeight == 667)
        return iPhone47inch;
    else if(screenHeight == 736)
        return iPhone55inch;
    else if(screenHeight == 812)
        return iPhone58inch;
    else
        return UnknownSize;
}

+ (NSString *)deviceName {
    
    //    struct utsname systemInfo;
    //    uname(&systemInfo);
    //    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //    if ([code isEqualToString:@"x86_64"] || [code isEqualToString:@"i386"]) {
    //        code = @"Simulator";
    //    }
    //
    //    return code;
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
}

+ (CGSize)deviceScreenSize
{
    CGSize screenSize;
    
    if (iOSVersionGreaterThan(@"8")) {
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if (orientation ==  UIDeviceOrientationPortrait)
        {
            screenSize = [[UIScreen mainScreen] bounds].size;
        }
        else if((orientation == UIDeviceOrientationLandscapeRight) || (orientation == UIInterfaceOrientationLandscapeLeft))
        {
            screenSize.width = [[UIScreen mainScreen] bounds].size.height;
            screenSize.height = [[UIScreen mainScreen] bounds].size.width;
        }
        else {
            screenSize = [[UIScreen mainScreen] bounds].size;
        }
    }
    else
    {
        screenSize = [[UIScreen mainScreen] bounds].size;
    }
    
    return screenSize;
}

+(BOOL)isSameWithDeviceSize:(id)deviceSizes
{
    if (deviceSizes == nil) {
        return  NO;
    }
    BOOL isFlag = NO;
    if ([deviceSizes isKindOfClass:[NSArray class]]) {
        NSArray *deviceSizeArr = (NSArray *)deviceSizes;
        if (deviceSizeArr && deviceSizeArr.count > 0) {
            for (int i=0; i<deviceSizeArr.count; i++) {
                isFlag = isFlag || ([[self class] deviceSize] == (DeviceSize)[deviceSizeArr[i] integerValue]) ;
            }
        }
    }else{
        isFlag = ([[self class] deviceSize] ==(DeviceSize)[deviceSizes integerValue]) ;
    }
    
    return isFlag;
}


/**
 * 适配函数
 */
-(void)fitIphone4Or5f:(BlankBlock)ablock and6:(BlankBlock)bblock and6P:(BlankBlock)cblock
{
    if ( [IPhoneVersion deviceSize] == iPhone55inch )
    {
        cblock();
    }
    else if([IPhoneVersion deviceSize] == iPhone47inch)
    {
        bblock();
    }
    else if([IPhoneVersion deviceSize] == iPhone4inch || [IPhoneVersion deviceSize] == iPhone35inch)
    {
        ablock();
    }
}

@end
