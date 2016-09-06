//
//  KDMyMoneyViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/23.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDMyMoneyViewController : KDBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
- (IBAction)onTapChargeButton:(id)sender;
@end
