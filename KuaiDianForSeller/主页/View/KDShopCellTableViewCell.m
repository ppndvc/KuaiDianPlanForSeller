//
//  KDShopCellTableViewCell.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/27.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDShopCellTableViewCell.h"
#import "KDShopModel.h"
#import "YYWebImage.h"

@interface KDShopCellTableViewCell ()

@end

@implementation KDShopCellTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _hasLayout = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    //图标
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGEVIEW_LEFT_PADDING, IMAGEVIEW_TOP_PADDING, IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH)];
    [self.contentView addSubview:_iconImageView];
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.frame.origin.x + IMAGEVIEW_WIDTH + LABEL_LEFT_PADDING, MAX_VERTICAL_PADDING, (SCREEN_WIDTH - (IMAGEVIEW_LEFT_PADDING + IMAGEVIEW_WIDTH +LABEL_LEFT_PADDING + PRICE_LABEL_WIDTH + LABEL_RIGHT_PADDING)), TEXT_FONT_BIG_SIZE)];
    _titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    _titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    
    //价格
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - PRICE_LABEL_WIDTH - LABEL_RIGHT_PADDING, PRICE_TOP_PADDING, PRICE_LABEL_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
    _priceLabel.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
    
    //活动价格
    _activityPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - PRICE_LABEL_WIDTH - LABEL_RIGHT_PADDING, _priceLabel.frame.origin.y + TEXT_FONT_MEDIUM_SIZE , PRICE_LABEL_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
    _activityPriceLabel.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    _activityPriceLabel.textAlignment = NSTextAlignmentRight;
    _activityPriceLabel.hidden = YES;
    [self.contentView addSubview:_activityPriceLabel];
    
    //评分
    _starPanel = [[CWStarRateView alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + MIN_VERTICAL_PADDING, STARVIEW_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
    [self.contentView addSubview:_starPanel];
    
    //销量
    _salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_starPanel.frame.origin.x + STARVIEW_WIDTH + MIN_HORIZONTAL_PADDING, _starPanel.frame.origin.y, SALES_LABEL_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
    _salesLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE];
    _salesLabel.textColor = TEXT_MEDIUM_COLOR;
    [self.contentView addSubview:_salesLabel];
    
    //地址
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _starPanel.frame.origin.y + _starPanel.frame.size.height + MIN_VERTICAL_PADDING, ADDRESS_LABEL_WIDTH, TEXT_FONT_SMALL_SIZE)];
    _addressLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE];
    _addressLabel.textColor = TEXT_MEDIUM_COLOR;
    [self.contentView addSubview:_addressLabel];
    
    //剩余数量
    _remainCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - PRICE_LABEL_WIDTH - LABEL_RIGHT_PADDING, _addressLabel.frame.origin.y, REMAINCOUNT_LABEL_WIDTH, TEXT_FONT_SMALL_SIZE)];
    _remainCountLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE];
    _remainCountLabel.textColor = TEXT_MEDIUM_COLOR;
    _remainCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_remainCountLabel];
    _remainCountLabel.hidden = YES;
    
    
    //活动
    _activityViews = [[NSMutableArray alloc] initWithCapacity:MAX_ACTIVITY_COUNT];
    CGFloat lastYPosition = _addressLabel.frame.origin.y + _addressLabel.frame.size.height + MAX_VERTICAL_PADDING;
    
    for(int i = 0 ; i < MAX_ACTIVITY_COUNT ; i++)
    {
        CGRect frame = CGRectMake(_titleLabel.frame.origin.x, lastYPosition, ACTiVITY_WIDTH, TEXT_FONT_SMALL_SIZE);
        KDActivityView *actView = [[KDActivityView alloc] initWithFrame:frame];
        
        actView.hidden = YES;
        [self.contentView addSubview:actView];
        [_activityViews addObject:actView];
        lastYPosition = lastYPosition + ACTIVITY_VERTICAL_PADDING + TEXT_FONT_SMALL_SIZE;
    }
}
-(void)prepareForReuse
{
    //隐藏活动图
    if (_activityViews && _activityViews.count > 0)
    {
        [_activityViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *view = obj;
            view.hidden = YES;
        }];
    }
    
    //取消图片的下载
    [_iconImageView yy_cancelCurrentImageRequest];
    
    _activityPriceLabel.hidden = YES;
    _remainCountLabel.hidden = YES;
}

