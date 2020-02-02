//
//  HWLanguage.m
//  HW2_v2
//
//  Created by student5 on 2019/9/14.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "HWLanguage.h"

@implementation HWLanguage

//重写init方法，将tour和unit初始值设定为1
- (instancetype)init{
    if(self = [super init]){//说明父类init方法调用成功
        //将tour和unit的初始值设定为1
        self->progress_tour = 1;
        self->progress_unit = 1;
    }
    return self;
}

//此方法每调用一次，会修改unit和tour到下一个unit对应的值
- (void)learnOneUnit{
    if(self.getUnit == 4){
        if(self.getTour == 8){
            //将tours赋值为0 以表示学习结束
            self->progress_tour = 0;
        }else{
            self->progress_tour++;
            self->progress_unit = 1;
        }
    }else{
        self->progress_unit++;
    }
}

//返回当前对象的tour值
- (NSInteger)getTour{
    return self->progress_tour;
}

//返回当前对象的unit值
- (NSInteger)getUnit{
    return self->progress_unit;
}

//通过tour和unit判断学习是否结束
- (bool)isFinish{
    if(self->progress_tour == 0){
        return true;
    }else{
        return false;
    }
}
- (NSString *)getName{
    return @"no Name";
}
@end

@implementation English

- (NSString *)getName{
    return @"英语";
}

@end

@implementation Japanese

- (NSString *)getName{
    return @"日语";
}

@end

@implementation German

- (NSString *)getName{
    return @"德语";
}

@end

@implementation Spanish

- (NSString *)getName{
    return @"西班牙语";
}

@end
