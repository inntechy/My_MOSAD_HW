//
//  userViewController.h
//  HW3
//
//  Created by student5 on 2019/9/24.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UISegmentedControl *segmentC;
@property (nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@end

NS_ASSUME_NONNULL_END
