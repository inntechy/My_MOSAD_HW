//
//  learningTableViewController.h
//  HW3
//
//  Created by student5 on 2019/9/24.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LearningTableViewController : UITableViewController

@property (strong, nonatomic)NSString *lang;

- (instancetype) initWithLanguage:(NSString*) language;

@end

NS_ASSUME_NONNULL_END
