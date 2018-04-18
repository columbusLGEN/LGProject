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

@end

@implementation EDJLevelInfoViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"我的等级";
    
    /// TODO: 设置导航栏透明
//    [self.navigationController.navigationBar setTranslucent:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
//    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage new]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *bgColor = [UIColor orangeColor];
    UIView *bg = [[UIView alloc] initWithFrame:self.view.bounds];
    bg.backgroundColor = bgColor;
    [self.view addSubview:bg];
    
    /// header height 345
    EDJLeverInfoHeaderView *header = [EDJLeverInfoHeaderView levelInfoHeader];
    header.frame = CGRectMake(0, 0, kScreenWidth - 20, headerHeight);
    header.delegate = self;
    [self.collectionView addSubview:header];
    
    [self.view bringSubviewToFront:self.collectionView];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 
 }
 */


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
