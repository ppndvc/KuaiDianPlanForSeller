//
//  KDBusinessStatisticsViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/27.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDBusinessStatisticsViewController : KDBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *todaySaleLabel;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;
@property (weak, nonatomic) IBOutlet UILabel *totalSaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlinePayLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *kudadianAllowanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *restAllowanceLabel;

@end
