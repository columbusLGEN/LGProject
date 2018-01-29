//
//  DBPlayer.h
//
//  Copyright 2014-2016 CloudMedia - Retech Corp All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/glext.h>

static const NSString *SDKVERSION = @"3.6.51.40";

@protocol DBPlayerDelegate;

@interface DBPlayer : UIViewController {
    NSMutableArray *appImageList;
    bool _hideAppLayer;
}

@property (nonatomic, assign) id <DBPlayerDelegate> delegate;

//bookPath：书籍本地路径，  contentUrl：远程更新书籍源地址（可选）
//contentUrl, 例如:"http://123.123.123.123/content01/"
- (BOOL)openABook:(NSString *)bookPath contentUrl:(NSString *)contentUrl;

//bookPath：书籍本地路径，  contentUrl：远程更新源地址（可选）  writePath：针对单行本打包，书籍只能放在可读不可写的bundle位置时提供的参数（可选）
- (BOOL)openABook:(NSString *)bookPath writePath:(NSString *)writePath contentUrl:(NSString *)contentUrl;

#pragma mark scorm相关
//获取总的页码数
- (NSInteger)getTotalNumberOfPages;

//获取当前页码索引
- (NSInteger)getCurrentPageIndex;

//页码跳转 超出边界的Index回到边界值
- (void)skipToPage:(NSInteger)pageIndex andScene:(NSInteger)sceneIndex;

//标记是否全本书的最后一个场景
- (BOOL)isLastSence;

//工具条 enable/disable
- (void)setMenuBar:(BOOL)enable;

#pragma mark 与AppDelegate相关
- (NSInteger)supportedInterfaceOrientations:(NSInteger (^) (void))defaultOrientations;

@end

@protocol DBPlayerDelegate <NSObject>

@required
//退出阅读界面
- (void)dbPlayerDidClosed;

@optional
//sd发生错误时的代理
- (void)dbPlayerErrorOccured:(NSError *)error;

//问题回答的json回传数据
- (void)questionsAnswerJsonDataString:(NSString *)jsonDataString;

@end


