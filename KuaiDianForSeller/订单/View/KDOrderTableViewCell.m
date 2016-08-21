//
//  KDOrderTableViewCell.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/6.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDOrderTableViewCell.h"
#import "YYWebImage.h"

#define YUAN_STRING @"元"
#define PICKUP_PREFIX @"取货码："

@interface KDOrderTableViewCell()

//保存的model
@property(nonatomic,strong)KDOrderModel *model;

@end

@implementation KDOrderTableViewCell

-(void)prepareForReuse
{
    _titleLabel.text = nil;
    _subTitleLabel.text = nil;
    _detailLabel.text = nil;
    _priceLabel.text = nil;
    _actionButton.enabled = NO;
    _statusLabel.text = nil;
    _processLabel.text = nil;
    _codeLabel.attributedText = nil;
}

-(void)configureCellModel:(KDOrderModel *)model
{
    if (model)
    {
        _model = model;
        _titleLabel.text = model.shopName;
//        NSURL *url = [[NSURL alloc] initWithString:model.imageURL];
//        [_iconImageView yy_setImageWithURL:url placeholder:nil];
//        _subTitleLabel.text = model.foodDescriptionString;
        _detailLabel.text = [NSString weiboFormateTimeWithTimeInterval:model.createTime];
        _priceLabel.text = [NSString stringWithFormat:@"%.1f %@",model.totalPrice,YUAN_STRING];
        
        switch (model.orderStatus)
        {
            case KDOrderStatusOfNotCharged:
            {
                [_actionButton setTitle:BEING_CHARGE_BUTTON_TITLE forState:UIControlStateNormal];
                _actionButton.enabled = YES;
                _statusLabel.text = nil;
                _processLabel.text = nil;
                _codeLabel.attributedText = nil;
            }
                break;
            case KDOrderStatusOfNotAccepted:
            {
                [_actionButton setTitle:ALREADY_CHARGED_BUTTON_TITLE forState:UIControlStateNormal];
                _actionButton.enabled = NO;
                _statusLabel.text = ORDER_NOT_ACCEPTED;
                _processLabel.text = model.orderDescriptionString;
                _codeLabel.attributedText = nil;
            }
                break;
            case KDOrderStatusOfAlreadyAccepted:
            {
                [_actionButton setTitle:ALREADY_CHARGED_BUTTON_TITLE forState:UIControlStateNormal];
                _actionButton.enabled = NO;
                _statusLabel.text = ORDER_HAS_ACCEPTED;
                _processLabel.text = model.orderDescriptionString;
                
                NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",PICKUP_PREFIX,model.pickUpCode]];
                
                [attriString addAttribute:NSForegroundColorAttributeName
                                 value:APPD_RED_COLOR
                                 range:NSMakeRange((PICKUP_PREFIX).length, attriString.length - (PICKUP_PREFIX).length)];
                
                [attriString addAttribute:NSForegroundColorAttributeName
                                 value:TEXT_MEDIUM_COLOR
                                 range:NSMakeRange(0, (PICKUP_PREFIX).length)];
                
                _codeLabel.attributedText = attriString;
            }
                break;
            case KDOrderStatusOfDelivering:
            {
                [_actionButton setTitle:ALREADY_CHARGED_BUTTON_TITLE forState:UIControlStateNormal];
                _actionButton.enabled = NO;
                _statusLabel.text = ORDER_IS_DELIVERING;
                _processLabel.text = model.orderDescriptionString;
                
                NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",PICKUP_PREFIX,model.pickUpCode]];
                
                [attriString addAttribute:NSForegroundColorAttributeName
                                    value:APPD_RED_COLOR
                                    range:NSMakeRange((PICKUP_PREFIX).length, attriString.length - (PICKUP_PREFIX).length)];
                
                [attriString addAttribute:NSForegroundColorAttributeName
                                    value:TEXT_MEDIUM_COLOR
                                    range:NSMakeRange(0, (PICKUP_PREFIX).length)];
                
                _codeLabel.attributedText = attriString;
            }
                break;
            case KDOrderStatusOfSuccessButNoEvaluated:
            {
                [_actionButton setTitle:BEING_EVALUATE_BUTTON_TITLE forState:UIControlStateNormal];
                _actionButton.enabled = YES;
                _statusLabel.text = ORDER_COMPLETED;
                _processLabel.text = nil;
                _codeLabel.attributedText = nil;
            }
                break;
            case KDOrderStatusOfSuccessAndEvaluated:
            {
                [_actionButton setTitle:ALREADY_EVALUATE_BUTTON_TITLE forState:UIControlStateNormal];
                _actionButton.enabled = NO;
                _statusLabel.text = ORDER_COMPLETED;
                _processLabel.text = nil;
                _codeLabel.attributedText = nil;
            }
                break;
            default:
                break;
        }
    }
}

@end
