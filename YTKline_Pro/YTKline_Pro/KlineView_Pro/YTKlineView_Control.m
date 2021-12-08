//
//  YTKlineView_Control.m
//  Aofex
//
//  Created by 于涛 on 2021/11/19.
//  Copyright © 2021 brc. All rights reserved.
//
#import "YTKlineView_Control.h"
#import "YYModel.h"

#define LoadMoreNumsOfPage 200

@interface YTKlineView_Control()



@property (nonatomic,retain) NSMutableDictionary *param;
@end

@implementation YTKlineView_Control

+(instancetype)create{
    YTKlineView_Control *view = [YTKlineView_Control new];
    [view addsubView];
    return view;
}
#pragma mark LifeCycle

#pragma mark TableDelegate & DataSource

#pragma mark ScrollViewDelegate

#pragma mark CusMethod

-(NSInteger )getTimeStampWithType:(NSInteger)index{
    switch (index) {
        case 0:
        case 1:{
            return 60;
        }break;
        case 2:{
            return 60*5;
        }break;
        case 3:{
            return 60*15;
        }break;
        case 4:{
            return 60*30;
        }break;
        case 5:{
            return 60*60;
        }break;
        case 6:{
            return 60*60*4;
        }break;
        case 7:{
            return 60*60*6;
        }break;
        case 8:{
            return 60*60*12;
        }break;
        case 9:{
            return 60*60*24;
        }break;
        case 10:{
            return 60*60*24*7;
        }break;
        case 11:{
            return 60*60*24*30;
        }break;
        default:
            break;
    }
    return 0;
}

-(void)reloadOneKilneData:(NSDictionary *)dic{
    YTKlineModel *model = [YTKlineModel yy_modelWithDictionary:dic];
    [self.klineView getedOneSocketData:model];
}


-(void)relaodData{
    [self getDataData];
}



-(void)addsubView{
    self.klineView.backgroundColor = UIColor.clearColor;
    
}
#pragma mark BtnEvent

-(void)getDataData{
    [self deConnect];
    [self.klineView clearAllDatas];
    
}

-(void)getMoreKline:(YTKlineModel *)firstModel{
    
}



-(void)getedData:(NSArray *)arrKlines{
    NSMutableArray *arrResult = @[].mutableCopy;
    for (NSDictionary *dic in arrKlines) {
        YTKlineModel *model = [YTKlineModel yy_modelWithDictionary:dic];
        [arrResult addObject:model];
    }
    arrResult = [[arrResult reverseObjectEnumerator] allObjects];
    [YTKlineModel colculateIndicators:arrResult isSokcet:NO];
    [self.klineView getedKlinesData:arrResult];
    
}
-(void)getedMoreData:(NSArray *)arrKlines{
    if (!arrKlines.count) {
        return;;
    }
    NSMutableArray *arrResult = @[].mutableCopy;
    for (NSDictionary *dic in arrKlines) {
        YTKlineModel *model = [YTKlineModel yy_modelWithDictionary:dic];
        [arrResult addObject:model];
    }
    arrResult = [[arrResult reverseObjectEnumerator] allObjects];
    [self.klineView getedMoreKlineData:arrResult];
}

#pragma mark NetWorki
#pragma mark ------------------分割线----------------

#pragma mark Setters & Getters

#pragma mark LazyLoad



-(YTKlineView *)klineView{
    if (!_klineView) {
        _klineView = [[YTKlineView alloc] initWithFrame:CGRectZero];
        [self addSubview:_klineView];
        
       
        
        __block __weak typeof(self) weakSelf =  self;;
        _klineView.loadMoreBlock = ^(YTKlineModel * _Nonnull firstModel) {
            [weakSelf getMoreKline:firstModel];
        };
        
    }
    return _klineView;
}


#pragma mark SetUp & Init


@end
