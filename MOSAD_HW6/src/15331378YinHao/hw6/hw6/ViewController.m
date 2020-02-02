//
//  ViewController.m
//  hw6
//
//  Created by student5 on 2019/11/13.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
static NSString *const ID = @"cell";
static BOOL useGCD = YES;

@interface ViewController () <UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark UI设置

- (void)setupUI {
    //设置背景色
    self.view.backgroundColor = [UIColor systemGray6Color];
    //设置标题
    [self.navigationItem setTitle:@"Pictures"];
    //设置tableview
    [self setupPicTableView];
    //设置底部按钮
    [self setupBtns];
}
//底部按钮
- (void)setupBtns {
    float selfWidth = self.view.bounds.size.width;
    float selfHeight = self.view.bounds.size.height;
    //设置底部按钮
    CGFloat btnViewHeight = 80;
    UIView *buttomBtnContainer = [[UIView alloc]initWithFrame:CGRectMake(0, selfHeight-btnViewHeight, selfWidth, btnViewHeight)];
    _btns = [[NSMutableArray alloc]init];
    float margins = 20;
    float btnWidth = (selfWidth - 80)/3;
    NSArray *btnTitles = @[@"加载",@"清空",@"删除缓存"];
    for(int i = 0; i < 3; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+i*(margins+btnWidth), 15, btnWidth, 40)];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor systemGreenColor]];
        btn.layer.cornerRadius = 10;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnsClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btns addObject:btn];
        [buttomBtnContainer addSubview:btn];
    }
    buttomBtnContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttomBtnContainer];
}

-(void)setupPicTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 80)];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    //1.设置行高
    tableView.rowHeight = 300;
    //2.去掉分割线
    [tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //3.设置背景色
    tableView.backgroundColor = [UIColor systemGray6Color];
    //4.禁止点击
    tableView.allowsSelection=NO;
    _tableView = tableView;
    // cell注册
    [tableView registerClass:[TableViewCell class] forCellReuseIdentifier:ID];
}


#pragma mark 点击事件
- (void)btnsClicked:(UIButton *)btn{
    NSLog(@"%@",btn.titleLabel.text);
    switch (btn.tag) {
        case 0:
            [self loadBtnClicked];
            break;
        case 1:
            [self clearBtnClicked];
            break;
        case 2:
            [self clearImageCache];
            break;
    }
}

- (void)loadBtnClicked{
    if(_dataSource.count == 0){
        for(int i = 0; i < 5; i++){
            //若缓存中存在这张图片
            if([self imageIndexExistsAtCache:i]){
                //则直接取出使用
                [self.dataSource addObject:[self getImageFromCache:i]];
            }else{
                //否则先使用loading图，并调用get方法往缓存中下载图片
                [self.dataSource addObject:[UIImage imageNamed:@"loading.png"]];
                if(useGCD){
                    [self getImageFromWeb_GCD:i];
                }else{
                    [self getImageFromWeb_NSO:i];
                }
            }
        }
        //刷新tableview
        [self.tableView reloadData];
    }
}

- (void)clearBtnClicked{
    [_dataSource removeAllObjects];
    //刷新tableview
    [self.tableView reloadData];
}

#pragma mark tableView代理
//返回item数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 先从缓存中找，如果没有再创建
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        
    }
    cell.imgView.image = _dataSource[indexPath.row];
    //[cell.imgView setBackgroundColor:[UIColor redColor]];
    //cell.btn.titleLabel.text = _dataSource[indexPath.row];
    //[cell.btn setTitle:_dataSource[indexPath.row] forState:UIControlStateNormal];
    //[cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
}

/**
 *  数据源懒加载
 */
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark 基于NSOperation的多线程
- (void)getImageFromWeb_NSO:(int)index {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadPicToCache:) object:[NSNumber numberWithInt:index]];
        [operationQueue addOperation:op];
}

