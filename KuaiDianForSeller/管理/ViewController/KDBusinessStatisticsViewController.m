//
//  KDBusinessStatisticsViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/27.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBusinessStatisticsViewController.h"
#import "PNChart.h"
#import "KDSaleStatisticInfoModel.h"
#import "KDBusinessStatisticsViewModel.h"
#import "KDPickerView.h"

#define X_CHART_UNIT @""
#define Y_CHART_UNIT @"Y"

#define INVALIDATE_DATE_TITLE @"请选择正确的统计日期"

@interface KDBusinessStatisticsViewController ()

@property(nonatomic,strong)PNLineChart *lineChart;

@property(nonatomic,strong)KDBusinessStatisticsViewModel *viewModel;

@end

@implementation KDBusinessStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    self.navigationItem.title = SALE_DETAIL_TITLE;
    _viewModel = [[KDBusinessStatisticsViewModel alloc] init];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startRequestStatisticInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI
{
    _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _chartView.frame.size.height)];
    [_lineChart setXLabelColor:[UIColor whiteColor]];
    [_lineChart setYLabelColor:[UIColor whiteColor]];
    _lineChart.backgroundColor = [UIColor clearColor];
    _lineChart.showYGridLines = YES;
    _lineChart.showCoordinateAxis = YES;
    _lineChart.yGridLinesColor = SEPERATOR_COLOR;
    _lineChart.axisColor = SEPERATOR_COLOR;

    [_chartView addSubview:_lineChart];
    _chartView.backgroundColor = [UIColor clearColor];
    
    NSString *startDate = _viewModel.getStartString;
    NSString *endDate = _viewModel.getEndDateString;
    if (VALIDATE_STRING(startDate))
    {
        NSArray *array = [startDate componentsSeparatedByString:@" "];
        if (VALIDATE_ARRAY(array))
        {
            [self setBTN:_startDateButton title:array[0] underLine:YES];

        }
    }
    
    if (VALIDATE_STRING(endDate))
    {
        NSArray *array = [endDate componentsSeparatedByString:@" "];
        if (VALIDATE_ARRAY(array))
        {
            [self setBTN:_endDateButton title:array[0] underLine:YES];
        }
    }
    
    if (VALIDATE_DICTIONARY(self.parameters))
    {
        KDSaleStatisticInfoModel *model = [self.parameters objectForKey:TODAY_SALE_STATISTIC_INFO];
        if (VALIDATE_MODEL(model, @"KDSaleStatisticInfoModel"))
        {
            _todaySaleLabel.text = [NSString stringWithFormat:@"%.2f", model.money];
        }
    }
}

-(void)startRequestStatisticInfo
{
    WS(ws);
    [_viewModel startRequestSaleStatisticInfoWithBeginBlock:^{
        
        [ws showHUD];
        
    } completeBlock:^(BOOL isSuccess, NSArray *params, NSError *error) {
        if (isSuccess)
        {
            [ws hideHUD];
            if (VALIDATE_ARRAY(params))
            {
                [ws handleStatisticInfo:params];
            }
        }
        else
        {
            if (error)
            {
                [ws showErrorHUDWithStatus:error.localizedDescription];
            }
            else
            {
                [ws showErrorHUDWithStatus:HTTP_REQUEST_ERROR];
            }
        }
    }];
}
-(void)handleStatisticInfo:(NSArray *)infoArray
{
    if (VALIDATE_ARRAY(infoArray))
    {
        NSMutableArray *dateArray = [[NSMutableArray alloc] initWithCapacity:infoArray.count];
        NSMutableArray *valueArray = [[NSMutableArray alloc] initWithCapacity:infoArray.count];
        
        for (int index = 0 ; index < infoArray.count ; index ++)
        {
            KDSaleStatisticInfoModel *model = infoArray[index];
            NSString *dateStr = [NSString getTimeString:model.date formater:MM_DD_DATE_FORMATER];
            NSString *valueStr = [NSString stringWithFormat:@"%d",(int)model.money];
            
            if (VALIDATE_STRING(dateStr) && VALIDATE_STRING(valueStr))
            {
                [dateArray addObject:dateStr];
                [valueArray addObject:valueStr];
            }
        }
        
        if (VALIDATE_ARRAY(dateArray) && _lineChart)
        {
            [_lineChart setXLabels:dateArray];
            
            PNLineChartData *firstData = [PNLineChartData new];
            firstData.color = PNWhite;
            firstData.showPointLabel = YES;
            firstData.pointLabelColor = PNDeepGrey;
            firstData.pointLabelFont = [UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE];
            
            firstData.inflexionPointStyle =PNLineChartPointStyleCircle;
            firstData.itemCount = _lineChart.xLabels.count;
            firstData.getData = ^(NSUInteger index) {
                CGFloat yValue = [valueArray[index] floatValue];
                return [PNLineChartDataItem dataItemWithY:yValue];
            };
            
            _lineChart.chartData = @[firstData];
            [_lineChart strokeChart];
        }

    }
}

