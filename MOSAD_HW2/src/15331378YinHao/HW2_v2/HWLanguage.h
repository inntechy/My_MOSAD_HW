//
//  HWLanguage.h
//  HW2_v2
//
//  Created by student5 on 2019/9/14.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWLanguage : NSObject{
    NSInteger progress_tour;
    NSInteger progress_unit;
}

//重写init方法，将tour和unit初始值设定为1
- (instancetype)init;
//此方法每调用一次，会修改unit和tour到下一个unit对应的值
- (void)learnOneUnit;
//返回当前对象的tour值
- (NSInteger)getTour;
//返回当前对象的unit值
- (NSInteger)getUnit;
//通过tour判断学习是否结束
- (bool)isFinish;
//获取当前学习的语言名字
- (NSString *)getName;

@end

@interface English : HWLanguage {
    
}

@end

@interface Japanese : HWLanguage {
    
}

@end

@interface German : HWLanguage {
    
}

@end

@interface Spanish : HWLanguage {
    
}

@end

NS_ASSUME_NONNULL_END
