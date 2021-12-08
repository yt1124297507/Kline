//
//  YTKlineTimesModel.m
//  Aofex
//
//  Created by 于涛 on 2021/11/19.
//  Copyright © 2021 brc. All rights reserved.
//

#import "YTKlineTimesModel.h"

@implementation YTKlineTimesModel

+(instancetype)initWithName:(NSString *)name Value:(NSString *)value Index:(NSInteger)index{
    YTKlineTimesModel *model = [YTKlineTimesModel new];
    model.strTimeName = name;
    model.strTimeValue = value;
    model.timeIndex = index;
    return model;
}

+(NSArray *)arrAllTimes{
    return @[
        
    ];
}


@end
