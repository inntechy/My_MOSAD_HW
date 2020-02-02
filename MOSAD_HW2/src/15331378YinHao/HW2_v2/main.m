//
//  main.m
//  HW2_v2
//
//  Created by student5 on 2019/9/14.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWLanguage.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //名字集
        NSArray *names = @[@"张三",@"李四",@"王五"];
        //用随机数确定名字和学习的语言
        int indexOfLanguage = arc4random() % 4;
        int indexOfNames = arc4random() % 3;
        HWLanguage* lang;
        //学习什么语言，就实例化对应的类
        switch (indexOfLanguage) {
            case 0:{
                lang = [[English alloc] init];
                break;
            }
            case 1:{
                lang = [[Japanese alloc] init];
                break;
            }
            case 2:{
                lang = [[German alloc] init];
            }
            case 3:{
                lang = [[Spanish alloc] init];
            }
            default:
                break;
        }
        //获取当前时间，作为开始学习的时间
        NSDate *learnDate = [NSDate date];
        while(!lang.isFinish){
            //NSCalendar一定要用currentCalendar初始化
            NSCalendar *cal = [NSCalendar currentCalendar];
            //转化后的年月日
            NSInteger year;
            NSInteger month;
            NSInteger day;
            //从learnDate中，获取对应的年月日并存到对应变量中
            [cal getEra:nil year:&year month:&month day:&day fromDate:learnDate];
            //按格式输出
            //当月或日为一位数时，需要补0
            NSString *monthPlaceHolder = @"";
            NSString *dayPlaceHolder = @"";
            if(month < 10){
                monthPlaceHolder = @"0";
            }
            if(day < 10){
                dayPlaceHolder = @"0";
            }
            NSLog(@"%@ %ld年%@%ld月%@%ld日 学习%@ tour %ld unit %ld",
                  names[indexOfNames],
                  year,
                  monthPlaceHolder,
                  month,
                  dayPlaceHolder,
                  day,
                  lang.getName,
                  lang.getTour,
                  lang.getUnit);
            //更新tour和unit
            [lang learnOneUnit];
            //更新下次学习的时间，修改的值随机生成[1,5]的整数
            int daysToNextLearn = (arc4random() % 5) + 1;
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = daysToNextLearn;
            //使用NSCalendar和dayComponent修改learnDate
            NSCalendar *theCalendar = [NSCalendar currentCalendar];
            learnDate = [theCalendar dateByAddingComponents:dayComponent toDate:learnDate options:0];
        }
    }
    return 0;
}
