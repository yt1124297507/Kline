//
//  YTKlineTimesModel.h
//  Aofex
//
//  Created by 于涛 on 2021/11/19.
//  Copyright © 2021 brc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTKlineTimesModel : NSObject
//显示的名称eg. 1分钟 2分钟
@property (nonatomic,retain)  NSString *strTimeName;

//对应的分时 eg. 1min 5min
@property (nonatomic,retain)  NSString *strTimeValue;

//索引 eg. 0 1 2 ..
@property (nonatomic,assign) NSInteger timeIndex;

+(instancetype)initWithName:(NSString *)name Value:(NSString *)value Index:(NSInteger)index;

+(NSArray *)arrAllTimes;

@end

NS_ASSUME_NONNULL_END
