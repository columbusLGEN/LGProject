//
//  UIImageView+SDWebImage.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UIImageView+SDWebImage.h"
#import <objc/runtime.h>

@implementation UIImageView(SDWebImage)

// TODO: 替换SDWebImage 展示图片的方法 压缩图片
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        Class class = [self class];
        
        //Whenswizzlingaclassmethod,usethefollowing:
        //Classclass=object_getClass((id)self);
        
        SEL originalSelector = @selector(sd_setImageWithURL:placeholderImage:);
        SEL swizzledSelector = @selector(zz_setImageWithURL:placeHolderImage:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod,swizzledMethod);
        }
    });
}

- (void)zz_setImageWithURL:(NSURL *)url placeHolderImage:(UIImage *)image
{
    [self sd_setImageWithURL:url
            placeholderImage:image
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       if (image) {
                           self.image = [image compressForSize:self.bounds.size];
                       }
                   }];
    // TODO: 清理掉图片缓存 如果觉得费流量 注释掉
    [[SDImageCache sharedImageCache] clearMemory];
//    [self zz_setImageWithURL:url placeHolderImage:image];
}

@end
