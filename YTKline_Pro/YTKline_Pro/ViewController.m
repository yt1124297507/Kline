//
//  ViewController.m
//  YTKline_Pro
//
//  Created by 于涛 on 2021/12/8.
//

#import "ViewController.h"
#import "YTKlineView_Control.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *viKlineBG;

@property (nonatomic,retain) YTKlineView_Control *KlineView;

@property (nonatomic,assign) BOOL showTime;

@property (nonatomic,assign) BOOL show1;
@property (nonatomic,assign) BOOL show2;
@property (nonatomic,assign) BOOL show3;
@property (nonatomic,assign) BOOL show4;

@end

@implementation ViewController

- (void)viewDidLayoutSubviews{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YTKlineView_Control *klineView = [YTKlineView_Control create];
    [klineView relaodData];
    
    [_viKlineBG addSubview:klineView];
    _KlineView = klineView;
    [klineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_offset(0);
        make.top.mas_offset(0);
        make.trailing.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
    
    // Do any additional setup after loading the view.
}



- (IBAction)btnPress:(UIButton *)sender {
//    [_KlineView.klineView setCurrentIsOneMinuteModel:YES];
    switch (sender.tag) {
        case 0:{
            self.KlineView.klineView.y_stockChartType = Y_StockChartType_None;
        }break;
        case 1:{
            self.showTime = !self.showTime;

            [_KlineView.klineView setCurrentIsOneMinuteModel:self.showTime];
        }break;
        case 2:{
            self.KlineView.klineView.y_stockChartType = Y_StockChartType_MA;
        }break;
        case 3:{
            self.KlineView.klineView.y_stockChartType = Y_StockChartType_EMA;
        }break;
        case 4:{
            self.KlineView.klineView.y_stockChartType = Y_StockChartType_BOLL;
        }break;
        case 5:{
            self.show1 = !self.show1;
            self.KlineView.klineView.showMACD = self.show1;
        }break;
        case 6:{
            self.show2 = !self.show2;
            self.KlineView.klineView.showKDJ = self.show2;
        }break;
        case 7:{
            self.show3 = !self.show3;
            self.KlineView.klineView.showRSI = self.show3;
        }break;
        case 8:{
            self.show4 = !self.show4;
            self.KlineView.klineView.showWR = self.show4;
        }break;
            
        default:
            break;
    }
}


@end
