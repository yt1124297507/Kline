//
//  YTKlineView.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/8.
//

#import <UIKit/UIKit.h>
#import "YTKlineHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface YTKlineView : UIView
@property (nonatomic,retain) UIScrollView *scMain;

/// 正在加载更多
@property (nonatomic,assign) BOOL isLoadingMore;
@property (nonatomic,assign) NSInteger priceScale;
@property (nonatomic,assign) NSInteger NumberScale;


@property (nonatomic,retain) NSMutableArray *arrModels;

@property (nonatomic,assign) Y_StockChartType y_stockChartType;

@property (nonatomic,assign) BOOL isFull;
@property (nonatomic,assign) BOOL isGuess;


@property (nonatomic,assign) BOOL showMACD;
@property (nonatomic,assign) BOOL showKDJ;
@property (nonatomic,assign) BOOL showRSI;
@property (nonatomic,assign) BOOL showWR;


@property (nonatomic,copy) void(^loadMoreBlock) (YTKlineModel * firstModel);


/// 是否是分时图
/// @param isOneMinute isOneMinute description
-(void)setCurrentIsOneMinuteModel:(BOOL)isOneMinute;


//重绘
-(void)reDrawAll;

/// 清空绘制数据
-(void)clearAllDatas;


/// 接口返回的data
/// @param data data description
-(void)getedKlinesData:(NSArray <YTKlineModel *>*)data;

/// socketdata
/// @param model model description
-(void)getedOneSocketData:(YTKlineModel *)model;


/// 加载更多data
/// @param data data description
-(void)getedMoreKlineData:(NSArray <YTKlineModel *>*)data;

- (instancetype)initWithFrame_Full:(CGRect)frame;
- (instancetype)initWithFrame_Guess:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
