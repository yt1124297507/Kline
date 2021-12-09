//
//  YTKlineView.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/8.
//

#import "YTKlineView.h"
#import "Masonry.h"

#import "KlineView_Candle.h"
#import "KlineView_Vol.h"
#import "KlineView_MACD.h"
#import "KlineView_KDJ.h"
#import "KlineView_RSI.h"
#import "KlineView_WR.h"
#import "KlineView_Time.h"
#import "KlineView_TipBoard.h"

#import "KlineView_TopView.h"
#import "KlineView_RightView.h"

#define YTScreenWid UIScreen.mainScreen.bounds.size.width
#define RightViewTopSpacing 27

@interface YTKlineView()<UIScrollViewDelegate>

/// 当前缩放手势pinch的scale值
@property (nonatomic,assign) CGFloat currentPinchScale;

/// 蜡烛图宽
@property (nonatomic,assign) CGFloat KlineCandleWid;

/// 蜡烛图间隙
@property (nonatomic,assign) CGFloat KlineCandleSpacing;


/// 右侧最新价间隔
@property (nonatomic,assign) CGFloat rightNewPriceWid;

/// 第一个需要绘制的model
@property (nonatomic,assign) NSInteger indexOfStartDraw;


/// 当前选中的model (点击 长按)
@property (nonatomic,retain) YTKlineModel *currentSelectKlineModel;


@property (nonatomic,retain) NSMutableArray *arrNeedDrawModels;

@property (nonatomic,retain) UIView *KlineView_Main;

@property (nonatomic,strong) KlineView_Candle *kline_Candle;
@property (nonatomic,strong) KlineView_Vol *kline_Vol;
@property (nonatomic,strong) KlineView_MACD *kline_Macd;
@property (nonatomic,strong) KlineView_KDJ *kline_Kdj;
@property (nonatomic,strong) KlineView_RSI *kline_Rsi;
@property (nonatomic,strong) KlineView_WR *kline_Wr;
@property (nonatomic,strong) KlineView_Time *kline_time;


@property (nonatomic,retain) KlineView_RightView *rightView_Candle;
@property (nonatomic,retain) KlineView_RightView *rightView_Vol;
@property (nonatomic,retain) KlineView_RightView *rightView_MACD;
@property (nonatomic,retain) KlineView_RightView *rightView_KDJ;
@property (nonatomic,retain) KlineView_RightView *rightView_RSI;
@property (nonatomic,retain) KlineView_RightView *rightView_WR;

@property (nonatomic,retain) KlineView_TopView *topview_Candle;
@property (nonatomic,retain) KlineView_TopView *topview_Vol;
@property (nonatomic,retain) KlineView_TopView *topview_MACD;
@property (nonatomic,retain) KlineView_TopView *topview_KDJ;
@property (nonatomic,retain) KlineView_TopView *topview_RSI;
@property (nonatomic,retain) KlineView_TopView *topview_WR;


/// 单个K线详情
@property (nonatomic,retain) UIView *PointView;
@property (nonatomic,retain) UIView *VView;
@property (nonatomic,retain) UIView *HView;
@property (nonatomic,retain) UILabel *PriceView;
@property (nonatomic,retain) UILabel *DateView;
@property (nonatomic,retain) KlineView_TipBoard *tipBoard;


@property (nonatomic,retain) UIActivityIndicatorView *loadingView;

@property (nonatomic,retain) CALayer *Lineslayer;

@end

@implementation YTKlineView

#pragma mark LifeCycle
- (void)drawRect:(CGRect)rect{
    [self draw_H_V_lines];
}

- (void)layoutSubviews{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViews];
        [self setUp];
    }
    return self;
}

-(void)setUp{
    self.KlineCandleWid = 4;
    self.KlineCandleSpacing = 2;
    
}
#pragma mark TableDelegate & DataSource

#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x==0) {
        if (!_isLoadingMore) {
            if (self.loadMoreBlock) {
                YTKlineModel *firstModel;
                if (self.arrModels.count) {
                    firstModel = self.arrModels.firstObject;
                    self.loadMoreBlock(firstModel);
                }
                
            }
        }
    }
    
    {//如果第一个绘制的index没变， 那就不重新绘制
        CGFloat offsetX = self.scMain.contentOffset.x;
        
        NSInteger startIndex = offsetX / (_KlineCandleSpacing + _KlineCandleWid);
        if (startIndex==_indexOfStartDraw) {
            
        }else{
            [self bringUpNeedDrawModels];
        }
    }
    
    
    //绘制
    [self updateNewPriceLayers];
    
    self.currentSelectKlineModel = nil;
    
}

#pragma mark CusMethod

-(void)clearAllDatas{
    [self clearDetailViews];
    [self getedKlinesData:@[].mutableCopy];
    [_kline_Candle clearAllLayers];
    [_kline_Vol clearAllLayers];
    [_kline_Macd clearAllLayers];
    [_kline_Kdj clearAllLayers];
    [_kline_Rsi clearAllLayers];
    [_kline_Wr clearAllLayers];
    [_kline_time clearAllLayers];
}

