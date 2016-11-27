//
//  KDEvalueTableCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseTableViewCell.h"
@class CWStarRateView;
@class KDSellerReplyView;

@protocol KDEvalueTableCellDelegate <NSObject>

@optional
//点击回复按钮
-(void)onTapReplyButtonWithModel:(id)model;

@end

@interface KDEvalueTableCell : KDBaseTableViewCell

@property(nonatomic, weak)id<KDEvalueTableCellDelegate> evalueDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet CWStarRateView *starViewPanel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) KDSellerReplyView *replyView;
@property (weak, nonatomic) IBOutlet UIView *bottomSeperatorView;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
- (IBAction)onTapReplyButton:(id)sender;

@end
