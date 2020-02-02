//
//  QuizViewController.m
//  hw5
//
//  Created by student5 on 2019/10/25.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "QuizViewController.h"
#import "AFNetworking.h"
#import "ScoreViewController.h"

@interface QuizViewController ()

@end


@implementation QuizViewController

#pragma mark 初始化UI
- (instancetype) init{
    self = [self initWithUnit:2];
    return self;
}

- (instancetype) initWithUnit:(NSInteger)i{
    if(self = [super init]){
        _unitx = i;
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    float selfWidth = self.view.bounds.size.width;
    float selfHeight = self.view.bounds.size.height;
    //设置标题
    NSString *pageTitle = [NSString stringWithFormat:@"Unit%ld",(long)_unitx+1];
    [self.navigationItem setTitle:pageTitle];
    //添加问题字段
    _label = [[UILabel alloc]initWithFrame:CGRectMake((selfWidth - 200)/2.0, 100, 200, 30)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"Helvetica" size:20];
    _label.text = @"......";
    [self.view addSubview:_label];
    //添加按钮
    _btns = [[NSMutableArray alloc]init];
    for(int i = 0; i < 4; i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 200 + i*70, selfWidth - 100, 50)];
        [btn setTitle:@"?????" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10;
        btn.layer.borderColor=[UIColor systemGreenColor].CGColor;
        btn.tag = i;
        [btn addTarget:self action:@selector(optionsClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btns addObject:btn];
        [self.view addSubview:btn];
    }
    //添加底部答案显示view
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, selfHeight, selfWidth, 200)];
    _bottomView.backgroundColor = [UIColor redColor];
    _answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, selfWidth-20, 50)];
    //answerLabel.textAlignment = NSTextAlignmentCenter;
    _answerLabel.text = @"正确答案：xxxx";
    _answerLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    _answerLabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_answerLabel];
    [self.view addSubview:_bottomView];
    
    //添加底部按钮
    _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, selfHeight - 200, selfWidth - 100, 50)];
    [_bottomBtn setTitle:@"确认" forState:UIControlStateNormal];
    _bottomBtn.layer.cornerRadius = 10;
    _bottomBtn.backgroundColor=[UIColor systemGrayColor];
    _bottomBtnClickable = false;
    [_bottomBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBtn];
}

#pragma mark 页面生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //显示nav
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _questionx = 0;
    _selectedIndex = -1;
    _scores = [NSMutableArray array];
    [self doGetQuestions];
    //[self setupLayoutWithQuestion];
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
#pragma mark 按钮监听事件
- (void) optionsClicked:(UIButton *)btn{
    _bottomBtnClickable = true;
    if([_bottomBtn.titleLabel.text isEqualToString:@"确认"]){
        _bottomBtn.backgroundColor = [UIColor systemGreenColor];
    }
    if(btn.tag != _selectedIndex){
        if(_selectedIndex != -1){
            [_btns[_selectedIndex].layer setBorderWidth:0];
            [_btns[_selectedIndex] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        _selectedIndex = btn.tag;
        [_btns[_selectedIndex].layer setBorderWidth:1.0];
        [_btns[_selectedIndex] setTitleColor:[UIColor systemGreenColor] forState:UIControlStateNormal];
    }
}

- (void) confirm:(UIButton *)btn{
    if(_bottomBtnClickable){
        if([btn.titleLabel.text isEqualToString:@"确认"]){
            //调用检查答案的方法
            [self checkAnswer];
        }else if([btn.titleLabel.text isEqualToString:@"继续"]){
            if(_questionx != 3){
                //跳转下一题
                //相关变量初始化
                [_btns[_selectedIndex].layer setBorderWidth:0];
                [_btns[_selectedIndex] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _selectedIndex = -1;
                [_bottomBtn setTitle:@"确认" forState:UIControlStateNormal];
                _bottomBtnClickable = false;
                _bottomBtn.backgroundColor = [UIColor systemGrayColor];
                [UIView animateWithDuration:0.5 animations:^{
                    self->_bottomView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200);
                }];
                _questionx++;
                [_label setText:_questionData[_questionx][@"question"]];
                for(int i = 0; i < 4; i++){
                    [_btns[i] setTitle:_questionData[_questionx][@"choices"][i] forState:UIControlStateNormal];
                }
            }else{
                //TODO: 结算页面
                ScoreViewController *svc = [[ScoreViewController alloc]initWithStatus:_scores];
                [self.navigationController pushViewController:svc animated:YES];
            }
        }
    }
}


#pragma mark UI更新

/// 更新问题中的文本
- (void) setupLayoutWithQuestion{
    NSLog(@"更新问题");
    [_label setText:_questionData[_questionx][@"question"]];
    for(int i = 0; i < 4; i++){
        [_btns[i] setTitle:_questionData[_questionx][@"choices"][i] forState:UIControlStateNormal];
    }
}


/// 弹出答案
/// @param answerData 其结构如{"message": "right","data": "domestic"}
- (void) popupAnswerView:(NSDictionary *)answerData{
    _answerLabel.text = [NSString stringWithFormat:@"正确答案：%@",answerData[@"data"]];
    [_bottomBtn setTitle:@"继续" forState:UIControlStateNormal];
    if([answerData[@"message"] isEqualToString:@"right"]){
        [_scores addObject:[NSNumber numberWithInteger:1]];
        _bottomView.backgroundColor = [UIColor colorWithRed:144.0/255 green:238.0/255 blue:144.0/255 alpha:1];
        _bottomBtn.backgroundColor = [UIColor systemGreenColor];
    }else{
        [_scores addObject:[NSNumber numberWithInteger:0]];
        _bottomView.backgroundColor = [UIColor colorWithRed:240.0/255 green:128.0/255 blue:128.0/255 alpha:1];
        _bottomBtn.backgroundColor = [UIColor systemRedColor];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self->_bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 180, self.view.bounds.size.width, 200);
    }];
}

#pragma mark 网络请求
- (AFHTTPSessionManager *)shareAFNManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30.0f;
    // 设置请求头
    //[manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json",@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    return manager;
}

- (void)doGetQuestions
{
    //创建请求地址
    NSString *url=@"https://service-p12xr1jd-1257177282.ap-beijing.apigateway.myqcloud.com/release/HW5_api";
    //设置参数
    NSDictionary *parameters=@{@"unit":[NSString stringWithFormat:@"%ld",(long)_unitx],};
    //AFN管理者调用get请求方法
    [[self shareAFNManager] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //返回请求返回进度
        NSLog(@"downloadProgress-->%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"responseObject-->%@",responseObject);
        self->_questionData = responseObject[@"data"];
        [self setupLayoutWithQuestion];
        //       NSLog(@"data length is %ld, and the content is --> %@", data.count, data[1][@"question"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"error-->%@",error);
    }];
}

- (void) checkAnswer{
    //创建地址
    NSString *url=@"https://service-p12xr1jd-1257177282.ap-beijing.apigateway.myqcloud.com/release/HW5_api";
    //设置参数
    NSDictionary *parameters=@{
        @"unit":[NSString stringWithFormat:@"%ld",(long)_unitx],
        @"question":[NSString stringWithFormat:@"%ld",(long)_questionx],
        @"answer":_btns[_selectedIndex].titleLabel.text,
    };
    AFHTTPSessionManager *netManager = [self shareAFNManager];
    netManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [netManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
        NSLog(@"responseObject-->%@",responseObject);
        NSDictionary *answerData = responseObject;
        [self popupAnswerView:answerData];
        //       NSLog(@"data length is %ld, and the content is --> %@", data.count, data[1][@"question"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"error-->%@",error);
    }];
    
}

@end