-(void)setCurrentIsOneMinuteModel:(BOOL)isOneMinute{
    self.kline_Candle.isOneMinuteModel = isOneMinute;
    [self.kline_Candle reDraw];
}
/// 画线
-(void)draw_H_V_lines{
    CGFloat maxWid = self.bounds.size.width;
    CGFloat maxHeigt = self.bounds.size.height;
    CGFloat wid = maxWid/5;//间距
    CGFloat Height = wid;//间距

    
    if (self.Lineslayer.superlayer) {
        [self.Lineslayer removeFromSuperlayer];
        self.Lineslayer = nil;
    }
    
    CALayer *superLayer = [CALayer layer];
    superLayer.frame = self.bounds;
    [self.layer insertSublayer:superLayer atIndex:0];
    
    for (int i = 0; i * wid <= maxWid; i++) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(i * wid, 0, 0.5, maxHeigt);
        layer.backgroundColor = [UIColor.grayColor CGColor];
        [superLayer addSublayer:layer];
    }
    for (int j = 0; j * Height <= maxHeigt; j++) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, j*Height, maxWid, 0.5);
        [UIColor.grayColor CGColor];
        [superLayer addSublayer:layer];
    }
    self.Lineslayer = superLayer;
}

-(void)showWithPoint:(CGPoint)point model:(YTKlineModel *)model{
    [self clearDetailViews];
    point = CGPointMake(point.x - _scMain.contentOffset.x, point.y + 30);  //30是蜡烛图绘制区域与其父视图的Y间距
    
    CGFloat maxWidth = self.frame.size.width;
    CGFloat maxHeight = self.frame.size.height;
    
    {//横线
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, point.y, maxWidth, 1);
        view.backgroundColor = [KlineHelper HilightColor];
        [self addSubview:view];
        _VView = view;
    }
    {//竖线
        UIView *view = [UIView new];
        CGRect frame = CGRectMake(point.x-_KlineCandleWid/2, 0,_KlineCandleWid, maxHeight);
        view.frame = frame;
        view.backgroundColor = [KlineHelper HilightColor];
        view.alpha = 0.2;
        
//        {
//            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//
//            UIColor *redcolor = MYSWITCHSKIP(@"#15F4603F_#15FF6644", MYCOLOR_ArrStr);;
//            UIColor *redcolor_1 = MYSWITCHSKIP(@"#40F4603F_#40FF6644", MYCOLOR_ArrStr);
//            gradientLayer.colors = @[(__bridge id)redcolor.CGColor,(__bridge id)redcolor_1.CGColor,(__bridge id)redcolor.CGColor];
//            gradientLayer.locations = @[@(0),@(0.5),@(1)];
//
//            gradientLayer.frame = CGRectMake(0, 0, _KlineCandleWid, maxHeight) ;//
//    //        gradientLayer.mask = layer_1;
//            gradientLayer.backgroundColor = UIColor.clearColor.CGColor;
//
//            [view.layer addSublayer:gradientLayer];
//        }
        
        
        [self addSubview:view];
        _HView = view;
    }
    
    {//日期
        
        NSString *string = [KlineHelper timeStampToString:model.date formatter:@"yyyy-MM-dd HH:mm"];
        UIFont *font = [UIFont systemFontOfSize:10];
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [KlineHelper HilightColor];
        label.layer.cornerRadius = 3;
        label.clipsToBounds = YES;
        
        label.textColor = UIColor.whiteColor;
        label.text = string;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = font;;
        CGFloat stringWidth = [KlineHelper getTxtWid:string font:font] + 5;
        if (stringWidth<60) {
            stringWidth = 60;
        }
        
        CGPoint center = CGPointMake(point.x, maxHeight - 15/2);;
        if (center.x < (stringWidth/2)) {
            center.x = stringWidth/2;
        }
        if (center.x > (maxWidth-(stringWidth/2))) {
            center.x = (maxWidth-(stringWidth/2));
        }
        label.center = center;
        label.bounds = CGRectMake(0, 0, stringWidth, 15);
        [self addSubview:label];
        _DateView = label;
    }
    {//光点
        UIView *pointView = [UIView new];
        pointView.center = point;
        pointView.bounds = CGRectMake(0, 0, 4, 4);
        pointView.layer.cornerRadius = 2;
        pointView.clipsToBounds = YES;
        pointView.backgroundColor = UIColor.whiteColor;
        [self addSubview:pointView];
        _PointView = pointView;
    }
    {//最新价
        
        NSString *string = model.close;
        UIFont *font = [UIFont systemFontOfSize:10];
        
        UILabel *label = [UILabel new];
        label.backgroundColor = [KlineHelper HilightColor];
        label.layer.cornerRadius = 3;
        label.clipsToBounds = YES;
        label.textColor = UIColor.whiteColor;
        label.text = string;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = font;;
        CGFloat stringWidth = [KlineHelper getTxtWid:string font:font] + 5;
        if (stringWidth<60) {
            stringWidth = 60;
        }
        
        BOOL showInLeft = (point.x < maxWidth / 2);
        label.center = CGPointMake(showInLeft ? stringWidth/2 : maxWidth-stringWidth/2.0, point.y);
        label.bounds = CGRectMake(0, 0, stringWidth, 15);
        [self addSubview:label];
        _PriceView = label;
    }
    {//tipboard
        BOOL showInLeft = (point.x > maxWidth / 2);
        
        [self.tipBoard showWith_Model:model maxWid:maxWidth showInLeft:showInLeft];
        [self bringSubviewToFront:self.tipBoard];
    }
}

