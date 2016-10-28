//
//  KDHandleListTableCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/1.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseTableViewCell.h"

#define TABLECELL_HEIGHT 54

@class KDOrderModel;

@interface KDHandleListTableCell : KDBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)onTapActionButton:(id)sender;

//配置cell
-(void)configureCellWithModel:(KDOrderModel *)model;

@end
