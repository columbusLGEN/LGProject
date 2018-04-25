//
//  EDJSearchViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJSearchViewController.h"
#import "LGNavSearchView.h"
/// header
#import "EDJSearchTagCollectionViewFlowLayout.h"
#import "EDJSearchTagModel.h"
#import "EDJSearchTagHistoryCell.h"
#import "EDJSearchTagHotCell.h"

#import "EDJSearchTagHeader.h"
#import "EDJSearchTagHeaderModel.h"

static NSString * const historyCell = @"EDJSearchTagHistoryCell";
static NSString * const hotCell = @"EDJSearchTagHotCell";

static NSString * const reuseHeaderID = @"EDJSearchTagHeader";
static CGFloat insetTop = 44;

@interface EDJSearchViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
LGNavSearchViewDelegate>
///UICollectionViewDelegateFlowLayout,/// 此处不遵守该协议,代理方法也能被调用,那么在哪里遵守了该协议?

@property (strong,nonatomic) LGNavSearchView *fakeNav;
@property (strong,nonatomic) UICollectionView  *collectionView;
@property (strong,nonatomic) EDJSearchTagCollectionViewFlowLayout *flowLayout;
@property (strong,nonatomic) NSArray *headerModels;
@property (strong,nonatomic) NSArray *cellModels;
@end

@implementation EDJSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.fakeNav];
    
    _headerModels = [EDJSearchTagHeaderModel loadLocalPlistWithPlistName:@"EDJSearchTagHeaderClasses"];
    [self.collectionView reloadData];
}

#pragma mark - Nav delegate
- (void)navSearchViewBack:(LGNavSearchView *)navSearchView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _headerModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    if (section == 1) {
        return 20;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EDJSearchTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[EDJSearchTagCollectionViewCell cellIdWithIndexPath:indexPath] forIndexPath:indexPath];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    EDJSearchTagHeaderModel *headerModel = _headerModels[indexPath.section];
    EDJSearchTagHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderID forIndexPath:indexPath];
    header.model = headerModel;
    return header;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 40);
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

/// MARK: lazy load
- (LGNavSearchView *)fakeNav{
    if (_fakeNav == nil) {
        _fakeNav = [[LGNavSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        _fakeNav.delegate = self;
    }
    return _fakeNav;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView setContentInset:UIEdgeInsetsMake(insetTop, 0, 0, 0)];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:reuseHeaderID bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:reuseHeaderID];
        
//        [_collectionView registerNib:[UINib nibWithNibName:reuseID bundle:nil] forCellWithReuseIdentifier:reuseID];
        [_collectionView registerNib:[UINib nibWithNibName:hotCell bundle:nil] forCellWithReuseIdentifier:hotCell];
        [_collectionView registerNib:[UINib nibWithNibName:historyCell bundle:nil]
          forCellWithReuseIdentifier:historyCell];
        
    }
    return _collectionView;
}
- (EDJSearchTagCollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [EDJSearchTagCollectionViewFlowLayout new];
    }
    return _flowLayout;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