/// 清空K线详情视图
-(void)clearDetailViews{
    if (_HView) {
        [_HView removeFromSuperview];
        _HView = nil;
    }
    if (_VView) {
        [_VView removeFromSuperview];
        _VView = nil;
    }
    if (_PointView) {
        [_PointView removeFromSuperview];
        _PointView = nil;
    }
    if (_PriceView) {
        [_PriceView removeFromSuperview];
        _PriceView = nil;
    }
    if (_DateView) {
        [_DateView removeFromSuperview];
        _DateView = nil;
    }
    self.tipBoard.hidden = YES;
    
}

-(void)showKlineDetail{
    if (_currentSelectKlineModel) {
        YTKlineModel *model = _currentSelectKlineModel;
        CGPoint point = [self.kline_Candle pointFromModel:model];
        [self showWithPoint:point model:model];;
    }
}
//
//-(BOOL)needScrollToright{
//    if (<#condition#>) {
//        <#statements#>
//    }
//}

/// 滚到最右边
-(void)scrollToRight{
    
    if (_scMain.contentSize.width > _scMain.frame.size.width) {
        [_scMain setContentOffset:CGPointMake(_scMain.contentSize.width-_scMain.frame.size.width, 0) animated:NO];
    }
    
}

-(void)updateNewPriceLayers{
    if (!_arrModels.count) {
        return;;
    }
    
    BOOL isleft = (_scMain.contentOffset.x+_scMain.frame.size.width) < (_scMain.contentSize.width - _rightNewPriceWid);
    
    CGFloat newPriceX = _arrModels.count * (_KlineCandleWid + _KlineCandleSpacing) - _KlineCandleSpacing - _KlineCandleWid/2;
    
    [self.kline_Candle updateNewPriceLayer:self.arrModels.lastObject newPriceModelX:newPriceX isWeakLeft:isleft scrollView:_scMain];
}

