//
//  EDJLevelInfoViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJLevelInfoViewController.h"
#import "EDJLeverInfoHeaderView.h"

static CGFloat headerHeight = 345;

@interface EDJLevelInfoViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
EDJLeverInfoHeaderViewDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSArray *array;

@end

@implementation EDJLevelInfoViewController

static NSString * const reuseIdentifier = @"EDJLevelInfoCollectionViewCell";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"我的等级";
    
    /// 修改标题颜色
    //    [self.navigationController.navigationBar setBarTintColor:UIColor.whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI{
    
    /// MARK: 设置导航栏透明
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:UIImage.new];
    
    /// 设置背景图片
    UIView *bg = [[UIView alloc] initWithFrame:self.view.bounds];
    bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"uc_icon_level_info_bg"]];
    [self.view addSubview:bg];
    
    EDJLeverInfoHeaderView *header = [EDJLeverInfoHeaderView levelInfoHeader];
    header.frame = CGRectMake(0, 0, kScreenWidth - 20, headerHeight);
    header.delegate = self;
    [self.collectionView addSubview:header];
    
    [self.view bringSubviewToFront:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    _array = [EDJLevelInfoModel loadLocalPlistWithPlistName:@"LevelBonusRules"];
    [self.collectionView reloadData];
    
    [DJUserNetworkManager.sharedInstance frontIntegralGrade_selectIntegralSuccess:^(id responseObj) {
        
    } failure:^(id failureObj) {
        
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EDJLevelInfoModel *model = _array[indexPath.row];
    EDJLevelInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = model;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark - EDJLeverInfoHeaderViewDelegate
- (void)levelInfoHeaderCLick:(EDJLeverInfoHeaderView *)header itemTag:(NSInteger)tag{
    
    if (tag == 0) {
        /// 今日加分 EDJTodayScoreViewController
        [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName
                                        controllerId:@"EDJTodayScoreViewController"
                                            animated:YES];
        
    }else if (tag == 1){
        /// 等级介绍
        [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName
                                        controllerId:@"EDJLevelInsTableViewController"
                                            animated:YES]; 
    }
}

@end

@implementation EDJLevelInfoModel


@end

@interface EDJLevelInfoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *unit;

@property (weak, nonatomic) IBOutlet UILabel *bonus;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *upperLimit;


@end

@implementation EDJLevelInfoCollectionViewCell

- (void)setModel:(EDJLevelInfoModel *)model{
    _model = model;
    _itemTitle.text = model.itemTitle;
    _rate.text = model.rate.stringValue;
    _unit.text = model.unit;
    _bonus.text = model.score.stringValue;
    _upperLimit.text = [NSString stringWithFormat:@"每日上限%@分",model.upperLimit];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [_container cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:10];
    [_container setShadowWithShadowColor:[UIColor EDJMainColor] shadowOffset:CGSizeMake(2,2) shadowOpacity:0.5 shadowRadius:5];
}
@end

