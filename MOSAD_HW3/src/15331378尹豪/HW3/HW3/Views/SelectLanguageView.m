//
//  selectLanguageView.m
//  HW3
//
//  Created by student5 on 2019/9/22.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "SelectLanguageView.h"
#import "../Controllers/SelectLanguageViewController.h"

@implementation SelectLanguageView

//重写初始化函数 以便在view中添加子视图
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    float selfWidth = self.bounds.size.width;
    //label 请选择语言
    _label = [[UILabel alloc]initWithFrame:CGRectMake((selfWidth - 100) / 2.0, 300, 100, 30)];
    _label.text = @"请选择语言";
    //内容居中
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