-(void)updateTopPrices{
    YTKlineModel *model;
    if (_currentSelectKlineModel) {
        model = _currentSelectKlineModel;
    }else{
        model = _arrModels.lastObject;
    }
    KlineHelper *helper = [KlineHelper shared];
    
    KLineIndicatorModel *kIndicatorModel =  KlineHelper.shared.kLineIndicator;
    {
        NSString *txt1 = @"";
        NSString *txt2 = @"";
        NSString *txt3 = @"";
        NSString *txt4 = @"";
        
        if (self.kline_Candle.isOneMinuteModel) {
            
        }else{
            switch (self.kline_Candle.y_stockChartType) {
                case Y_StockChartType_None:{
                    
                }break;
                case Y_StockChartType_MA:{
                    txt1 = [NSString stringWithFormat:@"%@:%@",[helper MA_Name_1],
                            [KlineHelper StrFromDouble:model.MA1 scale:2]];
                    txt2 = [NSString stringWithFormat:@"%@:%@",[helper MA_Name_2],[KlineHelper StrFromDouble:model.MA2 scale:2]];
                    txt3 = [NSString stringWithFormat:@"%@:%@",[helper MA_Name_3],[KlineHelper StrFromDouble:model.MA3 scale:2]];
                    if (!kIndicatorModel.selectMA_1 || !model.MA1) {
                        txt1 = @"";
                    }
                    if (!kIndicatorModel.selectMA_2 || !model.MA2) {
                        txt2 = @"";
                    }
                    if (!kIndicatorModel.selectMA_3 || !model.MA3) {
                        txt3 = @"";
                    }
                    
                    
                }break;
                case Y_StockChartType_EMA:{
                    txt1 = [NSString stringWithFormat:@"%@:%@",[helper EMA_Name_1],[KlineHelper StrFromDouble:model.EMA1 scale:2]];
                    txt2 = [NSString stringWithFormat:@"%@:%@",[helper EMA_Name_2],[KlineHelper StrFromDouble:model.EMA2 scale:2]];
                    txt3 = [NSString stringWithFormat:@"%@:%@",[helper EMA_Name_3],[KlineHelper StrFromDouble:model.EMA3 scale:2]];
                    if (!kIndicatorModel.selectEMA_1 || !model.EMA1) {
                        txt1 = @"";
                    }
                    if (!kIndicatorModel.selectEMA_2 || !model.EMA2) {
                        txt2 = @"";
                    }
                    if (!kIndicatorModel.selectEMA_3 || !model.EMA3) {
                        txt3 = @"";
                    }
                }break;
                case Y_StockChartType_BOLL:{
                    txt1 = [NSString stringWithFormat:@"%@:%@",@"BOLL",[KlineHelper StrFromDouble:model.BOLL_MB scale:2]];
                    txt2 = [NSString stringWithFormat:@"%@:%@",@"UB",[KlineHelper StrFromDouble:model.BOLL_UP scale:2]];
                    txt3 = [NSString stringWithFormat:@"%@:%@",@"LB",[KlineHelper StrFromDouble:model.BOLL_DN scale:2]];
                }break;
                    
                default:
                    break;
            }
        }
        
        [self.topview_Candle showTxts_txt1:txt1 txt2:txt2 txt3:txt3 txt4:txt4];
        [self.topview_Candle showColors_color1:[KlineHelper MAColor_1] color1:[KlineHelper MAColor_2] color1:[KlineHelper MAColor_3] color1:UIColor.clearColor];
    }
    {
        NSString *txt1 = @"";
        NSString *txt2 = @"";
        NSString *txt3 = @"";
        NSString *txt4 = @"";
        txt1 = [NSString stringWithFormat:@"VOL(%@,%@)",[helper VOL_MA_Name_1],[helper VOL_MA_Name_2]];
        txt2 = [NSString stringWithFormat:@"VOL:%@",[KlineHelper StrFromDouble:model.amount.doubleValue scale:2]];
        
        txt3 = [NSString stringWithFormat:@"MA%@:%@",[helper VOL_MA_Name_1],[KlineHelper StrFromDouble:model.VOL_MA1 scale:2]];
        txt4 = [NSString stringWithFormat:@"MA%@:%@",[helper VOL_MA_Name_2],[KlineHelper StrFromDouble:model.VOL_MA2 scale:2]];
        
        [self.topview_Vol showTxts_txt1:txt1 txt2:txt2 txt3:txt3 txt4:txt4];
        [self.topview_Vol showColors_color1:[KlineHelper indicatorNameColor] color1:[KlineHelper VOLColor_1] color1:[KlineHelper VOLColor_2] color1:[KlineHelper VOLColor_3]];
    }
    {
        NSString *txt1 = @"";
        NSString *txt2 = @"";
        NSString *txt3 = @"";
        NSString *txt4 = @"";
        txt1 = [NSString stringWithFormat:@"%@:%@",helper.MACD_Name,[KlineHelper StrFromDouble:model.MACD scale:2]];
        txt2 = [NSString stringWithFormat:@"DIF:%@",[KlineHelper StrFromDouble:model.MACD_DIF scale:2]];
        txt3 = [NSString stringWithFormat:@"DEA:%@",[KlineHelper StrFromDouble:model.MACD_DEA scale:2]];
        
        [self.topview_MACD showTxts_txt1:txt1 txt2:txt2 txt3:txt3 txt4:txt4];
        [self.topview_MACD showColors_color1:[KlineHelper MACDColor_1] color1:[KlineHelper MACDColor_3] color1:[KlineHelper MACDColor_4] color1:UIColor.clearColor];
    }
    {
        NSString *txt1 = @"";
        NSString *txt2 = @"";
        NSString *txt3 = @"";
        NSString *txt4 = @"";
        txt1 = [NSString stringWithFormat:@"KDJ(%ld,%ld,%ld)",kIndicatorModel.KDJ_Cycle,kIndicatorModel.KDJ_M1,kIndicatorModel.KDJ_M2];
        txt2 = [NSString stringWithFormat:@"K:%.2f",model.KDJ_K];
        txt3 = [NSString stringWithFormat:@"D:%.2f",model.KDJ_D];
        txt4 = [NSString stringWithFormat:@"J:%.2f",model.KDJ_J];
        [self.topview_KDJ showTxts_txt1:txt1 txt2:txt2 txt3:txt3 txt4:txt4];
        [self.topview_KDJ showColors_color1:[KlineHelper KDJColor_1] color1:[KlineHelper KDJColor_2] color1:[KlineHelper KDJColor_3] color1:[KlineHelper KDJColor_4]];
    }
    {
        NSString *txt1 = @"";
        NSString *txt2 = @"";
        NSString *txt3 = @"";
        NSString *txt4 = @"";
        txt1 = [NSString stringWithFormat:@"%@:%.2f",[helper RSI_Name_1],model.RSI_1];
        txt2 = [NSString stringWithFormat:@"%@:%.2f",[helper RSI_Name_2],model.RSI_2];
        txt3 = [NSString stringWithFormat:@"%@:%.2f",[helper RSI_Name_3],model.RSI_3];
        if (!kIndicatorModel.selectRSI_1) {
            txt1 = @"";
        }
        if (!kIndicatorModel.selectRSI_2) {
            txt2 = @"";
        }
        if (!kIndicatorModel.selectRSI_3) {
            txt3 = @"";
        }
        
        
        [self.topview_RSI showTxts_txt1:txt1 txt2:txt2 txt3:txt3 txt4:txt4];
        [self.topview_RSI showColors_color1:[KlineHelper RSIColor_1] color1:[KlineHelper RSIColor_2] color1:[KlineHelper RSIColor_3] color1:UIColor.clearColor];
    }
    {
        NSString *txt1 = @"";
        NSString *txt2 = @"";
        NSString *txt3 = @"";
        NSString *txt4 = @"";
        txt1 = [NSString stringWithFormat:@"%@:%.2f",[helper WR_Name_1],model.WR_1];
        txt2 = [NSString stringWithFormat:@"%@:%.2f",[helper WR_Name_2],model.WR_2];
        
        if (!kIndicatorModel.selectWR_1) {
            txt1 = @"";
        }
        if (!kIndicatorModel.selectWR_2) {
            txt2 = @"";
        }
        
        [self.topview_WR showTxts_txt1:txt1 txt2:txt2 txt3:txt3 txt4:txt4];
        [self.topview_WR showColors_color1:[KlineHelper WRColor_1] color1:[KlineHelper WRColor_2] color1:UIColor.clearColor color1:UIColor.clearColor];
    }
    
}

-(void)getedKlinesData:(NSArray <YTKlineModel *>*)data{

    [self loadArrDatas:data.mutableCopy scrollType:(Y_ScrollType_ToRight) toIndex:0];
    
}

-(void)getedMoreKlineData:(NSArray <YTKlineModel *>*)data{
    NSMutableArray *arrNewDate = data.mutableCopy;
    [arrNewDate addObjectsFromArray:_arrModels];
    
    arrNewDate = [YTKlineModel colculateIndicators:arrNewDate isSokcet:NO];
    
    [self loadArrDatas:arrNewDate scrollType:(Y_ScrollType_ToIndex) toIndex:data.count];

}



