//
//  KDSellerReplyView.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDBaseReplyModel;

@interface KDSellerReplyView : UIView

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *contentLabel;

//根据模型初始化label，并返回总高度
-(CGFloat)setupViewWithModel:(KDBaseReplyModel *)model;
@end
