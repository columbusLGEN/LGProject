//
//  ECRLocationManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "ZCChinaLocation.h"
#import <UMAnalytics/MobClick.h>     // 友盟-统计

@interface ECRLocationManager ()<
CLLocationManagerDelegate
>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (copy,nonatomic) void (^cnBlock)(NSString *country);// 回调 国家名字
/** 1:中国,0外国 */
@property (assign,nonatomic) BOOL isChina;

@end

@implementation ECRLocationManager

+ (BOOL)currentLocationIsChina{
    return [[self sharedInstance] currentLocationIsChina];
}
- (BOOL)currentLocationIsChina{
//    NSLog(@"self.isChina -- %d",self.isChina);
    return self.isChina;
}

#pragma mark - CLLocationManagerDelegate 反地理编码代理
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    NSLog(@"locations -- %@",locations);
    [manager stopUpdatingLocation];
    if (locations.count != 0) {
        CLLocation *location = [locations lastObject];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        self.isChina = [[ZCChinaLocation shared] isInsideChina:(CLLocationCoordinate2D){location.coordinate.latitude,location.coordinate.longitude}];
    
        [MobClick setLocation:location];
        
        // MARK: 反地理编码
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *placemark = placemarks[0];
//            NSLog(@"placemark -- %@",placemarks);
            if (self.cnBlock) {
                // 还原Device 的语言
                self.cnBlock(placemark.country);
                [[CacheDataSource sharedInstance] setCache:placemark.country withCacheKey:CacheKey_CurrentCountry];
//                [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
            }
        }];
        
    }
}

+ (void)rg_startUpdatingLocationWithBlock:(void (^)(NSString *))cnBlock{
    ECRLocationManager *mgr = [self sharedInstance];
    mgr.cnBlock = cnBlock;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [mgr.locationManager requestAlwaysAuthorization];
    }
    [mgr.locationManager startUpdatingLocation];
}

- (instancetype)init{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

@end