-(void)getedOneSocketData:(YTKlineModel *)model{
    if (!_arrModels.count) {
        return;;
    }
    YTKlineModel *lastModel = _arrModels.lastObject;
    
    
    NSInteger index = [_arrModels indexOfObject:lastModel];
    if (model.date.doubleValue==lastModel.date.doubleValue) {
        [_arrModels replaceObjectAtIndex:index withObject:model];
    }else if (model.date.doubleValue>lastModel.date.doubleValue) {
        [_arrModels addObject:model];
    }else{
        [_arrModels addObject:model];//return;
    }
    
    _arrModels = [YTKlineModel colculateIndicators:_arrModels isSokcet:YES];
    [self loadArrDatas:_arrModels scrollType:(Y_ScrollType_Auto) toIndex:0];
}





-(void)addSubViews{
    KlineView_Vol *vol = [KlineView_Vol new];
    KlineView_Candle *candle = [KlineView_Candle new];
    KlineView_MACD *macd = [KlineView_MACD new];
    KlineView_KDJ *kdj = [KlineView_KDJ new];
    KlineView_RSI *rsi = [KlineView_RSI new];
    KlineView_WR *wr = [KlineView_WR new];
    KlineView_Time *time = [KlineView_Time new];;
    
    
    candle.y_stockChartType = Y_StockChartType_BOLL;
    
    _kline_Vol = vol;
    _kline_Candle = candle;
    _kline_Macd = macd;
    _kline_Kdj = kdj;
    _kline_Rsi = rsi;
    _kline_Wr = wr;
    _kline_time = time;
    
    UIStackView *stack = [UIStackView new];
    stack.axis = UILayoutConstraintAxisVertical;
    [self.KlineView_Main addSubview:stack];
    
    BOOL isFull = _isFull;

    if (isFull) {
        [stack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_offset(0);
        }];
    }else{
        [stack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_offset(0);
        }];
    }
    
    
    [stack addArrangedSubview:candle];
    
    if (isFull) {

    }else{
        
        if (_isGuess) {
            [candle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(400-40-40-15);
            }];
        }else{
            [candle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo([KlineHelper heigtOfCandle]);
            }];
        }
        
        
    }
    
    [stack addArrangedSubview:vol];
    [vol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([KlineHelper heigtOfVol]);
    }];
    
    
    
    
    [stack addArrangedSubview:macd];
    [macd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([KlineHelper heigtOfIndicators]);
    }];
    
    [stack addArrangedSubview:kdj];
    [kdj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([KlineHelper heigtOfIndicators]);
    }];
    
    [stack addArrangedSubview:rsi];
    [rsi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([KlineHelper heigtOfIndicators]);
    }];
    
    [stack addArrangedSubview:wr];
    [wr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([KlineHelper heigtOfIndicators]);
    }];
    
    [stack addArrangedSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(15);
    }];
    
    
    _rightView_Candle = [KlineView_RightView new];
    _rightView_Vol = [KlineView_RightView new];
    _rightView_MACD = [KlineView_RightView new];
    _rightView_KDJ = [KlineView_RightView new];
    _rightView_RSI = [KlineView_RightView new];
    _rightView_WR = [KlineView_RightView new];
    
    [self insertSubview:_rightView_Candle belowSubview:self.scMain];
    [_rightView_Candle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.mas_equalTo(self.kline_Candle).mas_offset(RightViewTopSpacing);
        make.bottom.mas_equalTo(self.kline_Candle).mas_offset(-20);
        make.width.mas_equalTo(85);
    }];
    
    
    [self insertSubview:_rightView_Vol belowSubview:self.scMain];
    [_rightView_Vol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.mas_equalTo(self.kline_Vol).mas_offset(20);
        make.bottom.mas_equalTo(self.kline_Vol).mas_offset(-2);
        make.width.mas_equalTo(85);
    }];
    
    
    [self insertSubview:_rightView_MACD belowSubview:self.scMain];
    [_rightView_MACD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.mas_equalTo(self.kline_Macd).mas_offset(20);
        make.bottom.mas_equalTo(self.kline_Macd).mas_offset(-2);
        make.width.mas_equalTo(85);
    }];
    
    
    [self insertSubview:_rightView_KDJ belowSubview:self.scMain];
    [_rightView_KDJ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.mas_equalTo(self.kline_Kdj).mas_offset(20);
        make.bottom.mas_equalTo(self.kline_Kdj).mas_offset(-2);
        make.width.mas_equalTo(85);
    }];
    
    [self insertSubview:_rightView_RSI belowSubview:self.scMain];
    [_rightView_RSI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.mas_equalTo(self.kline_Rsi).mas_offset(20);
        make.bottom.mas_equalTo(self.kline_Rsi).mas_offset(-2);
        make.width.mas_equalTo(85);
    }];
    
    [self insertSubview:_rightView_WR belowSubview:self.scMain];
    [_rightView_WR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(0);
        make.top.mas_equalTo(self.kline_Wr).mas_offset(20);
        make.bottom.mas_equalTo(self.kline_Wr).mas_offset(-2);
        make.width.mas_equalTo(85);
    }];
    
    __block __weak typeof(self) weakSelf =  self;;
    candle.getedRightPricesBlock = ^(NSString * _Nonnull max, NSString * _Nonnull mid, NSString * _Nonnull Min) {
        [weakSelf.rightView_Candle showWith_Max:max mid:mid min:Min];
    };
    
    vol.getedRightPricesBlock = ^(NSString * _Nonnull max, NSString * _Nonnull mid, NSString * _Nonnull Min) {
        [weakSelf.rightView_Vol show_KMB_With_Max:max mid:@"" min:Min];
    };
    
    macd.getedRightPricesBlock = ^(NSString * _Nonnull max, NSString * _Nonnull mid, NSString * _Nonnull Min) {
        [weakSelf.rightView_MACD showWith_Max:max mid:@"" min:Min];
    };
    
    kdj.getedRightPricesBlock = ^(NSString * _Nonnull max, NSString * _Nonnull mid, NSString * _Nonnull Min) {
        [weakSelf.rightView_KDJ showWith_Max:max mid:@"" min:Min];
    };
    
    rsi.getedRightPricesBlock = ^(NSString * _Nonnull max, NSString * _Nonnull mid, NSString * _Nonnull Min) {
        [weakSelf.rightView_RSI showWith_Max:max mid:@"" min:Min];
    };
    
    wr.getedRightPricesBlock = ^(NSString * _Nonnull max, NSString * _Nonnull mid, NSString * _Nonnull Min) {
        [weakSelf.rightView_WR showWith_Max:max mid:@"" min:Min];
    };
    
    
    _topview_Candle = [KlineView_TopView initWithSpacing:5];
    _topview_Vol = [KlineView_TopView initWithSpacing:5];
    _topview_MACD = [KlineView_TopView initWithSpacing:5];
    _topview_KDJ = [KlineView_TopView initWithSpacing:5];
    _topview_RSI = [KlineView_TopView initWithSpacing:5];
    _topview_WR = [KlineView_TopView initWithSpacing:5];
    
    [self addSubview:_topview_Candle];
    [_topview_Candle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.mas_offset(5);
        make.height.mas_equalTo(22);
    }];
    
    [self addSubview:_topview_Vol];
    [_topview_Vol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.mas_equalTo(self.kline_Vol.mas_top).mas_offset(2);
        make.height.mas_equalTo(22);
    }];
    
    [self addSubview:_topview_MACD];
    [_topview_MACD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.mas_equalTo(self.kline_Macd.mas_top).mas_offset(2);
        make.height.mas_equalTo(22);
    }];
    
    [self addSubview:_topview_KDJ];
    [_topview_KDJ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.mas_equalTo(self.kline_Kdj.mas_top).mas_offset(2);
        make.height.mas_equalTo(22);
    }];
    
    [self addSubview:_topview_RSI];
    [_topview_RSI mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.mas_equalTo(self.kline_Rsi.mas_top).mas_offset(2);
        make.height.mas_equalTo(22);
    }];
    
    [self addSubview:_topview_WR];
    [_topview_WR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.mas_equalTo(self.kline_Wr.mas_top).mas_offset(2);
        make.height.mas_equalTo(22);
    }];
    
    
    if (_isGuess) {
        vol.hidden = YES;
        _rightView_Vol.hidden = YES;
        _topview_Vol.hidden = YES;
    }
    
}



