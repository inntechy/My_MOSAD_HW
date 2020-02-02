//
//  TableViewCell.m
//  hw6
//
//  Created by student5 on 2019/11/13.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置圆角
        self.layer.cornerRadius = 10;
        self.contentView.layer.cornerRadius = 10;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.shouldRasterize = YES;
        //img
//        _imgView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
//        [_imgView setContentMode:UIViewContentModeCenter];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imgView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.imgView];
}

- (void)setFrame:(CGRect)frame {
    float margin = 10;
    frame.origin.x += margin;
    frame.origin.y += margin/2;
    frame.size.width -= 2 * margin;
    frame.size.height -= margin;
    [super setFrame:frame];
}

- (UIImageView *)imgView{
    if(!_imgView){
        //注意，此时contentView还未确定，因此这里的大小是错误的。
        //在上面的layoutSubviews方法里，重新设置了一次。
        _imgView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        [_imgView setContentMode:UIViewContentModeScaleToFill];
    }
    return _imgView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
