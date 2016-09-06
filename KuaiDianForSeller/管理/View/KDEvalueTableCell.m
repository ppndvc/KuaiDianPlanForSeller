//
//  KDEvalueTableCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDEvalueTableCell.h"
#import "CWStarRateView.h"
#import "KDSellerReplyView.h"
#import "KDCustomerReplyModel.h"

#define VERTICAL_PADDING 4
#define REPLYVIEW_WIDTH_RATE 0.8
#define HORIZONTAL_PADDING 14

@implementation KDEvalueTableCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _replyView = [[KDSellerReplyView alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH*REPLYVIEW_WIDTH_RATE, 0)];
    [self.contentView addSubview:_replyView];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(HORIZONTAL_PADDING, _starViewPanel.frame.origin.y + _starViewPanel.frame.size.height, SCREEN_WIDTH - 2*HORIZONTAL_PADDING, 0)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    _contentLabel.textAlignment = NSTextAlignmentJustified;
    [self.contentView addSubview:_contentLabel];
    
    // Initialization code
}

-(void)configureCellWithModel:(KDCustomerReplyModel *)model
{
    if (model && [model isKindOfClass:[KDCustomerReplyModel class]])
    {
        [_nameButton setTitle:model.replyerName forState:UIControlStateNormal];
        _headerImageView.image = [UIImage imageNamed:@""];
        [_starViewPanel updateScore:model.score];
        _dateLabel.text = [NSString getTimeString:[model.date doubleValue] formater:YYYY_MM_DD_DATE_FORMATER];
        
        _contentLabel.text = model.content;
        CGRect contentFrame = _contentLabel.frame;
        CGSize rect = [model.content getStringDrawRectWithConstrainSize:CGSizeMake(contentFrame.size.width, MAXFLOAT) font:_contentLabel.font];
        contentFrame.size.height = rect.height;
        
        _contentLabel.frame = contentFrame;
        
        CGFloat height = VERTICAL_PADDING;
        
        if (model.sellerReply)
        {
            height += [_replyView setupViewWithModel:model.sellerReply];
            CGRect replayViewFrame = _replyView.frame;
            replayViewFrame.origin.y = _contentLabel.frame.origin.y + _contentLabel.frame.size.height + VERTICAL_PADDING;
            _replyView.frame = replayViewFrame;
        }
        
        CGRect bottomSeperatorFrame = _bottomSeperatorView.frame;
        
        bottomSeperatorFrame.origin.y = height + _contentLabel.frame.origin.y + _contentLabel.frame.size.height + VERTICAL_PADDING;
        _bottomSeperatorView.frame = bottomSeperatorFrame;
        
        CGRect buttonFrame = _replyButton.frame;
        
        buttonFrame.origin.y = bottomSeperatorFrame.origin.y + bottomSeperatorFrame.size.height + VERTICAL_PADDING;
        _replyButton.frame = buttonFrame;
        
    }
}
- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = _replyButton.frame.origin.y + _replyButton.frame.size.height + VERTICAL_PADDING;
    
    return CGSizeMake(size.width, height);
}
@end
