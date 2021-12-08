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

-(void)addsubView{

}


-(void)relaodData{
    [self getDataData];
}


/// 模拟重连socket
-(void)reConnectSocket{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reConnectSocket) object:nil];
    [self performSelector:@selector(reConnectSocket) withObject:nil afterDelay:1];
    [self getSocketData];
}


/// 模拟断开socket
-(void)deConnectSocket{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getSocketData) object:nil];
}




-(void)getSocketData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KlineData_Socket" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
    

    if (dic && [dic[@"errno"] intValue]==0) {
        NSArray *arr = dic[@"data"];
        
        NSInteger index = arc4random()%(arr.count);
        NSLog(@"随机%ld",index);
        NSDictionary *dic = arr[index];
        
        [self reloadOneKilneData:dic];
    }
    
    
    
    
}

-(void)getDataData{
    [self.klineView clearAllDatas];
    
    //模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"KlineData" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        
        NSArray *arr = dic[@"data"];
        [self getedData:arr];
        [self reConnectSocket];
        
    });
    
    
}

-(void)getMoreKline:(YTKlineModel *)firstModel{
    //模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"KlineData_More" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        
        NSArray *arr = dic[@"data"];
        [self getedMoreData:arr];

    });
}



-(void)getedData:(NSArray *)arrKlines{
    NSMutableArray *arrResult = @[].mutableCopy;
    for (NSDictionary *dic in arrKlines) {
        YTKlineModel *model = [YTKlineModel yy_modelWithDictionary:dic];
        [arrResult addObject:model];
    }
    arrResult = [[arrResult reverseObjectEnumerator] allObjects].mutableCopy;
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
    arrResult = [[arrResult reverseObjectEnumerator] allObjects].mutableCopy;
    
    [self.klineView getedMoreKlineData:arrResult];
}
-(void)reloadOneKilneData:(NSDictionary *)dic{
    YTKlineModel *model = [YTKlineModel yy_modelWithDictionary:dic];
    [self.klineView getedOneSocketData:model];
}

#pragma mark NetWorki
#pragma mark ------------------分割线----------------

#pragma mark Setters & Getters

#pragma mark LazyLoad

-(YTKlineView *)klineView{
    if (!_klineView) {
        _klineView = [[YTKlineView alloc] initWithFrame:CGRectZero];
        [self addSubview:_klineView];
        [_klineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_offset(0);
        }];
        
        __block __weak typeof(self) weakSelf =  self;;
        _klineView.loadMoreBlock = ^(YTKlineModel * _Nonnull firstModel) {
            [weakSelf getMoreKline:firstModel];
        };
    }
    return _klineView;
}

#pragma mark SetUp & Init



@end
