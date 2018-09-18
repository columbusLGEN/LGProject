//
//  DJMediaPlayDelegate.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/18.
//  Copyright © 2018 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DJDataBaseModel;

@protocol DJMediaPlayDelegate <NSObject>
- (void)currentMediaPlayCompleteWithCurrentModel:(DJDataBaseModel *)currentModel;

@end
