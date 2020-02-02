//
//  ScoreViewController.h
//  hw5
//
//  Created by student5 on 2019/10/25.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreViewController : UIViewController

@property (strong,nonatomic) NSArray *scores;//得分情况
@property (strong,nonatomic) UILabel *titleLabel;//最上方文本
@property (nonatomic) NSInteger totleScores;//总得分值
@property (strong,nonatomic) UILabel *totleScoresLabel;//总得分文本
@property (strong,nonatomic) NSMutableArray<UIImageView *> *stars;//星星们
@property (strong,nonatomic) UIButton *bottomBtn;//返回按钮


- (instancetype) initWithStatus:(NSArray *)scores;

@end

NS_ASSUME_NONNULL_END
