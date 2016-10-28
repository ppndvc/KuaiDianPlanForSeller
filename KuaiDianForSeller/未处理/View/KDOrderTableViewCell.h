//
//  KDOrderTableCellTableViewCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/21.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseTableViewCell.h"
#import "KDOrderModel.h"


@interface KDOrderTableViewCell : KDBaseTableViewCell

//次序
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//下单时间
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
//取货时间
@property (weak, nonatomic) IBOutlet UILabel *pickUpTimeLabel;
//取货码
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//用户号码
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
//备注
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
//菜品详情
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//按钮
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet UIView *bottomSpaceView;

//点击用户电话号码事件
- (IBAction)onTapPhoneNumber:(id)sender;
//点击按钮事件
- (IBAction)onTapActionButton:(id)sender;

//配置cell
-(void)configureCellWithModel:(KDOrderModel *)model;
@end