-(void)setBTN:(UIButton *)btn title:(NSString *)title underLine:(BOOL)underLine
{
    if (VALIDATE_MODEL(btn, @"UIButton"))
    {
        if (underLine)
        {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
            NSRange strRange = {0,[str length]};
            [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitle:title forState:UIControlStateNormal];
        }
    }
}
- (IBAction)onTapStartDateButton:(id)sender
{
    KDPickerView *startPicker = [[KDPickerView alloc] initWithType:KDDatePickerTypeOfDate];

    WS(ws);
    JCAlertView *alertView = [[JCAlertView alloc] initWithCustomView:startPicker ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:BUTTON_TITLE_CANCEL Click:^{
        
    } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:BUTTON_TITLE_SURE Click:^{
        NSArray *resultArray = [startPicker getPickerData];
        if (VALIDATE_ARRAY(resultArray))
        {
            NSDate *date = [resultArray firstObject];
            if (VALIDATE_MODEL(date, @"NSDate"))
            {
                NSString *startStringTitle = [NSString getTimeStringWithDate:date formater:YYYY_MM_DD_DATE_FORMATER];
                if (VALIDATE_STRING(startStringTitle))
                {
                    NSString *startString = [NSString stringWithFormat:@"%@ 00:00:00",startStringTitle];
                    [ws.viewModel setStartString:startString];
                    [ws setBTN:ws.startDateButton title:startStringTitle underLine:YES];
                }
            }
        }
        
    } dismissWhenTouchedBackground:YES];
    
    [alertView show];
}

- (IBAction)onTapEndDateButton:(id)sender
{
    KDPickerView *startPicker = [[KDPickerView alloc] initWithType:KDDatePickerTypeOfDate];
    
    WS(ws);
    JCAlertView *alertView = [[JCAlertView alloc] initWithCustomView:startPicker ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:BUTTON_TITLE_CANCEL Click:^{
        
    } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:BUTTON_TITLE_SURE Click:^{
        NSArray *resultArray = [startPicker getPickerData];
        if (VALIDATE_ARRAY(resultArray))
        {
            NSDate *date = [resultArray firstObject];
            if (VALIDATE_MODEL(date, @"NSDate"))
            {
                NSString *endStringTitle = [NSString getTimeStringWithDate:date formater:YYYY_MM_DD_DATE_FORMATER];
                if (VALIDATE_STRING(endStringTitle))
                {
                    NSString *endString = [NSString stringWithFormat:@"%@ 23:59:59",endStringTitle];
                    [ws.viewModel setEndDateString:endString];
                    [ws setBTN:ws.endDateButton title:endStringTitle underLine:YES];
                }
            }
        }
        
    } dismissWhenTouchedBackground:YES];
    
    [alertView show];
}

- (IBAction)onTapTodayButton:(id)sender
{
    if ([NSString compareDateString:_startDateButton.titleLabel.text withDate:_endDateButton.titleLabel.text dateFormater:YYYY_MM_DD_DATE_FORMATER] == NSOrderedAscending)
    {
        [self startRequestStatisticInfo];
    }
    else
    {
        [self showErrorHUDWithStatus:INVALIDATE_DATE_TITLE];
    }
}

-(void)dealloc
{
    DDLogInfo(@"-KDBusinessStatisticsViewController dealloc");
}
@end