/// 重新绘制
-(void)reDrawAll{
    if (_isFull) {
        [self layoutIfNeeded];
        self.arrNeedDrawModels = self.arrNeedDrawModels;
    }else{
        self.arrNeedDrawModels = self.arrNeedDrawModels;
    }
    [self updateNewPriceLayers];
}

/// 提取当前显示区域需要绘制的models
-(NSArray *)bringUpNeedDrawModels{
    if (!self.arrModels.count) {
        self.arrNeedDrawModels = @[].mutableCopy;
        return @[];
    }
    
    NSMutableArray *arrReulst = @[].mutableCopy;
    CGFloat offsetX = self.scMain.contentOffset.x;
    
    NSInteger startIndex = offsetX / (_KlineCandleSpacing + _KlineCandleWid);
    if (startIndex==self.indexOfStartDraw && (startIndex!=0)) {
//        NSLog(@"当前徐绘制的index --%ld",[self.arrNeedDrawModels.firstObject index]);
//        return self.arrNeedDrawModels;
    }
    self.indexOfStartDraw = startIndex;
    NSInteger MaxShowCount = YTScreenWid / (_KlineCandleSpacing + _KlineCandleWid);

    if (startIndex < self.arrModels.count) {
        if ((startIndex + MaxShowCount)<self.arrModels.count) {
            [arrReulst addObjectsFromArray:[self.arrModels subarrayWithRange:NSMakeRange(startIndex, MaxShowCount)]];
        }else{
            [arrReulst addObjectsFromArray:[self.arrModels subarrayWithRange:NSMakeRange(startIndex, self.arrModels.count - startIndex)]];
        }
        
    }
    self.arrNeedDrawModels = arrReulst;
//    NSLog(@"当前徐绘制的index --%ld",[self.arrNeedDrawModels.firstObject index]);
    return arrReulst;
}


