//
//  EDJMicroPartyLessonCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessonCell.h"
#import "EDJMicroPSCellHeader.h"
#import "EDJMicroPSCellFooter.h"
#import "EDJMicroBuildCell.h"
#import "EDJMicroLessionAlbumModel.h"
#import "EDJMicroPartyLessonSubCell.h"
#import "EDJMicroPartyLessionSubModel.h"

#import "LGDidSelectedNotification.h"

static NSString * const subCellID = @"EDJMicroPartyLessonSubCell";

@interface EDJMicroPartyLessonCell ()<
UITableViewDelegate,
UITableViewDataSource>
@property (strong,nonatomic) EDJMicroPSCellHeader *header;
@property (strong,nonatomic) EDJMicroPSCellFooter *footer;
@property (strong,nonatomic) UITableView *contentTableView;

@end

@implementation EDJMicroPartyLessonCell

- (void)setModel:(EDJMicroLessionAlbumModel *)model{
    _model = model;
    _header.titleText = model.classname;
    [_contentTableView reloadData];
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self.contentView addSubview:self.header];
    [self.contentView addSubview:self.contentTableView];
    [self.contentView addSubview:self.footer];
    
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(53);
    }];
    
    /// content 每个 高度 90
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.footer.mas_top);
    }];
    
    /// footer 高度 与 header 相同
    [self.footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.header.mas_height);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
+ (CGFloat)cellHeightWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 128;
    }else{
        return 375;
    }
}

+ (NSString *)cellIdentifierWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return @"EDJMicroPartyLessonHeaderCell";
    }else {
        return @"EDJMicroPartyLessonCell";
    }
}

- (EDJMicroPSCellHeader *)header{
    if (_header == nil) {
        _header = [EDJMicroPSCellHeader new];
    }
    return _header;
}
- (EDJMicroPSCellFooter *)footer{
    if (_footer == nil) {
        _footer = [EDJMicroPSCellFooter new];
    }
    return _footer;
}
- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTableView.scrollEnabled = NO;
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
        _contentTableView.estimatedRowHeight = 90;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_contentTableView registerNib:[UINib nibWithNibName:subCellID bundle:nil] forCellReuseIdentifier:subCellID];
    }
    return _contentTableView;
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"_model.subNews.count -- %ld",_model.subNews.count);
    return _model.classlist.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroPartyLessionSubModel *model = _model.classlist[indexPath.row];
    EDJMicroPartyLessonSubCell *cell = [tableView dequeueReusableCellWithIdentifier:subCellID];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroPartyLessionSubModel *model = _model.classlist[indexPath.row];
    NSDictionary *dict = @{LGDidSelectedModelKey:model,
                           LGDidSelectedSkipTypeKey:@(LGDidSelectedSkipTypeMicrolessonSingle),
                           LGDidSelectedIndexKey:@(indexPath.row)
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:LGDidSelectedNotification object:nil userInfo:dict];
}

@end
