//
//  YTKlineHeader.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//

#ifndef YTKlineHeader_h
#define YTKlineHeader_h

/**
 *  K线蜡烛图最大的宽度
 */
#define YT_Kline_CandleMaxWid 20

/**
 *  K线蜡烛图最小的宽度
 */
#define YT_Kline_CandleMinWid 1

//缩放手势最小值
#define YT_Kline_PichScaleMin 0.1

//K线右侧显示价格等的空隙
//#define YT_Kline_RightSpacing 150

//蜡烛图底部间距
#define YT_Kline_Candle_MinY 4

//蜡烛图顶部间距
#define YT_Kline_Candle_TopY 15

#import "YTKlineModel.h"
#import "KlineHelper.h"
#import "Masonry.h"
#import "YYModel.h"
#import "CAShapeLayer+Candle.h"
#endif /* YTKlineHeader_h */


typedef NS_ENUM(NSInteger, Y_StockChartType) {//蜡烛图线类型
    Y_StockChartType_None = 0,
    Y_StockChartType_MA,
    Y_StockChartType_EMA,
    Y_StockChartType_BOLL,
};

typedef NS_ENUM(NSInteger, Y_ScrollType) {//蜡烛图线类型
    Y_ScrollType_ToRight = 0,//强制滚动到最右边 用于首次接口返回数据
    Y_ScrollType_Auto,//根据偏移量自动计算要不要滚动到最右边
    Y_ScrollType_ToIndex//滚动到具体某一个index 用于加载更多数据时 新数据位置
};
