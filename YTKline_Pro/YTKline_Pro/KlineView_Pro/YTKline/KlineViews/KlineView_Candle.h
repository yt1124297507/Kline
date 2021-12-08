//
//  KlineView_Candle.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//

#import <UIKit/UIKit.h>
#import "YTKlineHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface KlineView_Candle : UIView

@property (nonatomic,retain) UIView *drawCandleView;//绘制拉组图的父视图

@property (nonatomic,assign) Y_StockChartType y_stockChartType;

/*
 分时图模式
 */
@property (nonatomic,assign) BOOL isOneMinuteModel;

/// 蜡烛图宽
@property (nonatomic,assign) CGFloat KlineCandleWid;

/// 蜡烛图间隙
@property (nonatomic,assign) CGFloat KlineCandleSpacing;

@property (nonatomic,retain) NSMutableArray *arrNeedDrawModels;

@property (nonatomic,copy) void(^getedRightPricesBlock)(NSString *max,NSString *mid,NSString *Min);

-(void)updateNewPriceLayer:(YTKlineModel *)model newPriceModelX:(CGFloat)newPriceX isWeakLeft:(BOOL)isWeakLeft scrollView:(UIScrollView *)scMain;

-(void)reDraw;
-(void)clearAllLayers;


-(CGPoint)pointFromModel:(YTKlineModel *)model;

@end

NS_ASSUME_NONNULL_END
