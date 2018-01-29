//
//  UInfoAddressViewController.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserInfoAddressVC.h"

#import "ECRSearchTitleView.h"

@interface UserInfoAddressVC () <UITableViewDelegate, UITableViewDataSource, ECRSearchTitleViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *maskView;                   // 蒙版

@property (strong, nonatomic) NSMutableArray *arrCountry;         // 国家数组
@property (strong, nonatomic) NSMutableArray *arrSearchs;         // 国家搜索结果
@property (strong, nonatomic) NSMutableArray *arrIndexTitles;     // 字母索引
@property (strong, nonatomic) NSMutableArray *arrIndexCharacter;  // 数据字典，对应索引

@property (strong, nonatomic) NSMutableDictionary *dicCountry;    // 数据源字典

@property (assign, nonatomic) BOOL isSearch;                      // 搜索结果

@end

@implementation UserInfoAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - 配置界面
- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"所在国家或地区");
}

- (void)configView
{
    [self getCountryData];
    [self setNavRighSearchItem];
}

- (void)configEmptyView
{
    // 哎呦, 没有找到你想要的
}

- (void)configAddressView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height) style:UITableViewStylePlain];
    
    _tableView.rowHeight = cHeaderHeight_44;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 配置索引相关
    _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    _tableView.sectionIndexColor = [UIColor cm_mainColor];
    _tableView.sectionIndexMinimumDisplayRowCount = 1;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

#pragma mark - 获取国家

- (void)getCountryData
{
    __block NSArray *countrys = [NSArray array];
    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] getCountrysComplention:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:LOCALIZATION(@"获取国家列表失败")];
        }
        else {
            countrys = [CountryModel mj_objectArrayWithKeyValuesArray:object];
            self.arrCountry = [NSMutableArray arrayWithArray:countrys];
            // 将国家数据排序
            [self sortArrayWithArray:self.arrCountry];

            [[CacheDataSource sharedInstance] setCache:self.arrCountry withCacheKey:CacheKey_CountryList];
            // 索引排序
            self.arrIndexCharacter = (NSMutableArray *)[_arrIndexCharacter sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2]; //升序
            }];
            
            self.isSearch = NO;
            [self configAddressView];
        }
    }];
}

#pragma mark - UITableViewDataSource

// 分段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isSearch ? 1 : _arrIndexCharacter.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNumber = 0;
    if (_isSearch) {
        rowNumber = _arrSearchs.count;
    }
    else {
        if (self.arrIndexCharacter.count > section) {
            NSMutableArray *arrayTemp = (NSMutableArray *)[self.dicCountry objectForKey:[self.arrIndexCharacter objectAtIndex:section]];
            rowNumber = arrayTemp.count;
        }
    }
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (_isSearch) {
        CountryModel *country = [_arrSearchs objectAtIndex:indexPath.row];
        cell.textLabel.text = _language == ENUM_LanguageTypeChinese ? country.zh_name : country.en_name;
    }
    else {
        if (self.arrIndexCharacter.count > indexPath.section) {
            NSMutableArray *arrayTemp = (NSMutableArray *)[self.dicCountry objectForKey:[self.arrIndexCharacter objectAtIndex:indexPath.section]];
            if (arrayTemp.count > indexPath.row) {
                CountryModel *country = [arrayTemp objectAtIndex:indexPath.row];
                cell.textLabel.text = _language == ENUM_LanguageTypeChinese ? country.zh_name : country.en_name;
            }
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch) {
        self.selectedCountryBlock(_arrSearchs[indexPath.row]);
    }
    else {
        NSMutableArray *arrayTemp = (NSMutableArray *)[self.dicCountry objectForKey:[self.arrIndexCharacter objectAtIndex:indexPath.section]];
        if (arrayTemp.count > indexPath.row) {
            CountryModel *country = [arrayTemp objectAtIndex:indexPath.row];
            [[CacheDataSource sharedInstance] setCache:country withCacheKey:CacheKey_SelectCountry];
            self.selectedCountryBlock(country);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------- 索引相关 ----------

// 处理数组，按字母排序
- (void)sortArrayWithArray:(NSArray *)array
{
    if (array) {
//        // 已经遍历过，不需要在遍历, 让排序只执行一次
//        if ((![NSString isEmpty:obj.zh_name] && _language == ENUM_LanguageTypeChinese) || (![NSString isEmpty:obj.en_name] && _language == ENUM_LanguageTypeEnglish)) {
//            *stop = YES;
//        }
        
        // 初始化数据源字典
        if (_dicCountry) {
            [self.dicCountry removeAllObjects];
            self.dicCountry = nil;
        }
        self.dicCountry = [NSMutableDictionary dictionary];
        
        if (_arrIndexCharacter) {
            [self.arrIndexCharacter removeAllObjects];
            self.arrIndexCharacter = nil;
        }
        self.arrIndexCharacter = [NSMutableArray array];
        
        // 遍历源数组 进行排序
        WeakSelf(self)
        [_arrCountry enumerateObjectsUsingBlock:^(CountryModel *country, NSUInteger idx, BOOL *stop) {
            StrongSelf(self)
            // 首字母
            NSString *firstLetter = [NSString firstLetter:_language == ENUM_LanguageTypeChinese ? country.zh_name : country.en_name];
            if ([self.dicCountry.allKeys containsObject:firstLetter]) {
                NSMutableArray *arrayTemp = (NSMutableArray *)[self.dicCountry objectForKey:firstLetter];
                if (arrayTemp) {
                    [arrayTemp addObject:country];
                }
            }
            else {
                NSMutableArray *arrayTemp = [NSMutableArray arrayWithObjects:country, nil];
                [self.dicCountry setObject:arrayTemp forKey:firstLetter];
                [self.arrIndexCharacter addObject:firstLetter];
            }
        }];
    }
}

// 索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _isSearch ? nil : _arrIndexCharacter;
}

// 滑动触发索引事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    if (!_isSearch) {
        for (NSString *character in _arrIndexCharacter) {
            if([character isEqualToString:title]) {
                return count;
            }
            count ++;
        }
    }
    return 0;
}

