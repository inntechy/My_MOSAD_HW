//
//  mainViewController.m
//  hw5
//
//  Created by student5 on 2019/10/24.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "MainViewController.h"
#import "../Views/MainCollectionViewCell.h"
#import "QuizViewController.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MainViewController

- (instancetype) init{
    if(self = [super init]){
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    float selfWidth = self.view.bounds.size.width;
    //添加text区域
    _label = [[UILabel alloc] initWithFrame:CGRectMake((selfWidth - 100) / 2.0, 250, 100, 30)];
    _label.text = @"请选择题目";
    [self.view addSubview:_label];
    
    //collectionView
    //数据准备
    _dataSourceTitles = @[@"Unit1",@"Unit2",@"Unit3",@"Unit4"];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.初始化collectionView
    _selectUnitView = [[UICollectionView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 200) / 2.0, 290, 200, 350) collectionViewLayout:layout];
    //4.设置代理
    //selectLanguageCollectionViewController *slcvc = [[selectLanguageCollectionViewController alloc]init];
    _selectUnitView.delegate = self;
    _selectUnitView.dataSource = self;
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_selectUnitView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [_selectUnitView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    _selectUnitView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_selectUnitView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏nav
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
    MainCollectionViewCell *cell = (MainCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    //cell.topLabel.text = [NSString stringWithFormat:@"{%ld,%ld}",(long)indexPath.section,(long)indexPath.row];
    cell.topLabel.text = _dataSourceTitles[indexPath.row];
    //cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(200, 60);
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
    QuizViewController *quizVC = [[QuizViewController alloc] initWithUnit:indexPath.row];
    //selectLanguageViewController *tester = [selectLanguageViewController new];
    //将新创建的vc压入导航栏的栈中
    [self.navigationController pushViewController:quizVC animated:YES];
}

@end
