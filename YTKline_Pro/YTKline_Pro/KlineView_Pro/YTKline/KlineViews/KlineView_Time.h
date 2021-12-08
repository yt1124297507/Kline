//
//  KlineView_Time.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KlineDateModel : NSObject
@property (nonatomic,assign) CGPoint point;
@property (nonatomic,retain) NSString *stringStamp;

+(instancetype)initWithPoint:(CGPoint)point dataStamp:(NSString *)stamp;
@end




@interface KlineView_Time : UIView

/// 蜡烛图宽
@property (nonatomic,assign) CGFloat KlineCandleWid;

/// 蜡烛图间隙
@property (nonatomic,assign) CGFloat KlineCandleSpacing;

@property (nonatomic,retain) NSMutableArray *arrNeedDrawModels;


-(void)clearAllLayers;

@end

NS_ASSUME_NONNULL_END
