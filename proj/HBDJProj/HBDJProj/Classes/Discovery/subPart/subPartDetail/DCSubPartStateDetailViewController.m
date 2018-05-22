//
//  DCSubPartStateDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateDetailViewController.h"
#import "LGThreeRightButtonView.h"
#import "DCStateCommentsTableViewCell.h"
#import "DCStateCommentsModel.h"
#import "DCStateContentsCell.h"

#import "LGHTMLParser.h"
#import "NSAttributedString+Extension.h"

#import "DCRichTextTopInfoView.h"
#import "DCRichTextBottomInfoView.h"

static const CGFloat richTextTopInfoViewHeight = 100;
static const CGFloat richTextBottomInfoViewHeight = 77;

@interface DCSubPartStateDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
DTAttributedTextContentViewDelegate,
DTLazyImageViewDelegate>
@property (strong,nonatomic) LGThreeRightButtonView *bottom;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray * array;

@property (strong,nonatomic) NSAttributedString *contentString;

/** 缓存core text cell */
@property (strong,nonatomic) NSCache *cellCache;
/** 图片尺寸缓存 */
@property (nonatomic, strong) NSCache *imageSizeCache;

@end

@implementation DCSubPartStateDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottom];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.bottom.mas_top);
        make.right.equalTo(self.view.mas_right);
    }];
    
    CGFloat bottomHeight = 50;
    if ([LGDevice isiPhoneX]) {
        bottomHeight = 70;
    }
    [self.bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    /// 注册键盘相关通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    NSString *str = @"爱琴海";
    NSMutableArray *arrMu = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        DCStateCommentsModel *model = [DCStateCommentsModel new];
        model.nick = [NSString stringWithFormat:@"阿明_%d",i];
        int strCount = arc4random_uniform(50) + 1;
        NSMutableString *string = [NSMutableString string];
        for (int j = 0; j < strCount; j++) {
            [string appendString:str];
        }
        model.content = string;
        [arrMu addObject:model];
    }
    self.array = arrMu.copy;
    [self.tableView reloadData];
    
    _imageSizeCache = [[NSCache alloc] init];
    _cellCache = [[NSCache alloc] init];
    _cellCache.totalCostLimit = 10;
    _cellCache.countLimit = 10;
    
}
#pragma mark - delegate & data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [self tableView:tableView prepareCellForIndexPath:indexPath];
    }
    DCStateCommentsModel *model = _array[indexPath.row - 1];
    DCStateCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DCStateContentsCell *cell = [self tableView:tableView prepareCellForIndexPath:indexPath];
        /// TODO: 富文本的高度 + 品论(x) 的高度
        return [cell requiredRowHeightInTableView:tableView] + richTextBottomInfoViewHeight;
    }
    DCStateCommentsModel *model = _array[indexPath.row - 1];
    return [model cellHeight];
}

- (DCStateContentsCell *)tableView:(UITableView *)tableView prepareCellForIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"dcSubPartyCoreTextCell_%ld_%ld",indexPath.section,indexPath.row];
    DCStateContentsCell *cell = [_cellCache objectForKey:key];
    
    if (!cell) {
        cell = [[DCStateContentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentCell];
        cell.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(richTextTopInfoViewHeight, marginFifteen, 0, marginFifteen);
        cell.hasFixedRowHeight = NO;
        cell.textDelegate = self;
        cell.attributedTextContextView.shouldDrawImages = YES;
        
        [_cellCache setObject:cell forKey:key];
        
        /// MARK: 富文本cell顶部信息view
        DCRichTextTopInfoView *topInfoView = [DCRichTextTopInfoView richTextTopInfoView];
        [cell.contentView addSubview:topInfoView];
        [topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top);
            make.left.equalTo(cell.mas_left);
            make.right.equalTo(cell.mas_right);
            make.height.mas_equalTo(richTextTopInfoViewHeight);
        }];
        
        /// MARK: 富文本cell底部信息view
        DCRichTextBottomInfoView *infoView = [DCRichTextBottomInfoView richTextBottomInfo];
        [cell.contentView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.right.equalTo(cell.mas_right);
            make.bottom.equalTo(cell.mas_bottom).offset(-marginEight);
            make.height.mas_equalTo(richTextBottomInfoViewHeight);
        }];
        
        [cell.contentView bringSubviewToFront:infoView];
    }
    
    /// TODO: 设置富文本数据
    [cell setHTMLString:[[[LGHTMLParser alloc] init] HTMLStringWithPlistName:@"detaiTtest"]];
    
    /// 为每个占位图设置大小
    for (DTTextAttachment *oneAttachment in cell.attributedTextContextView.layoutFrame.textAttachments) {
        NSValue *sizeValue = [_imageSizeCache objectForKey:oneAttachment.contentURL];
        if (sizeValue) {
            cell.attributedTextContextView.layouter = nil;
            oneAttachment.displaySize = [sizeValue CGSizeValue];
            [cell.attributedTextContextView relayoutText];
        }
    }
    [cell.attributedTextContextView relayoutText];
    return cell;
}
#pragma mark - DTAttributedTextContentViewDelegate
//对于没有在Html标签里设置宽高的图片，在这里为其设置占位
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame{
    if([attachment isKindOfClass:[DTImageTextAttachment class]]){
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        
        imageView.delegate = self;
        
        // sets the image if there is one
        imageView.image = [(DTImageTextAttachment *)attachment image];
        
        // url for deferred loading
        imageView.url = attachment.contentURL;
        
        imageView.contentView = attributedTextContentView;
    
        return imageView;
    }
    return nil;
}

