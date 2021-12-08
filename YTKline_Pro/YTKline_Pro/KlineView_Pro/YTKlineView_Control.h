//
//  YTKlineView_Control.h
//  Aofex
//
//  Created by 于涛 on 2021/11/19.
//  Copyright © 2021 brc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTKlineView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YTKlineView_Control : UIView


@property (nonatomic,retain) YTKlineView *klineView;

+(instancetype)create;

-(void)relaodData;

@end

NS_ASSUME_NONNULL_END
