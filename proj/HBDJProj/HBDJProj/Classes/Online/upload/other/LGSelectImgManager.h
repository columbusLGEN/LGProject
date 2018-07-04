//
//  LGSelectImgManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HXWeiboPhotoPicker/HXPhotoView.h>

@interface LGSelectImgManager : NSObject<HXPhotoViewDelegate>

/** 记录了所选照片的本地临时路径 */
@property (strong,nonatomic) NSMutableArray *tempImageUrls;
@property (strong,nonatomic) HXPhotoManager *hxPhotoManager;

CM_SINGLETON_INTERFACE
@end
