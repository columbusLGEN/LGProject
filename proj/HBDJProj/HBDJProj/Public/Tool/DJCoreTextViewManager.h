//
//  DJCoreTextViewManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGAttributedTextView;

@protocol DJCoreTextViewManagerDelegate <NSObject>
- (void)hyperLinkClick:(NSURL *)url;

@end

@interface DJCoreTextViewManager : NSObject

/// 接受一个富文本字符串，返回富文本view
- (void)viewWithRichText:(NSString *)richText completion:(void(^)(LGAttributedTextView *))completion;

@property (weak,nonatomic) id<DJCoreTextViewManagerDelegate> delegate;

@end
