//
//  ECRShoppingCarManager.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/9.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRShoppingCarManager.h"
#import "ECRShoppingCarModel.h"

@interface ECRShoppingCarManager ()

@end

@implementation ECRShoppingCarManager

+ (void)loadCartCount:(cartCountBlock)countBlock{
    [[self sharedInstance] loadCartCount:countBlock];
}
- (void)loadCartCount:(cartCountBlock)countBlock{
    // 获取购物车数据
    [[ECRDataHandler sharedDataHandler] shopCarDataWithSuccess:^(id object) {
        NSArray *array = object;
        if (countBlock) countBlock(array.count);
    } failure:^(NSString *msg) {
        if (countBlock) countBlock(0);
    } commenFailure:^(NSError *error) {
        if (countBlock) countBlock(0);
    }];
}

// MARK: 管理购物车
- (void)manageShopCarWithDict:(NSDictionary *)dict success:(shoppingCarSuccessBlock)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure{
    [[ECRDataHandler sharedDataHandler] manageShopCarDataWithDict:dict success:^(id object) {
        NSNumber *type = dict[@"type"];
        if ([type integerValue] == 2) {
            // 删除 选中书籍
            NSLog(@"删除选中书籍");
        }
        if ([type integerValue] == 1) {
            // 添加购物车
            
        }
        NSLog(@"管理购物车 -- %@",object);
        [self deleteWithEmpty:nil success:success];
//        if (success) {
//            success(nil,nil,0);
//        }
        
    } failure:failure commenFailure:commenFailure];
}

// MARK: 加入购物车（将商品）
- (void)addWithModel:(ECRShoppingCarModel *)model success:(shoppingCarSuccessBlock)success{
    model.isTick = YES;
    [self.totalArray addObject:model];
    [self.tickedArray addObject:model];
    [self backSuccess:success];

}
// MARK: 删除商品
- (void)deleteWithEmpty:(emptyBlock)emptyBlock success:(shoppingCarSuccessBlock)success{
    if (self.tickedArray.count) {
        // 便利 删除模型
        for (NSInteger i = 0; i < self.tickedArray.count; ++i) {
            ECRShoppingCarModel *modelSelected = self.tickedArray[i];
            for (NSInteger j = 0; j < self.totalArray.count; ++j) {
                ECRShoppingCarModel *model = self.totalArray[j];
                if (modelSelected == model) {
                    self.totalPrice -= model.price;
                    [self.totalArray removeObject:model];
                }
            }
        }
        
        [self.tickedArray removeAllObjects];
        self.tickedArray = nil;
    }
    if (self.totalArray.count == 0) {
        [self backEmpty:emptyBlock];
    }
    [self backSuccess:success];
}

// MARK: 请求接口
- (void)loadCartDataWith:(NSObject *)anyObjcet success:(shoppingCarSuccessBlock)success failure:(ECRDataHandlerFailure)failure commenFailure:(ECRDataHandlerCommenFailure)commenFailure {
    [[ECRDataHandler sharedDataHandler] shopCarDataWithSuccess:^(id object) {
        NSArray *array = object;
        if (_totalArray.count) {
            [_totalArray removeAllObjects];
            _totalArray = nil;
            _totalPrice = 0;
            [_tickedArray removeAllObjects];
            _tickedArray = nil;
        }
        if (array != nil) {
            for (NSInteger i = 0; i < array.count; i++) {}
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ECRShoppingCarModel *model = [ECRShoppingCarModel mj_objectWithKeyValues:obj];
                [self.totalArray addObject:model];
            }];
            [self backSuccess:success];
        }else{
            
        }
    } failure:failure commenFailure:commenFailure];
}

