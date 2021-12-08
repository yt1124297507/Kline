//
//  KlineView_TipBoard.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/17.
//

#import "KlineView_TipBoard.h"

@implementation KlineView_TipBoard

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
        self.backgroundColor = [KlineHelper backgroundColor];
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.layer.borderColor = [UIColor.darkGrayColor CGColor];
        self.layer.borderWidth = 1;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapPress)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

-(void)showWith_Model:(YTKlineModel *)model maxWid:(CGFloat)maxWid showInLeft:(BOOL)showInLeft{
    [self removeAllLabels];
    
    
    self.hidden = NO;
   
    
    CGFloat spacing = 15;
    CGFloat tipBoarWid = [self leftLabelWid] + [self rightLabelWid] + [self LeftRightSpacing] + [self LeftRightInset] * 2;
    
    NSInteger count = 8;

    
    
    CGFloat tipBoarHeight = [self TopBottomInset] * 2 + [self TopBottomSpacing] * (count-1);
    for (NSNumber *number in [self arrRightHeight:model]) {
        tipBoarHeight += number.floatValue;
    }
    


    CGRect frame = CGRectMake(showInLeft ? spacing : (maxWid-spacing-tipBoarWid), spacing * 2, tipBoarWid, tipBoarHeight);
    CGFloat timer = self.frame.origin.x==0?0:0.2;
    [UIView animateWithDuration:timer animations:^{
        self.frame = frame;
    }];
    
    
    
    NSArray *arrLeft = [self arrLeft];
    NSArray *arrRight = [self arrRight:model];
    NSArray *arrColor = [self arrColors:model];
    
    NSArray *arrR_Height = [self arrRightHeight:model];
    
    CGFloat Y = [self TopBottomInset];//下一个要展示的label的Y
    
    for (int i = 0; i < count;i++) {
        
        {
            UILabel *leftLabel = [UILabel new];
            leftLabel.text = arrLeft[i];
            leftLabel.numberOfLines = 0;
            leftLabel.textColor = UIColor.grayColor;;
            [leftLabel setFont:[UIFont systemFontOfSize:10]];
            leftLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:leftLabel];
            
            leftLabel.frame = CGRectMake([self LeftRightInset],
                                         Y,
                                         [self leftLabelWid],
                                         [arrR_Height[i] floatValue]);
        
        }
        {
            UILabel *leftLabel = [UILabel new];
            leftLabel.text = arrRight[i];
            leftLabel.numberOfLines = 0;
            leftLabel.textColor = arrColor[i];;
            leftLabel.textColor = UIColor.grayColor;;
            [leftLabel setFont:[UIFont systemFontOfSize:10]];
            leftLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:leftLabel];
            
            leftLabel.frame = CGRectMake(
                                         [self LeftRightInset]+[self leftLabelWid]+[self LeftRightSpacing],
                                         Y,
                                         [self rightLabelWid],
                                         [arrR_Height[i] floatValue]);
        }
        
        Y += ([arrR_Height[i] floatValue] + [self TopBottomSpacing]);
    }
    
    
}

-(NSArray *)arrLeft{
    return @[
        (@"时间"),
        (@"开"),
        (@"高"),
        (@"低"),
        (@"收"),
        (@"涨跌额"),
        (@"涨跌幅"),
        (@"成交量")
    ];
}

-(NSArray *)arrRightHeight:(YTKlineModel *)model{
    NSArray *arrRight = [self arrRight:model];
    NSMutableArray *arrResult = @[].mutableCopy;;
    
    for (NSString *string in arrRight) {
        CGFloat height = 20;//[KlineHelper getTxtWid:string font:[UIFont systemFontOfSize:10]]
        if (height < [self heightOfEvery]) {
            height = [self heightOfEvery];
        }
        [arrResult addObject:@(height)];
    }
    return arrResult;
}


-(NSArray *)arrRight:(YTKlineModel *)model{
    
    NSString *upDownNum = @"100";

    NSString *upDownNumRate = @"100";
    
    return @[
        [KlineHelper timeStampToString:model.date formatter:@"yy-MM-dd HH:mm"],
        model.open,
        model.high,
        model.low,
        model.close,
        upDownNum,
        upDownNumRate,
        model.amount,
    ];
}
-(NSArray *)arrColors:(YTKlineModel *)model{


    UIColor *zdfColor = [UIColor greenColor];
    
    return @[
        UIColor.grayColor,
        UIColor.grayColor,
        UIColor.grayColor,
        UIColor.grayColor,
        UIColor.grayColor,
        zdfColor,
        zdfColor,
        UIColor.grayColor,
    ];
}


-(void)labLStyle:(UILabel *)lab{
    
}

/// 调整行间距
/// @param lab lab description
/// @param text text description
/// @param lineSpacing lineSpacing description
-(void)setLabel:(UILabel *)lab Text:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    if (!text || lineSpacing < 0.01) {
        lab.text = text;
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];        //设置行间距
    [paragraphStyle setLineBreakMode:lab.lineBreakMode];
    [paragraphStyle setAlignment:lab.textAlignment];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    lab.attributedText = attributedString;
}


-(void)removeAllLabels{
    for (UIView *vi in self.subviews.mutableCopy) {
        [vi removeFromSuperview];
    }
}


-(void)singleTapPress{
    self.frame = CGRectZero;
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}
//上下缩进
-(CGFloat)TopBottomInset{
    return 8;
}
-(CGFloat)LeftRightInset{
    return 8;
}
//上下间距
-(CGFloat)TopBottomSpacing{
    return 2;
}
-(CGFloat)LeftRightSpacing{
    return 2;
}

//高
-(CGFloat)heightOfEvery{
    return 10;
}

//左宽
-(CGFloat)leftLabelWid{
    return 40;
}
-(CGFloat)rightLabelWid{
    return 80;
}


@end
