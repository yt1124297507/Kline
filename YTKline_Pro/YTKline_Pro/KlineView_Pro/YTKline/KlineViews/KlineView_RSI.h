//
//  KlineView_RSI.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KlineView_RSI : UIView

/// 蜡烛图宽
@property (nonatomic,assign) CGFloat KlineCandleWid;

/// 蜡烛图间隙
@property (nonatomic,assign) CGFloat KlineCandleSpacing;

@property (nonatomic,retain) NSMutableArray *arrNeedDrawModels;
@property (nonatomic,copy) void(^getedRightPricesBlock)(NSString *max,NSString *mid,NSString *Min);

-(void)clearAllLayers;;

@end

NS_ASSUME_NONNULL_END
