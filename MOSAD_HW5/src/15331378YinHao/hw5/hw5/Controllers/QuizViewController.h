//
//  QuizViewController.h
//  hw5
//
//  Created by student5 on 2019/10/25.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuizViewController : UIViewController

@property (nonatomic) NSInteger unitx;//表示当前是第几单元
@property (nonatomic) NSInteger questionx;//表示当前是第几题
@property (strong,nonatomic) UILabel *label;//显示问题
@property (nonatomic) NSInteger selectedIndex;//表示当前被选中的按钮序号
@property (strong,nonatomic) NSMutableArray<UIButton *> *btns;//4个按钮
@property (strong,nonatomic) UIButton *bottomBtn;//底部按钮
@property (nonatomic) Boolean bottomBtnClickable;//底部按钮是否可点击
@property (strong,nonatomic) UIView *bottomView;//答案显示部分
@property (strong,nonatomic) UILabel *answerLabel;
@property (strong,nonatomic) NSArray *questionData;//题集
@property (strong,nonatomic) NSMutableArray *scores;//得分

- (instancetype) initWithUnit:(NSInteger)i;

@end

NS_ASSUME_NONNULL_END
