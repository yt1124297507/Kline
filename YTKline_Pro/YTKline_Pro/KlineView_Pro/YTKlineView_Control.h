//
//  YTKlineView_Control.h
//  Aofex
//
//  Created by 于涛 on 2021/11/19.
//  Copyright © 2021 brc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTKlineTimesModel.h"
#import "YTKlineView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YTKlineView_Control : UIView


@property (nonatomic,retain) YTKlineView *klineView;
@property (nonatomic,copy) NSString *strCurrency;
@property (nonatomic,copy) NSString *strTrade;


@property (nonatomic,assign) BOOL isFull;

@property (nonatomic,retain) YTKlineTimesModel *timesModel;


@property (nonatomic,copy) void(^showMoreBlock) (BOOL show);
@property (nonatomic,copy) void(^showDeepBlock) (BOOL show);
@property (nonatomic,copy) void(^showSetBlock) (BOOL show);

@property (nonatomic,copy) void(^changeIndicatorBlock) (void);
@property (nonatomic,copy) void(^showFullBlock) (void);

@property (nonatomic,assign) NSInteger priceScale;
@property (nonatomic,assign) NSInteger NumberScale;

-(void)chooseTime:(YTKlineTimesModel *)model;

-(void)relaodData;
-(void)reConect;
-(void)deConnect;

@end

NS_ASSUME_NONNULL_END
