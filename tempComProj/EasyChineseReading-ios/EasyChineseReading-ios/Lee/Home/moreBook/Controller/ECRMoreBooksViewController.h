//
//  ECRMoreBooksViewController.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

static NSString *reuserID       = @"ECRMoreBooksCell";
static NSString *rHeadID        = @"ECRBookClassSortHeader";// 销量，好评，价格
static NSString *rFooterID      = @"ECRMoreBooksFooterView";

#import "ECRBaseViewController.h"
@class ECRClassSortModel,ECRSearchTitleView,ECRSeriesModel;

typedef NS_ENUM(NSUInteger, ECRMoreBookListType) {
    ECRMoreBookListTypeHotSeal = 1,// 热销
    ECRMoreBookListTypeInterText,// 互动教材
    ECRMoreBookListTypeChineseReading,// 汉语读物
    ECRMoreBookListTypeCultureReading// 文化读物
};
// 这里的type需要 与 bookTotalClass 和 moreBooksModified 中的数据的classType一致


/**
    控制器打开方式

 - ECRMoreBookOpenTypeDefault: 默认
 - ECRMoreBookOpenTypeAccess: 授权
 */
typedef NS_ENUM(NSUInteger, ECRMoreBookOpenType) {
    ECRMoreBookOpenTypeDefault = 1,
    ECRMoreBookOpenTypeAccess,
};

@interface ECRMoreBooksViewController : ECRBaseViewController<
UITableViewDelegate,
UITableViewDataSource
>

/** 跳转类型 */
@property (assign,nonatomic) ECRMoreBookOpenType openType;

/** 是否显示空数据 footer (YES = 显示) */
@property (assign,nonatomic) BOOL displayFooter;

/**
 datakey:
     esb  --  汉语读物
     inb  --  互动教材
     cub  --  文化读物
 */
//@property (copy,nonatomic) NSString *dataKey;
@property (strong,nonatomic) ECRClassSortModel *classModel;//
@property (strong,nonatomic) ECRSeriesModel *serialModel;//
@property (assign,nonatomic) ECRMoreBookListType bookListType;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *array;

@property (strong,nonatomic) NSMutableArray *bookClassIds;//
@property (strong,nonatomic) NSMutableArray *array_all;// "全部" 模型数组
@property (strong,nonatomic) NSMutableArray *xilie;//

@property (assign,nonatomic) NSInteger requestLength;//
@property (assign,nonatomic) NSInteger requestPage;//
@property (assign,nonatomic) NSInteger requestSort;//

/** 搜索内容 */
@property (copy,nonatomic) NSString *searchName;

// 需要子类继承的方法
// 设置顶部搜索框
- (void)replaceTitleViewForSearch;
// 设置导航栏右侧搜索按钮
- (void)setNavRighSearchItem;
// 重写cell
- (UITableViewCell *)reTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
// 重写 table 选中方法
- (void)reTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

// 留给继承界面修改界面
- (void)setSubView;
- (void)loadFilterData;
// 装载顶部筛选条件的数据
- (void)setFilterData;
- (void)loadLisytData;
- (void)loadMoreListData;
- (void)setFilterObject:(NSInteger)classModelId forKey:(NSInteger)modelRow;
- (id)objectForFilterDictWithKey:(NSInteger)number;
/** 返回网络请求的接口 */
- (NSString *)netInterface;

@property (strong,nonatomic) ECRSearchTitleView *stv;//

@end
