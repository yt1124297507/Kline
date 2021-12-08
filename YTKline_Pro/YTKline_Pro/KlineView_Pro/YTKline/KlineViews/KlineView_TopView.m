//
//  KlineView_TopView.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/15.
//

#import "KlineView_TopView.h"
#import "Masonry.h"
#import "YTKlineHeader.h"
@implementation KlineView_TopView

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
        self.userInteractionEnabled = NO;
        
    }
    return self;
}
+(instancetype)initWithSpacing:(CGFloat)spacing{
    KlineView_TopView *view = [KlineView_TopView new];
    view.spacing = spacing;
    [view addSubviews];
    return view;
}

-(void)addSubviews{
    _lab1 = [UILabel new];
    _lab2 = [UILabel new];
    _lab3 = [UILabel new];
    _lab4 = [UILabel new];
    
    
    [self addSubview:_lab1];
    [_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.top.mas_offset(0);
//        make.width.mas_lessThanOrEqualTo((qqWidth-self.spacing*2-30)/3);
        make.width.mas_lessThanOrEqualTo(self.mas_width).multipliedBy(1.0/3).mas_offset(-self.spacing);
    }];
    
    [self addSubview:_lab2];
    [_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_equalTo(self.lab1.mas_right).mas_offset(self.spacing);
        make.width.mas_lessThanOrEqualTo(self.mas_width).multipliedBy(1.0/3).mas_offset(-self.spacing);
    }];
    
    [self addSubview:_lab3];
    [_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_equalTo(self.lab2.mas_right).mas_offset(self.spacing);
        make.width.mas_lessThanOrEqualTo(self.mas_width).multipliedBy(1.0/3).mas_offset(-self.spacing);
    }];
    
    [self addSubview:_lab4];
    [_lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.mas_equalTo(self.lab3.mas_right).mas_offset(self.spacing);
        make.width.mas_lessThanOrEqualTo(self.mas_width).multipliedBy(1.0/3).mas_offset(-self.spacing);
    }];
    
    
    [self labStyle:_lab1];
    [self labStyle:_lab2];
    [self labStyle:_lab3];
    [self labStyle:_lab4];
}


-(void)labStyle:(UILabel *)lab{
    lab.font = [KlineHelper TopTxtFont];
    lab.numberOfLines = 0;
}

-(void)showTxts_txt1:(NSString *)txt1
                txt2:(NSString *)txt2
                txt3:(NSString *)txt3
                txt4:(NSString *)txt4{
    _lab1.text = txt1;
    _lab2.text = txt2;
    _lab3.text = txt3;
    _lab4.text = txt4;
}
-(void)showColors_color1:(UIColor *)color1
                  color1:(UIColor *)color2
                  color1:(UIColor *)color3
                  color1:(UIColor *)color4{
    _lab1.textColor = color1;
    _lab2.textColor = color2;
    _lab3.textColor = color3;
    _lab4.textColor = color4;
}



@end