-(void)configureCellWithModel:(KDShopModel *)model
{
    if (model && [model isKindOfClass:[KDShopModel class]])
    {
        _model = model;
        _titleLabel.text = model.name;
        _salesLabel.text = [NSString stringWithFormat:@"%d",(int)model.salesVolume];
        _addressLabel.text = model.address;
        [_starPanel updateScore:model.score];
        
        if (_model.activityPrice != 0)
        {
            NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%.1f",PRICE_TEXT,RMB_SYMBLE,model.minPrice]];
            
            [priceStr addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE]
                             range:NSMakeRange(0, priceStr.length)];
            
            [priceStr addAttribute:NSForegroundColorAttributeName
                             value:TEXT_MEDIUM_COLOR
                             range:NSMakeRange(0, priceStr.length)];
            
            [priceStr addAttribute:NSStrikethroughStyleAttributeName
                               value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                               range:NSMakeRange(0, priceStr.length)];
            
            _priceLabel.attributedText = priceStr;
            
            NSMutableAttributedString *actPriceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%.1f",TIME_LIMIT,RMB_SYMBLE,model.activityPrice]];
            
            [actPriceStr addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE]
                             range:NSMakeRange(0, actPriceStr.length)];
            
            [actPriceStr addAttribute:NSForegroundColorAttributeName
                             value:PRICE_ORANG_COLOR
                             range:NSMakeRange(0, actPriceStr.length)];
            
            _activityPriceLabel.attributedText = actPriceStr;
            _activityPriceLabel.hidden = NO;
            
            if (model.remainCount > 0)
            {
                _remainCountLabel.text = [NSString stringWithFormat:@"%@%d",REMIAN_COUNT,(int)model.remainCount];
                _remainCountLabel.hidden = NO;
            }
        }
        else
        {
            NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%.1f%@",RMB_SYMBLE,model.minPrice,PRICE_NAME]];
            
            [priceStr addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE]
                             range:NSMakeRange(0, priceStr.length - (PRICE_NAME).length)];
            
            [priceStr addAttribute:NSForegroundColorAttributeName
                             value:PRICE_ORANG_COLOR
                             range:NSMakeRange(0, priceStr.length - (PRICE_NAME).length)];
            
            [priceStr addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE]
                             range:NSMakeRange(priceStr.length - (PRICE_NAME).length, (PRICE_NAME).length)];
            
            _priceLabel.attributedText = priceStr;
        }

        
        NSURL *imageURL = nil;
        if (VALIDATE_STRING(_model.imageURL))
        {
            imageURL = [[NSURL alloc] initWithString:_model.imageURL];
        }
        
        //加载网络图片
        if (imageURL)
        {
            [_iconImageView yy_setImageWithURL:imageURL
                                   placeholder:nil
                                       options:YYWebImageOptionSetImageWithFadeAnimation
                                      progress:nil
                                     transform:^UIImage *(UIImage *image, NSURL *url) {
                                         image = [image yy_imageByResizeToSize:CGSizeMake(IMAGEVIEW_WIDTH, IMAGEVIEW_WIDTH) contentMode:UIViewContentModeCenter];
                                         return [image yy_imageByRoundCornerRadius:CORNER_RADIUS];
                                     }
                                    completion:nil];

        }
        else
        {
            //应该加在placeholder
            _iconImageView.image = [UIImage imageNamed:model.imageName];
        }
        
        if (_model.activityArray && _model.activityArray.count > 0)
        {
            for (int i = 0; i < _model.activityArray.count; i++)
            {
                KDActivityModel *actModel = _model.activityArray[i];
                KDActivityView *actView = nil;
                if(_activityViews &&_activityViews.count > i)
                {
                    actView = _activityViews[i];
                }

                if (actModel && actView)
                {
                    [actView setupWithModel:actModel];
                    actView.hidden = NO;
                }
            }
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = (MAX_VERTICAL_PADDING + TEXT_FONT_BIG_SIZE + MIN_VERTICAL_PADDING + TEXT_FONT_MEDIUM_SIZE + MIN_VERTICAL_PADDING + TEXT_FONT_SMALL_SIZE + MAX_VERTICAL_PADDING);
    
    if (_model && _model.activityArray && _model.activityArray.count > 0)
    {
        height += (_model.activityArray.count * TEXT_FONT_SMALL_SIZE + (_model.activityArray.count - 1)*ACTIVITY_VERTICAL_PADDING + MAX_VERTICAL_PADDING);
    }
    
    return CGSizeMake(size.width, height);
}

@end
