//
//  selectLanguageCollectionViewCell.m
//  HW3
//
//  Created by student5 on 2019/9/23.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "SelectLanguageCollectionViewCell.h"

@implementation SelectLanguageCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,130, 30)];
        _topLabel.font = [UIFont systemFontOfSize:14];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        //_topLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_topLabel];
        
        _flagImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 90, 70)];
        //_flagImage.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:_flagImage];
    }
    return self;
}

@end