// 分段标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if (_isSearch)
        title = nil;
    else
        title = [NSString stringWithFormat:@"%@", [_arrIndexCharacter objectAtIndex:section]];
    
    return title;
}

#pragma mark - 搜索

// 设置导航栏右侧搜索按钮
- (void)setNavRighSearchItem {
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(countrySearch:)];
    self.navigationItem.rightBarButtonItem = search;
}

- (void)countrySearch:(id)sender {
    _isSearch = YES;
    self.maskView.hidden = NO;
    [self replaceTitleViewForSearch];
}

// 设置顶部搜索框
- (void)replaceTitleViewForSearch {
    // 设置 搜索 title view
    CGRect searchViewRect = CGRectMake(0, 0, Screen_Width, 64);
    ECRSearchTitleView *searchView = [[ECRSearchTitleView alloc] initWithFrame:searchViewRect];
    searchView.delegate            = self;
    [searchView setWhiteLine];
    WeakSelf(self)
    [UIView animateWithDuration:0.2 animations:^{
        StrongSelf(self)
        self.navigationItem.titleView = searchView;
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceBarButtonItem.width = -4;
        self.navigationItem.leftBarButtonItems = @[spaceBarButtonItem];
        [self.navigationItem setHidesBackButton:YES];
    } completion:^(BOOL finished) {
        [searchView lg_becomResponser];
    }];
}

#pragma mark - ECRSearchTitleViewDelegate

/** 设置搜索栏 */
- (void)bookSearch:(id)sender{
    [self replaceTitleViewForSearch];
}

/** 关闭搜索 */
- (void)stViewClose:(ECRSearchTitleView *)view
{
    _isSearch = NO;
    _maskView.hidden = YES;
    [self endSearching];
    [_tableView reloadData];
}

/** 结束搜索状态 */
- (void)endSearching {
    // MARK: moreCallBack.关闭搜索
    [self.view endEditing:YES];
    _maskView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationItem.titleView = nil;
    }];
    [self createNavLeftBackItem];
    [self setNavRighSearchItem];
}

#pragma mark - 搜索事件
/** 搜索 */
- (void)stView:(ECRSearchTitleView *)view content:(NSString *)content
{
    _isSearch = YES;
    _maskView.hidden = YES;
    [self searchContryWithText:content];
    [_tableView reloadData];
}

/** 根据输入的内容 搜索国家 */
- (void)searchContryWithText:(NSString *)searchText
{
    // 初始化搜索数组
    if (self.arrSearchs && self.arrSearchs.count > 0) {
        [self.arrSearchs removeAllObjects];
    }
    self.arrSearchs = [NSMutableArray array];
    
    // 加个多线程，防止数量量大的时候，有明显的卡顿现象
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        // 如果输入的文本有内容
        if (searchText != nil && searchText.length>0) {
            // 遍历需要搜索的所有内容
            for (CountryModel *country in self.arrCountry) {
                // 根据选择的语言搜索国家名
                NSMutableString *countryName = [NSMutableString stringWithFormat:@"%@", _language == ENUM_LanguageTypeChinese ? country.zh_name : country.en_name];
                // 中文
                if (_language == ENUM_LanguageTypeChinese) {
                    NSString *pinyin = [self transformToPinyin:countryName];
                    if ([pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0) {
                        // 把搜索结果存放 arrSearchs 数组
                        [self.arrSearchs addObject:country];
                    }
                }
                else {
                    // 国家名是否包括 搜索的文字
                    if ([countryName containsString:searchText] || [[countryName lowercaseString] containsString:[searchText lowercaseString]]) {
                        [self.arrSearchs addObject:country];
                    }
                }
            }
        }
        
        //回到主线程, 刷新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

/** 把所有的搜索结果转成成拼音 */
- (NSString *)transformToPinyin:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    for (int  i = 0; i < pinyinArray.count; i++) {
        for(int i = 0; i < pinyinArray.count; i++) {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
        }
        [allString appendString:@","];
        count ++;
    }
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    for (NSString *s in pinyinArray) {
        if (s.length > 0) {
            [initialStr appendString:[s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    
    return allString;
}

#pragma mark - 属性

- (UIView *)maskView
{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor cm_blackColor_000000_2F];
        [self.view addSubview:_maskView];
    }
    return _maskView;
}

- (NSMutableArray *)arrIndexCharacter
{
    if (_arrIndexCharacter == nil) {
        _arrIndexCharacter = [NSMutableArray array];
    }
    return _arrIndexCharacter;
}

- (NSMutableArray *)arrIndexTitles
{
    if (_arrIndexTitles == nil) {
        _arrIndexTitles = [NSMutableArray arrayWithArray:[NSString indexLetters]];
    }
    return _arrIndexTitles;
}

@end
