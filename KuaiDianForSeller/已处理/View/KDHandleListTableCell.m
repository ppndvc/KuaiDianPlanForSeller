//
//  KDHandleListTableCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/1.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDHandleListTableCell.h"
#import "KDOrderModel.h"

@interface KDHandleListTableCell()

@property(nonatomic,strong)KDOrderModel *model;

@end

@implementation KDHandleListTableCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

//配置cell
-(void)configureCellWithModel:(KDOrderModel *)model
{
    if (model)
    {
        _model = model;
        self.nameLabel.text = model.orderDescriptionString;
        self.codeLabel.text = model.orderID;
        
        if (model.orderStatus < KDOrderStatusOfSuccessButNoEvaluated)
        {
            self.actionButton.enabled = YES;
        }
        else
        {
            self.actionButton .enabled = NO;
        }
    }
}

- (IBAction)onTapActionButton:(id)sender
{
}
@end
