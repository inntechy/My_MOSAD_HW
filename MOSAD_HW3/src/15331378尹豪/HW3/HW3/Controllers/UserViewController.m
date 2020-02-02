//
//  userViewController.m
//  HW3
//
//  Created by student5 on 2019/9/24.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UITableViewDataSource, UITableViewDelegate>

@end

@implementation UserViewController

- (instancetype) init{
    if(self = [super init]){
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //设置主题色
    _themeColor = [UIColor lightGrayColor];
    //设置标签项的标题及图片
    //--------------------------------
    self.tabBarItem.title = @"用户";
    UIImage *img1 = [[UIImage imageNamed:@"user1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *img2 = [[UIImage imageNamed:@"user2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = img1;
    self.tabBarItem.selectedImage = img2;
    

    //添加圆形UIButton
    //--------------------------------
    UIView *btnField = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 270)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.center = btnField.center;
    btn.backgroundColor = _themeColor;
    btn.layer.cornerRadius = btn.bounds.size.width / 2.0;
    [btn setTitle:@"Login" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    [btnField addSubview:btn];
    [self.view addSubview:btnField];
    
    
    //添加segmentedController
    //--------------------------------
    _segmentC = [[UISegmentedControl alloc]initWithItems:@[@"用户信息",@"用户设置"]];
    _segmentC.frame = CGRectMake(0, 270, self.view.bounds.size.width, 30);
    _segmentC.tintColor = _themeColor;
    _segmentC.selectedSegmentIndex = 0;
    [_segmentC addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentC];
    
    
    //添加pageView
    //--------------------------------
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                         navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                       options:nil];
    _pageViewController.view.frame = CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height - 300);
    _pageViewController.dataSource=self;
    _pageViewController.delegate=self;
    //开始设置两个tableView
    UITableViewController *userInfo = [[UITableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UITableViewController *userSettings = [[UITableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    userInfo.tableView.scrollEnabled = NO;
    userSettings.tableView.scrollEnabled = NO;
    userInfo.view.tag = 100;
    userSettings.view.tag = 101;
    userInfo.tableView.delegate = self;
    userInfo.tableView.dataSource = self;
    userSettings.tableView.delegate = self;
    userSettings.tableView.dataSource = self;
    [userInfo.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [userSettings.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    //将以上两个页面放入Array中
    _pageContentArray = @[userInfo, userSettings];
    //设置初始界面
    NSArray *array = @[_pageContentArray[0]];
    [_pageViewController setViewControllers:array direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    [self.view addSubview:_pageViewController.view];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置navTitle
    [self.parentViewController.navigationItem setTitle:@"个人档案"];
}

#pragma mark pageView相关内容
//翻页控制器进行向前翻页动作 这个数据源方法返回的视图控制器为要显示视图的视图控制器
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfViewInArray:viewController];
    if (index==0) {
        return nil;
    }else{
        return _pageContentArray[index-1];
    }
}
//翻页控制器进行向后翻页动作 这个数据源方法返回的视图控制器为要显示视图的视图控制器
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfViewInArray:viewController];
    if (index==1) {
        return nil;
    }else{
        return _pageContentArray[index+1];
    }
}
//返回传入的vc在数组中的index
- (NSInteger)indexOfViewInArray:(UIViewController *)thisVC{
    return [_pageContentArray indexOfObject:thisVC];
}
//翻页成功后调用
//设置segmentedControl的显示
- (void)pageViewController:(UIPageViewController *)pageViewController
didFinishAnimating:(BOOL)finished previousViewControllers:(nonnull NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    //暂时没想到更加合理的实现，这种实现方式只能用于两个标签页的时候。
    if(completed){
        NSInteger index = [self indexOfViewInArray:previousViewControllers[0]];
        _segmentC.selectedSegmentIndex = (index + 1) % 2;
    }
}

#pragma mark 处理tableView
// tableView 中 Section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

// 每个 Section 中的 Cell 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return 2;
}

// 设置每个 Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView.tag == 100){
        // 创建一个cellID，用于cell的重用
        NSString *cellID = @"userInfoCellID";
        // 从tableview的重用池里通过cellID取一个cell
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            // 如果tableview的重用池中没有取到，就创建一个新的cell，style为Value2，并用cellID对其进行标记。
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        if(indexPath.row == 0){
            cell.textLabel.text = @"用户名";
            cell.detailTextLabel.text = @"未登录";
        }
        if(indexPath.row == 1){
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = @"未登录";
        }
    }
    if(tableView.tag == 101){
        // 创建一个cellID，用于cell的重用
        NSString *cellID = @"userSettingsCellID";
        // 从tableview的重用池里通过cellID取一个cell
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            // 如果tableview的重用池中没有取到，就创建一个新的cell，style为Value2，并用cellID对其进行标记。
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        if(indexPath.row == 0){
            cell.textLabel.text = @"返回语言选择";
        }
        if(indexPath.row == 1){
            cell.textLabel.text = @"退出登录";
        }
    }
    return cell;
}

//处理点击事件
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag == 101){
        switch (indexPath.row) {
            case 0:{
                NSArray *viewControllers = self.parentViewController.navigationController.viewControllers;
                [self.parentViewController.navigationController popToViewController:[viewControllers objectAtIndex:0] animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark 处理segmentedController点击事件
-(void)segmentValueChanged:(UISegmentedControl *)seg{
    NSInteger selectedIndex = seg.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            {
                NSArray *array = @[_pageContentArray[0]];
                [_pageViewController setViewControllers:array direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
            }
            break;
        case 1:
        {
            NSArray *array = @[_pageContentArray[1]];
            [_pageViewController setViewControllers:array direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        }
            
        default:
            break;
    }
    
}

@end