- (void) downloadPicToCache:(NSNumber *) index {
    NSArray *urls_str = @[@"https://hbimg.huabanimg.com/d8784bbeac692c01b36c0d4ff0e072027bb3209b106138-hwjOwX_fw658",
                          @"https://hbimg.huabanimg.com/6215ba6f9b4d53d567795be94a90289c0151ce73400a7-V2tZw8_fw658",
                          @"https://hbimg.huabanimg.com/834ccefee93d52a3a2694535d6aadc4bfba110cb55657-mDbhv8_fw658",
                          @"https://hbimg.huabanimg.com/f3085171af2a2993a446fe9c2339f6b2b89bc45f4e79d-LacPMl_fw658",
                          @"https://hbimg.huabanimg.com/e5c11e316e90656dd3164cb97de6f1840bdcc2671bdc4-vwCOou_fw658"];
    NSURL *url = [NSURL URLWithString:urls_str[[index intValue]]];
    //通过对应的url下载index的图片
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    //放入datasource，更新UI
    _dataSource[[index intValue]] = image;
    //[self.tableView reloadData];
    //tableview只能在主线程更新
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    //更新完UI之后，才存入缓存
    NSLog(@"Download pic%@ to cache",index);
    [self saveImageToCache:image picIndex:[index intValue]];
}

#pragma mark 基于GCD的多线程
- (void)getImageFromWeb_GCD:(int)index{
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("tag", DISPATCH_QUEUE_CONCURRENT);
    // 创建异步执行任务
    dispatch_async(queue,^{
        NSLog(@"GCD downloading pic%d ...",index);
        NSArray *urls_str = @[@"https://hbimg.huabanimg.com/d8784bbeac692c01b36c0d4ff0e072027bb3209b106138-hwjOwX_fw658",
                              @"https://hbimg.huabanimg.com/6215ba6f9b4d53d567795be94a90289c0151ce73400a7-V2tZw8_fw658",
                              @"https://hbimg.huabanimg.com/834ccefee93d52a3a2694535d6aadc4bfba110cb55657-mDbhv8_fw658",
                              @"https://hbimg.huabanimg.com/f3085171af2a2993a446fe9c2339f6b2b89bc45f4e79d-LacPMl_fw658",
                              @"https://hbimg.huabanimg.com/e5c11e316e90656dd3164cb97de6f1840bdcc2671bdc4-vwCOou_fw658"];
        NSURL *url = [NSURL URLWithString:urls_str[index]];
        //通过对应的url下载index的图片
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        //放入datasource，更新UI
        self->_dataSource[index] = image;
        //[self.tableView reloadData];
        //tableview只能在主线程更新
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        //更新完UI之后，才存入缓存
        NSLog(@"Download pic%d to cache",index);
        [self saveImageToCache:image picIndex:index];
    });
}

#pragma mark 缓存
//保存图片到缓存
- (void)saveImageToCache:(UIImage *)image picIndex:(NSInteger) index{
    //获取cache路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //文件操作
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"pic%ld.png",(long)index]];
    if([fileManager fileExistsAtPath:filePath]){
        NSLog(@"File %@ is already saved.",filePath);
    }else{
        //创建图片
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    }
}
//判断编号为i的图片是否在缓存中
- (BOOL)imageIndexExistsAtCache:(NSInteger) index{
    //获取cache路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //文件操作
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"pic%ld.png",(long)index]];
    if([fileManager fileExistsAtPath:filePath]){
        return YES;
    }else{
        return NO;
    }
}
//清空缓存
- (void)clearImageCache{
    //获取cache路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //文件操作
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for(int i = 0; i < 5; i++){
        NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"pic%ld.png",(long)i]];
        if([fileManager fileExistsAtPath:filePath]){
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
}
//从缓存中取出指定图片
- (UIImage *)getImageFromCache:(NSInteger) index{
    //获取cache路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //文件操作
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"pic%ld.png",(long)index]];
    if([fileManager fileExistsAtPath:filePath]){
        return [UIImage imageWithContentsOfFile:filePath];
    }else{
        return nil;
    }
}

@end
