//
//  selectLanguageView.h
//  HW3
//
//  Created by student5 on 2019/9/22.
//  Copyright © 2019 inntechy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "../Controllers/SelectLanguageViewController.h"
#import "SelectLanguageCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface SelectLanguageView : UIView

@property (strong,nonatomic)    UILabel *label;
@property (strong,nonatomic)     UICollectionView *languageCollectionView;
//@property (strong,nonatomic)     UIButton *btn;
//@property (strong,nonatomic)     UITextField *textField1;

@end

NS_ASSUME_NONNULL_END
