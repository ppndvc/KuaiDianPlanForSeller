//
//  KDCommodityTableViewCell.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/8/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDCommodityTableViewCell.h"
#import "KDCommodityModel.h"
#import "YYWebImage.h"

@implementation KDCommodityTableViewCell

-(void)prepareForReuse
{
    [super prepareForReuse];
}

-(void)configureCellWithModel:(KDCommodityModel *)model
{
    if (model && [model isKindOfClass:[KDCommodityModel class]])
    {
       self.titleLabel.text = model.name;
       self.salesLabel.text = [NSString stringWithFormat:@"%d",(int)model.salesVolume];
       self.addressLabel.text = model.address;
        [self.starPanel updateScore:model.score];
        
        if (model.activityPrice != 0)
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
            
           self.priceLabel.attributedText = priceStr;
            
            NSMutableAttributedString *actPriceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%.1f",TIME_LIMIT,RMB_SYMBLE,model.activityPrice]];
            
            [actPriceStr addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE]
                                range:NSMakeRange(0, actPriceStr.length)];
            
            [actPriceStr addAttribute:NSForegroundColorAttributeName
                                value:PRICE_ORANG_COLOR
                                range:NSMakeRange(0, actPriceStr.length)];
            
           self.activityPriceLabel.attributedText = actPriceStr;
           self.activityPriceLabel.hidden = NO;
            
            if (model.remainCount > 0)
            {
               self.remainCountLabel.text = [NSString stringWithFormat:@"%@%d",REMIAN_COUNT,(int)model.remainCount];
               self.remainCountLabel.hidden = NO;
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
            
           self.priceLabel.attributedText = priceStr;
        }
        
        
        NSURL *imageURL = nil;
        if (VALIDATE_STRING(model.imageURL))
        {
            imageURL = [[NSURL alloc] initWithString:model.imageURL];
        }
        
        //加载网络图片
        if (imageURL)
        {
            [self.iconImageView yy_setImageWithURL:imageURL
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
           self.iconImageView.image = [UIImage imageNamed:model.imageName];
        }
        
        if (model.activityArray && model.activityArray.count > 0)
        {
            for (int i = 0; i < model.activityArray.count; i++)
            {
                KDActivityModel *actModel = model.activityArray[i];
                KDActivityView *actView = nil;
                if(self.activityViews && self.activityViews.count > i)
                {
                    actView = self.activityViews[i];
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

@end
