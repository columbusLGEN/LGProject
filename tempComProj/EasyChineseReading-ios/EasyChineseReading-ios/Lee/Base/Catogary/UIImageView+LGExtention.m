//
//  UIImageView+LGExtention.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/12/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UIImageView+LGExtention.h"

@implementation UIImageView (LGExtention)

+ (void)load{
    Method origin_sd_method = class_getInstanceMethod([self class], @selector(sd_setImageWithURL:placeholderImage:));
    
    Method instead_lg_method = class_getInstanceMethod([self class], @selector(lg_setImageWithURL:placeholderImage:));
    
    method_exchangeImplementations(origin_sd_method, instead_lg_method);
}

- (void)lg_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
//    NSLog(@"运行时修改image加载方式");
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image != nil) {
            //            NSLog(@"SDImageCacheType -- %ld",cacheType);
            self.image = [image compressForWidth:self.size.width * 2];
        }
        [[SDImageCache sharedImageCache] clearMemory];
    }];
}

@end