#pragma mark - DTLazyImageViewDelegate
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size{
    BOOL needUpdate = NO;
    NSURL *url = lazyImageView.url;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    for (DTTextAttachment *oneAttachment in [lazyImageView.contentView.layoutFrame textAttachmentsWithPredicate:pred]){
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero)){
            oneAttachment.originalSize = size;
            NSValue *sizeValue = [_imageSizeCache objectForKey:oneAttachment.contentURL];
            if (!sizeValue) {
                //将图片大小记录在缓存中，但是这种图片的原始尺寸可能很大，所以这里设置图片的最大宽
                //并且计算高
                CGFloat aspectRatio = size.height / size.width;
                CGFloat width = kScreenWidth - 100;
                CGFloat height = width * aspectRatio;
                CGSize newSize = CGSizeMake(width, height);
                [_imageSizeCache setObject:[NSValue valueWithCGSize:newSize]forKey:url];
            }
            needUpdate = YES;
        }
    }

    if (needUpdate) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }
    
}

#pragma mark - notifications
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    /// TODO: 为什么键盘的起始frame 异常？
    NSLog(@"frameBegin -- %@ ",NSStringFromCGRect(frameBegin));
    //    NSLog(@"frameEnd -- %@",NSStringFromCGRect(frameEnd));
    CGFloat offsetY = frameBegin.origin.y - frameEnd.origin.y;
    NSLog(@"willchangeframe.y -- %f",offsetY);
}
- (void)keyboardDidChangeFrame:(NSNotification *)notification{
    //    NSDictionary *userInfo = notification.userInfo;
    //    CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //    CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    NSLog(@"frameBegin -- %@ ",NSStringFromCGRect(frameBegin));
    //    NSLog(@"frameEnd -- %@",NSStringFromCGRect(frameEnd));
    //    CGFloat offsetY = frameEnd.origin.y - frameBegin.origin.y;
    //    NSLog(@"didchangeframe.y -- %f",offsetY);
}


#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.estimatedRowHeight = 80;/// 该值不给也行
        [_tableView registerClass:[DCStateContentsCell class] forCellReuseIdentifier:contentCell];
        [_tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
        
    }
    return _tableView;
}
- (LGThreeRightButtonView *)bottom{
    if (!_bottom) {
        _bottom = [LGThreeRightButtonView new];
        _bottom.bothSidesClose = YES;
        [_bottom setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_like_normal",
                                        TRConfigSelectedImgNameKey:@"dc_like_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_6CBEFC]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                        TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_FDBF2D]
                                        },
                                      @{TRConfigTitleKey:@"99+",
                                        TRConfigImgNameKey:@"dc_discuss_normal",
                                        TRConfigSelectedImgNameKey:@"dc_discuss_selected",
                                        TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                        TRConfigTitleColorSelectedKey:[UIColor EDJColor_CEB0E7]
                                        }]];
    }
    return _bottom;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
