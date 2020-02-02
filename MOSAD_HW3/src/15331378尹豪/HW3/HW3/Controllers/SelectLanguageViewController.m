//
//  selectLanguageViewController.m
//  HW3
//
//  Created by student5 on 2019/9/22.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "SelectLanguageViewController.h"
#import "../Views/SelectLanguageView.h"
#import "../Views/SelectLanguageCollectionViewCell.h"
#import "LearningTableViewController.h"
#import "UserViewController.h"

#pragma mark 主页面VC
@interface SelectLanguageViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *languageCollectionView;
@property (nonatomic, strong) NSArray *dataSourceTitles;
@property (nonatomic, strong) NSArray *dataSourceImgs;

@end

@implementation SelectLanguageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏nav
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //显示其他界面的nav
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)loadView{
    //创建一个selcetLanguageView对象
    SelectLanguageView *mainView = [[SelectLanguageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    //[backgroundView.btn addTarget:self action:@selector(tag) forControlEvents:UIControlEventTouchUpInside];
    //将这个对象赋给VC的view属性
    self.view = mainView;
    
    
    //collectionView
    //数据准备
    _dataSourceTitles = @[@"英语",@"德语",@"日语",@"西班牙语"];
    _dataSourceImgs = @[[UIImage imageNamed:@"English"],
                        [UIImage imageNamed:@"German"],
                        [UIImage imageNamed:@"Japanese"],
                        [UIImage imageNamed:@"Spanish"]
                        ];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.初始化collectionView
    _languageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((mainView.frame.size.width - 270) / 2.0, 340, 270, 300) collectionViewLayout:layout];
    //4.设置代理
    //selectLanguageCollectionViewController *slcvc = [[selectLanguageCollectionViewController alloc]init];
    _languageCollectionView.delegate = self;
    _languageCollectionView.dataSource = self;
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_languageCollectionView registerClass:[SelectLanguageCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [_languageCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    _languageCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_languageCollectionView];
}

#pragma mark 处理collectionView的delegates和dataSource
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"加载成功");
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SelectLanguageCollectionViewCell *cell = (SelectLanguageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    //cell.topLabel.text = [NSString stringWithFormat:@"{%ld,%ld}",(long)indexPath.section,(long)indexPath.row];
    cell.topLabel.text = _dataSourceTitles[indexPath.row];
    cell.flagImage.image = _dataSourceImgs[indexPath.row];
    //cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 100);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}


//点击item方法 跳转到对应的view
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //传递标题参数
    SelectLanguageCollectionViewCell *cell = (SelectLanguageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    LearningTableViewController *learningTableVC = [[LearningTableViewController alloc] initWithLanguage:cell.topLabel.text];
    UserViewController *userViewController = [[UserViewController alloc]init];
    
    NSString *navTitle = [NSString stringWithFormat:@"学习%@", cell.topLabel.text];
    tabBarController.navigationItem.title = navTitle;
    //设置tabBar
    tabBarController.viewControllers = @[learningTableVC, userViewController];
    //selectLanguageViewController *tester = [selectLanguageViewController new];
    //将新创建的vc压入导航栏的栈中
    [self.navigationController pushViewController:tabBarController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
