//
//  KlineView_TopView.h
//  KlineDemo
//
//  Created by 于涛 on 2021/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//顶部价格、指标图
@interface KlineView_TopView : UIView


@property (nonatomic,retain) UILabel *lab1;
@property (nonatomic,retain) UILabel *lab2;
@property (nonatomic,retain) UILabel *lab3;
@property (nonatomic,retain) UILabel *lab4;

@property (nonatomic,assign) CGFloat spacing;

+(instancetype)initWithSpacing:(CGFloat)spacing;

-(void)showTxts_txt1:(NSString *)txt1
                txt2:(NSString *)txt2
                txt3:(NSString *)txt3
                txt4:(NSString *)txt4;

-(void)showColors_color1:(UIColor *)color1
                  color1:(UIColor *)color2
                  color1:(UIColor *)color3
                  color1:(UIColor *)color4;

@end

NS_ASSUME_NONNULL_END