/// 设置scorllView宽
-(void)resetScrollViewWidth{
    
    {//设置右侧间距
        CGFloat wid = 60;
        YTKlineModel *lastModel = _arrModels.lastObject;
        if (lastModel) {
            wid = [KlineHelper getTxtWid:lastModel.close font:[KlineHelper RightTxtFont]]+10;;
            if (wid<60) {
                wid = 60;
            }
        }
        wid = (int)wid/10*10+10;
        _rightNewPriceWid = wid;
        
    }
    [_scMain setContentSize:CGSizeMake([self drawRectWid] + _rightNewPriceWid, 0)];
    self.KlineView_Main.frame = CGRectMake(0, 0, [self drawRectWid] + _rightNewPriceWid, self.frame.size.height);//qqHeight-44-40
    [self layoutIfNeeded];
    
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
//    画线
}



/// K线绘制区域宽度
-(CGFloat)drawRectWid{
    NSInteger KlineCount = _arrModels.count;//K线数据条数
    return KlineCount * (_KlineCandleSpacing + _KlineCandleWid);
}


#pragma mark GestureRecognizers

-(YTKlineModel *)findModelFromPoint:(CGPoint)point{
    
    CGFloat X = point.x;
    if (self.arrModels.count) {
        NSInteger index = X/(_KlineCandleSpacing + _KlineCandleWid);
        if (index >= (self.arrModels.count-1)) {
            index = (self.arrModels.count-1);
        }
        return _arrModels[index];
    }
    return nil;
}

-(void)longPressMethod:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan || longPress.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [longPress locationInView:self.scMain];
        
        {//超出边界
            if (location.x < _scMain.contentOffset.x) {
                return;;
            }
            if (location.x > (_scMain.contentOffset.x + _scMain.frame.size.width)) {
                return;;
            }
        }
        
        
        YTKlineModel *model = [self findModelFromPoint:location];
        self.currentSelectKlineModel = model;
        [self showKlineDetail];
    }
}

-(void)singleTapMethod:(UITapGestureRecognizer *)singleTap{
    CGPoint location = [singleTap locationInView:self.scMain];
    YTKlineModel *model = [self findModelFromPoint:location];
    self.currentSelectKlineModel = model;
    [self showKlineDetail];
}

-(void)pinchMethod:(UIPinchGestureRecognizer *)pinch{
    _currentSelectKlineModel = nil;
    
    if (pinch.state==UIGestureRecognizerStateBegan) {
        _currentPinchScale = pinch.state;
    }
    if (pinch.state==UIGestureRecognizerStateChanged) {
        CGFloat oldScale = _currentPinchScale;
        
        if (ABS(pinch.scale-oldScale) < YT_Kline_PichScaleMin) {
            return;;
        }
        if (pinch.scale > oldScale) {
            _KlineCandleWid += 0.5;
            if (_KlineCandleWid >= YT_Kline_CandleMaxWid) {
                if (_KlineCandleWid==YT_Kline_CandleMaxWid) {
                    return;;
                }
                
                _KlineCandleWid = YT_Kline_CandleMaxWid;
            }
        }
        if (pinch.scale < oldScale) {
            _KlineCandleWid -= 0.5;
            if (_KlineCandleWid <= YT_Kline_CandleMinWid) {
                if (_KlineCandleWid == YT_Kline_CandleMinWid) {
                    return;;
                }
                _KlineCandleWid = YT_Kline_CandleMinWid;
            }
        }
        _currentPinchScale = pinch.scale;
    }
    
    self.KlineCandleWid = _KlineCandleWid;
    
    NSInteger oldIndex = [self.arrNeedDrawModels.firstObject index];
    
    
    [self resetScrollViewWidth];
    
    [self.scMain setContentOffset:CGPointMake(oldIndex*(_KlineCandleSpacing + _KlineCandleWid), 0) animated:NO];
    [self bringUpNeedDrawModels];
}

#pragma mark BtnEvent

#pragma mark NetWorking

#pragma mark ------------------分割线----------------

#pragma mark Setters & Getters
- (void)setShowMACD:(BOOL)showMACD{
    _showMACD = showMACD;
    self.kline_Macd.hidden = !showMACD;
    self.topview_MACD.hidden = !showMACD;
    self.rightView_MACD.hidden = !showMACD;
    
    [self reDrawAll];
    
}
- (void)setShowKDJ:(BOOL)showKDJ{
    _showKDJ = showKDJ;
    self.kline_Kdj.hidden = !showKDJ;
    self.topview_KDJ.hidden = !showKDJ;
    self.rightView_KDJ.hidden = !showKDJ;
    
    [self reDrawAll];
}
- (void)setShowRSI:(BOOL)showRSI{
    _showRSI = showRSI;
    self.kline_Rsi.hidden = !showRSI;
    self.topview_RSI.hidden = !showRSI;
    self.rightView_RSI.hidden = !showRSI;
    
    [self reDrawAll];
}
- (void)setShowWR:(BOOL)showWR{
    _showWR = showWR;
    self.kline_Wr.hidden = !_showWR;
    self.topview_WR.hidden = !_showWR;
    self.rightView_WR.hidden = !_showWR;
    
    [self reDrawAll];
}

- (void)setIsLoadingMore:(BOOL)isLoadingMore{
    _isLoadingMore = isLoadingMore;
    if (isLoadingMore) {
        [self.loadingView startAnimating];
    }else{
        [self.loadingView stopAnimating];
    }
}