// MARK: 选中 & 取消选中
- (void)selectedOrUnselectedWithModel:(ECRShoppingCarModel *)model success:(shoppingCarSuccessBlock)success allsCancel:(emptyBlock)allsCancel{
    NSLog(@"购物车管理者model -- %@ -- %@",model,model.bookName);
    if (model.isTick) {
        model.isTick = NO;
        [self.tickedArray removeObject:model];
        // MARK: 修改总价(-)
        self.totalPrice -= model.price;
    }else{
        model.isTick = YES;
        [self.tickedArray addObject:model];
        // MARK: 修改总价(+)
        self.totalPrice += model.price;
    }
    
    if (self.tickedArray.count == 0) {
        _totalPrice = 0;
        self.tickedArray = nil;
        [self backEmpty:allsCancel];
    }
    [self.totalArray enumerateObjectsUsingBlock:^(ECRShoppingCarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       NSLog(@"数组模型model (%@) -- %@ ++ %d",obj,obj.bookName,obj.isTick);
    }];
    NSLog(@"totalprice -- %f",_totalPrice);
    [self backSuccess:success];
}

// MARK: 点击全选
- (void)clickSelectAllSuccess:(shoppingCarSuccessBlock)success allsCancel:(emptyBlock)allsCancel{
    if (self.totalArray.count == 0) {
        // 当购物车没有任何数据时 执行
        [self backEmpty:allsCancel];
    }else{
        // 1.将未选中的商品选中
        // 2.计算总价
        if (self.tickedArray.count > 0 && self.tickedArray.count < self.totalArray.count) {
            // 部分选中时执行
            [self.tickedArray removeAllObjects];
            _tickedArray = nil;
            self.tickedArray = [NSMutableArray arrayWithArray:self.totalArray.copy];
            _totalPrice = 0;
            for (NSInteger i = 0; i < self.tickedArray.count; ++i) {
                ECRShoppingCarModel *model = self.tickedArray[i];
                model.isTick = YES;
                _totalPrice += model.price;
            }
            
        }else if(self.tickedArray.count == self.totalArray.count){
            // 全部选中时执行
            [self.tickedArray removeAllObjects];
            _tickedArray = nil;
            for (NSInteger i = 0; i < self.totalArray.count; ++i) {
                ECRShoppingCarModel *model = self.totalArray[i];
                model.isTick = NO;
                _totalPrice += model.price;
            }
            _totalPrice = 0;
        }else{
            // 全部未选中时执行
            self.tickedArray = [NSMutableArray arrayWithArray:self.totalArray.copy];
            _totalPrice = 0;
            for (NSInteger i = 0; i < self.tickedArray.count; ++i) {
                ECRShoppingCarModel *model = self.tickedArray[i];
                model.isTick = YES;
                _totalPrice += model.price;
            }
        }
        [self backSuccess:success];
    }
}

- (void)backSuccess:(shoppingCarSuccessBlock)success{
    if (success) {
        success(self.totalArray,self.tickedArray,self.totalPrice);
    }
}
- (void)backEmpty:(emptyBlock)empty{
    if (empty) {
        empty();
    }
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    
    return instance;
}

- (NSMutableArray<ECRShoppingCarModel *> *)totalArray{
    if (_totalArray == nil) {
        _totalArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _totalArray;
}
- (NSMutableArray<ECRShoppingCarModel *> *)tickedArray{
    if (_tickedArray == nil) {
        _tickedArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _tickedArray;
}

@end


//// test数据
//if (_totalArray == nil) {
//    for (NSInteger i = 0; i < 10; ++i) {
//        ECRShoppingCarModel *model = [[ECRShoppingCarModel alloc] init];
//        model.isTick = arc4random_uniform(2);
//        model.bName = @"Swift高级编程";
//        model.bAuthor = @"克里斯拉特纳";
//        model.cover = @"http://img0.imgtn.bdimg.com/it/u=3377718423,1879905595&fm=11&gp=0.jpg";
//        model.money = 10;//arc4random_uniform(50);// 随机价格
//        [self.totalArray addObject:model];
//        if (model.isTick) {
//            [self.tickedArray addObject:model];
//            _totalPrice += model.money;
//        }
//    }
//}else{
//    // 默认全选
//    self.tickedArray = [NSMutableArray arrayWithArray:self.totalArray.copy];
//    _totalPrice = 0;
//    for (NSInteger i = 0; i < self.tickedArray.count; ++i) {
//        ECRShoppingCarModel *model = self.tickedArray[i];
//        _totalPrice += model.money;
//    }
//}
//[self backSuccess:success];

