//
//  TCMyCollectionViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyCollectionViewController.h"
#import "TCMyCollectionViewCell.h"
#import "TCMyBookrackFlowLayout.h"
#import "TCMyBookrackEditViewController.h"
#import "TCMyBookrackModel.h"
#import "BookDownloadProgressv.h"
#import "LGReadManager.h"

@interface TCMyCollectionViewController ()<
UIGestureRecognizerDelegate,
BookDownloadProgressvDelegate>
@property (strong,nonatomic) LGReadManager *readManager;

@end

@implementation TCMyCollectionViewController

@synthesize flowLayout = _flowLayout;
//@synthesize collectionView = _collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)longPressToDo:(UILongPressGestureRecognizer *)gestureRecognizer {
//    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
//        return;
//    }
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        
        /// 并选中 当前 index 的 cell
        TCMyBookrackEditViewController *editvc = TCMyBookrackEditViewController.new;
        editvc.pushWay = LGBaseViewControllerPushWayModal;
        editvc.longPressIndex = indexPath;
        editvc.array = self.array;
        [self presentViewController:editvc animated:YES completion:^{
            /// 取消当前正在进行的下载请求
            for (TCMyBookrackModel *model in self.array) {
                [model cancelDownload];
            }
        }];
    }
}

- (void)configUI{
    
    _readManager = [LGReadManager.alloc init];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [self.collectionView registerNib:[UINib nibWithNibName:myCollectionCell bundle:nil] forCellWithReuseIdentifier:myCollectionCell];
    [self.collectionView registerClass:[TCMyCollectionViewCell class] forCellWithReuseIdentifier:myCollectionCell];
    
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    longPressGr.delegate = self;
    longPressGr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:longPressGr];
    
    /// testcode
    NSMutableArray *arrmu = NSMutableArray.new;
    for (NSInteger i = 0; i < 10; i++) {
        TCMyBookrackModel *model = TCMyBookrackModel.new;
        if (i % 2 == 1) {
            model.resourceType = LGBookResourceTypeEpub;
            /// 测试书籍路径: epub
            NSString *epubPath = [NSBundle.mainBundle pathForResource:@"测试书籍01" ofType:@"epub"];
            model.localFilePath = epubPath;
            
        }else{
            model.resourceType = LGBookResourceTypePDF;
            /// 测试书籍路径 pdf
            NSString *pdfPath = [NSBundle.mainBundle pathForResource:@"测试书籍02" ofType:@"pdf"];
            model.localFilePath = pdfPath;
            
        }
        model.ds = TCMyBookDownloadStateEd;
        [arrmu addObject:model];
    }
    self.array = arrmu.copy;
    [self.collectionView reloadData];

    
}

#pragma mark - delegate
- (void)bdsView:(BookDownloadProgressv *)view beginDownloadWithModel:(TCMyBookrackModel *)model{
    NSLog(@"点击下载_%ld,下载路径:%@",model.ds,model.localFilePath);
    
    /// MARK: 改变下载状态
    [model changeDownloadStateWithCurrentState:model.ds progress:^(CGFloat progress) {
        /// 2.设置view 的显示 进度
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if (progress == 100.0) {
                model.ds = TCMyBookDownloadStateEd;
                view.model = model;
                // MARK: 下载成功,刷新UI
                NSInteger cellIndex = [self.array indexOfObject:model];
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:cellIndex inSection:0]]];
            }
            view.progress = progress;
        }];
    } failure:^(NSError * _Nonnull error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            model.ds = TCMyBookDownloadStateNot;
            view.model = model;
            /// TODO: 下载失败,提示
        }];
    }];
    view.model = model;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TCMyBookrackModel *model = self.array[indexPath.item];
    
    TCMyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:myCollectionCell forIndexPath:indexPath];
    
    cell.model = model;
    cell.progressv.delegate = self;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TCMyBookrackModel *model = self.array[indexPath.item];
    
    [_readManager openBookWithModel:model vc:self];
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = TCMyBookrackFlowLayout.new;
    }
    return _flowLayout;
}


@end