- (void)setCurrentSelectKlineModel:(YTKlineModel *)currentSelectKlineModel{
    _currentSelectKlineModel = currentSelectKlineModel;
    if (!currentSelectKlineModel) {
        [self clearDetailViews];
    }
    [self updateTopPrices];
}
- (void)setKlineCandleWid:(CGFloat)KlineCandleWid{
    _KlineCandleWid = KlineCandleWid;
    
    self.kline_Candle.KlineCandleWid = KlineCandleWid;
    self.kline_Vol.KlineCandleWid = KlineCandleWid;
    self.kline_Macd.KlineCandleWid = KlineCandleWid;
    self.kline_Kdj.KlineCandleWid = KlineCandleWid;
    self.kline_Rsi.KlineCandleWid = KlineCandleWid;
    self.kline_Wr.KlineCandleWid = KlineCandleWid;
    self.kline_time.KlineCandleWid = KlineCandleWid;
}
- (void)setKlineCandleSpacing:(CGFloat)KlineCandleSpacing{
    _KlineCandleSpacing = KlineCandleSpacing;
    
    self.kline_Candle.KlineCandleSpacing = KlineCandleSpacing;
    self.kline_Vol.KlineCandleSpacing = KlineCandleSpacing;
    self.kline_Macd.KlineCandleSpacing = KlineCandleSpacing;
    self.kline_Kdj.KlineCandleSpacing = KlineCandleSpacing;
    self.kline_Rsi.KlineCandleSpacing = KlineCandleSpacing;
    self.kline_Wr.KlineCandleSpacing = KlineCandleSpacing;
    self.kline_time.KlineCandleSpacing = KlineCandleSpacing;
}

- (void)setY_stockChartType:(Y_StockChartType)y_stockChartType{
    _y_stockChartType= y_stockChartType;
    _kline_Candle.y_stockChartType = y_stockChartType;
    
    [_kline_Candle reDraw];
    [self updateTopPrices];
}

- (void)setArrNeedDrawModels:(NSMutableArray *)arrNeedDrawModels{
    _arrNeedDrawModels = arrNeedDrawModels;

    self.kline_Candle.arrNeedDrawModels = arrNeedDrawModels;
    self.kline_Vol.arrNeedDrawModels = arrNeedDrawModels;
    self.kline_Macd.arrNeedDrawModels = arrNeedDrawModels;
    self.kline_Kdj.arrNeedDrawModels = arrNeedDrawModels;
    self.kline_Rsi.arrNeedDrawModels = arrNeedDrawModels;
    self.kline_Wr.arrNeedDrawModels = arrNeedDrawModels;
    self.kline_time.arrNeedDrawModels = arrNeedDrawModels;
    
}

-(void)loadArrDatas:(NSMutableArray *)arrModels scrollType:(Y_ScrollType)y_scrollType toIndex:(NSInteger)index{
    for (int i = 0; i<arrModels.count; i++) {
        YTKlineModel *model = arrModels[i];
        model.index = i;
    }
    
    _arrModels = arrModels;
    
    
    [self resetScrollViewWidth];
    
    switch (y_scrollType) {
        case Y_ScrollType_Auto:{
            if ((_scMain.contentOffset.x + _scMain.frame.size.width + _KlineCandleWid * 2) >= _scMain.contentSize.width) {
                [self scrollToRight];
            }
        }break;
        case Y_ScrollType_ToIndex:{
            [_scMain setContentOffset:CGPointMake(index*(_KlineCandleWid + _KlineCandleSpacing)-_KlineCandleWid/2, 0)];//滚动到新数据的最后一条位置
        }break;
        case Y_ScrollType_ToRight:{
            [self scrollToRight];
        }break;
            
        default:
            break;
    }
    
    
    
    
    
    
    [self bringUpNeedDrawModels];
    
    [self updateTopPrices];
    [self updateNewPriceLayers];
    
}


#pragma mark LazyLoad
-(UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] init];
        _loadingView.frame = CGRectMake(15,[KlineHelper heigtOfVol]/2 , 30, 30);
        _loadingView.backgroundColor = UIColor.blueColor;
        _loadingView.color = UIColor.redColor;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}
-(KlineView_TipBoard *)tipBoard{
    if (!_tipBoard) {
        _tipBoard = [KlineView_TipBoard new];
        __block __weak typeof(self) weakSelf =  self;;
        _tipBoard.singleTapBlock = ^{
            weakSelf.currentSelectKlineModel = nil;
            [weakSelf clearDetailViews];
        };
        [self addSubview:_tipBoard];
        _tipBoard.hidden = YES;
        
    }
    return _tipBoard;
}

-(UIView *)KlineView_Main{
    if (!_KlineView_Main) {
        _KlineView_Main = [UIView new];
        [self.scMain addSubview:_KlineView_Main];
    }
    return _KlineView_Main;
}

-(UIScrollView *)scMain{
    if (!_scMain) {
        _scMain = [UIScrollView new];
        _scMain.delegate = self;
        _scMain.bounces = NO;
        _scMain.showsVerticalScrollIndicator = NO;
        _scMain.showsHorizontalScrollIndicator = NO;
//        _scMain.backgroundColor = UIColor.redColor;
        _scMain.minimumZoomScale = 1;
        _scMain.maximumZoomScale = 1;
        [self addSubview:_scMain];
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchMethod:)];
        [_scMain addGestureRecognizer:pinch];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapMethod:)];
        [_scMain addGestureRecognizer:singleTap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
        [_scMain addGestureRecognizer:longPress];
        
        [_scMain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.top.mas_offset(0);
        }];
    }
    return _scMain;
}

#pragma mark SetUp & Init




@end
