//
//  MainCollectionViewCell.m
//  hw5
//
//  Created by student5 on 2019/10/24.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "MainCollectionViewCell.h"

@implementation MainCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        //给cell添加背景色
        //初始化CAGradientlayer对象，使它的大小为UIView的大小
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
        [self.contentView.layer addSublayer:self.gradientLayer];
        //设置渐变区域的起始和终止位置（范围为0-1）
        _gradientLayer.startPoint = CGPointMake(-1, 0);
        _gradientLayer.endPoint = CGPointMake(0.8, 1);
        //设置颜色数组
        _gradientLayer.colors = @[(__bridge id)[UIColor systemPinkColor].CGColor,
                                      (__bridge id)[UIColor systemYellowColor].CGColor];
        //设置颜色分割点（范围：0-1）
        _gradientLayer.locations = @[@(0.5f), @(1.0f)];
        
        _gradientLayer.cornerRadius = 10;
        //self.contentView.layer.masksToBounds = YES;
        
        _topLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _topLabel.font = [UIFont systemFontOfSize:18];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.textColor = [UIColor whiteColor];
        //_topLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_topLabel];
    }
    return self;
}

@end
