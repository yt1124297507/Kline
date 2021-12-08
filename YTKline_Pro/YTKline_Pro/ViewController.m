//
//  ViewController.m
//  YTKline_Pro
//
//  Created by 于涛 on 2021/12/8.
//

#import "ViewController.h"
#import "YTKlineView_Control.h"
@interface ViewController ()

@property (nonatomic,retain) YTKlineView_Control *KlineView;

@end

@implementation ViewController

- (void)viewDidLayoutSubviews{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YTKlineView_Control *klineView = [YTKlineView_Control create];
    [klineView relaodData];
    
    [self.view addSubview:klineView];
    _KlineView = klineView;
    [klineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(40);
        make.top.mas_offset(40);
        make.trailing.mas_offset(-40);
        make.bottom.mas_offset(-20);
    }];
    
    // Do any additional setup after loading the view.
}




@end
