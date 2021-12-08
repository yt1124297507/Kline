//
//  KlineView_RightView.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/15.
//

#import "KlineView_RightView.h"
#import "Masonry.h"
#import "YTKlineHeader.h"
@implementation KlineView_RightView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addsubViews];
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

-(void)addsubViews{
    _labTop = [UILabel new];
    _labMid = [UILabel new];
    _labBot = [UILabel new];
    
    [self labStyle:_labTop];
    [self labStyle:_labMid];
    [self labStyle:_labBot];
    
    [self addSubview:_labTop];
    [_labTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.mas_offset(0);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    
    [self addSubview:_labMid];
    [_labMid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.centerY.mas_offset(0);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    
    [self addSubview:_labBot];
    [_labBot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.width.mas_lessThanOrEqualTo(80);
    }];
}

-(void)labStyle:(UILabel *)lab{
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [KlineHelper RightTxtColor];
    lab.font = [KlineHelper RightTxtFont];
    lab.numberOfLines = 0;
    
}
-(void)showWith_Max:(NSString *)max mid:(NSString *)mid min:(NSString *)min{
    _labTop.text = max;
    _labMid.text = mid;
    _labBot.text = min;
}

-(void)show_KMB_With_Max:(NSString *)max mid:(NSString *)mid min:(NSString *)min{
    _labTop.text = max;
    _labMid.text = mid;
    _labBot.text = min;
}


@end
