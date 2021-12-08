//
//  KlineView_TipBoard.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/17.
//

#import <UIKit/UIKit.h>
#import "YTKlineHeader.h"
NS_ASSUME_NONNULL_BEGIN





@interface KlineView_TipBoard : UIView

@property (nonatomic,assign) BOOL isGuess;


-(void)showWith_Model:(YTKlineModel *)model maxWid:(CGFloat)maxWid showInLeft:(BOOL)showInLeft;
@property (nonatomic,copy) void(^singleTapBlock) (void);

@end

NS_ASSUME_NONNULL_END
