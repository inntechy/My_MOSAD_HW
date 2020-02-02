//
//  ScoreViewController.m
//  hw5
//
//  Created by student5 on 2019/10/25.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

#pragma mark 初始化UI
- (void) setupUI{
    float selfWidth = self.view.bounds.size.width;
    float selfHeight = self.view.bounds.size.height;
    //标题label
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((selfWidth - 200)/2.0, 200, 200, 30)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"正确数";
    _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    [self.view addSubview:_titleLabel];
    //总分数
    _totleScoresLabel = [[UILabel alloc]initWithFrame:CGRectMake((selfWidth - 100)/2.0, 300, 100, 100)];
    _totleScoresLabel.textAlignment = NSTextAlignmentCenter;
    _totleScoresLabel.textColor = [UIColor blackColor];
    _totleScoresLabel.text = @"0";
    _totleScoresLabel.font = [UIFont fontWithName:@"Helvetica" size:70];
    [self.view addSubview:_totleScoresLabel];
    
    //添加星星
    //星星的总宽度为50 * 4 + 10 * 3
    _stars = [[NSMutableArray alloc]init];
    for(int i = 0; i < 4; i++){
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake((selfWidth - 230)/2.0 + (i*60), 450, 50, 50)];
        imgV.image = [UIImage imageNamed:@"Star0.png"];
        [_stars addObject:imgV];
        [self.view addSubview:imgV];
    }
    
    
    //添加底部按钮
    _bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, selfHeight - 100, selfWidth - 100, 50)];
    [_bottomBtn setTitle:@"返回" forState:UIControlStateNormal];
    _bottomBtn.layer.cornerRadius = 10;
    _bottomBtn.backgroundColor=[UIColor systemGreenColor];
    [_bottomBtn addTarget:self action:@selector(backToMainpage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBtn];
}

#pragma mark 动画处理
- (void) animator{
    for(int i = 0; i < 4; i++){
        [UIView animateWithDuration:0.5f delay:i*0.8f+0.5f options:UIViewAnimationOptionTransitionNone animations:^{
            self->_stars[i].transform = CGAffineTransformMakeScale(1.4, 1.4);
        } completion:^(BOOL finished) {
        // 完成变大后要设置星星的图像和得分文字，然后将视图还原
        // CGAffineTransformIdentity
            if([self->_scores[i] isEqualToNumber:[NSNumber numberWithInteger:1]]){
                self->_totleScores++;
                self->_totleScoresLabel.text = [NSString stringWithFormat:@"%ld",(long)self->_totleScores];
                self->_stars[i].image = [UIImage imageNamed:@"Star1.png"];
            }
        [UIView animateWithDuration:0.2f animations:^{
            self->_stars[i].transform = CGAffineTransformIdentity;
        }];
        }];
    }
}

#pragma mark 生命周期

- (instancetype) initWithStatus:(NSArray *)scores{
    if(self = [super init]){
        _scores = scores;
        _totleScores = 0;
        [self setupUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏nav
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self animator];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 监听事件
- (void) backToMainpage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
