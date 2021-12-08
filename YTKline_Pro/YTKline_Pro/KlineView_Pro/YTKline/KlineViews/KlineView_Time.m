//
//  KlineView_Time.m
//  KlineDemo
//
//  Created by 于涛 on 2021/11/17.
//

#import "KlineView_Time.h"
#import "YTKlineHeader.h"
@interface KlineView_Time ()
@property (nonatomic,retain) NSMutableArray *arrDates;
@end

@implementation KlineView_Time

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)modesToPoints{
    if (!_arrNeedDrawModels.count) {
        return;;
    }
    
    _arrDates = @[].mutableCopy;
    NSInteger count = _arrNeedDrawModels.count * (_KlineCandleWid + _KlineCandleSpacing) / ([self widOfDataString] + 20);
    if (count==0) {
        count = _arrNeedDrawModels.count;
    }else{
        count = _arrNeedDrawModels.count/count + 1;
    }
    
    

    for (int i = 0; i<_arrNeedDrawModels.count; i++) {
        YTKlineModel *model = _arrNeedDrawModels[i];
        if (i % count==0) {
            CGFloat X = (model.index + 1) * (_KlineCandleWid + _KlineCandleSpacing) - _KlineCandleWid/2;
            CGFloat Y = 0;
            CGPoint point = CGPointMake(X, Y);
            NSString *date = [KlineHelper timeStampToString:model.date formatter:@"MM-dd HH:mm"];
            
            KlineDateModel *dateMd = [KlineDateModel initWithPoint:point dataStamp:date];
            [_arrDates addObject:dateMd];
        }
    }
}

-(void)drawAllLinesAndCandle{
    {
        for (CALayer *layer in self.layer.sublayers.mutableCopy) {
            [layer removeFromSuperlayer];
        }
    }
    {
        for (KlineDateModel *dateMd in _arrDates) {
            
            UIFont *font = [KlineHelper RightTxtFont];
            CGFloat wid = [KlineHelper getTxtWid:dateMd.stringStamp font:font];
            CATextLayer *layer = [CAShapeLayer createDateTextLayer:dateMd.stringStamp txtColor:[KlineHelper RightTxtColor] frame:CGRectMake(dateMd.point.x, 0, wid, 13.5) font:font];
            [self.layer addSublayer:layer];
        }
    }
}


- (void)setArrNeedDrawModels:(NSMutableArray *)arrNeedDrawModels{
    _arrNeedDrawModels = arrNeedDrawModels;
    
    [self modesToPoints];
    [self drawAllLinesAndCandle];
}


-(CGFloat)widOfDataString{
    return [KlineHelper getTxtWid:@"MM-dd mm:ss" font:[KlineHelper RightTxtFont]];
}

-(void)clearAllLayers{
    for (CALayer *layer in self.layer.sublayers.mutableCopy) {
        [layer removeFromSuperlayer];
    }
}


@end



@implementation KlineDateModel

+(instancetype)initWithPoint:(CGPoint)point dataStamp:(NSString *)stamp{
    KlineDateModel *model = [KlineDateModel new];
    model.point = point;
    model.stringStamp = stamp;
    return model;;
}

@end
