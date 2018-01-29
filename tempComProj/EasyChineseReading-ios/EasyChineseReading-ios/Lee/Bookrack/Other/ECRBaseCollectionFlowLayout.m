//
//  ECRBaseCollectionFlowLayout.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/20.
//  Copyright © 2017年 retech. All rights reserved.
//

//static CGFloat bookMargin = 10;
//static CGFloat bookSpace = 40;

#import "ECRBaseCollectionFlowLayout.h"

@interface ECRBaseCollectionFlowLayout ()

@end

@implementation ECRBaseCollectionFlowLayout

- (CGFloat)insetsMarginT{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 15;
    }
    return 10;
}
- (CGFloat)insetsMarginLR{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 36;
    }
    return 10;
}

- (CGFloat)minimunBookSpace{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 40;
    }
    return 0;
}

- (CGFloat)bookSpace{
    return 40;
}
- (CGFloat)bookMargin{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 36;
    }
    return 10;
}

- (CGSize)itemSize{
    CGSize custemSize;

    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // pad
//        custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace * 3) / 4, 180);//
//        custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace * 3) / 4, 228);//
        custemSize = CGSizeMake(137, 228);//
    }else{
        // phone
        if (Screen_Width < 375) {
            custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace) / 3, 150);//
        }else if(Screen_Width == 375){
            custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace * 2) / 3, 150);//
        }else{//  if(Screen_Width == 414)
            custemSize = CGSizeMake((Screen_Width - 2 * self.bookMargin - self.bookSpace * 2) / 3, 180);//
        }
    }
    return custemSize;
}

@end
