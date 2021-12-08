//
//  KlineView_RightView.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//右侧价格、指标图
@interface KlineView_RightView : UIView
@property (nonatomic,retain) UILabel *labTop;
@property (nonatomic,retain) UILabel *labMid;
@property (nonatomic,retain) UILabel *labBot;

-(void)showWith_Max:(NSString *)max mid:(NSString *)mid min:(NSString *)min;
-(void)show_KMB_With_Max:(NSString *)max mid:(NSString *)mid min:(NSString *)min;
@end

NS_ASSUME_NONNULL_END
