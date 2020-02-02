//
//  mainViewController.h
//  hw5
//
//  Created by student5 on 2019/10/24.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController

@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) NSArray *dataSourceTitles;
@property (strong,nonatomic) UICollectionView *selectUnitView;

@end

NS_ASSUME_NONNULL_END
