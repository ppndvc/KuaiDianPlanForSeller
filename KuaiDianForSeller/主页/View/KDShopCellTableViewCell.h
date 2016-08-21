//
//  KDShopCellTableViewCell.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/27.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseTableViewCell.h"
#import "KDActivityView.h"
#import "CWStarRateView.h"

@class KDShopModel;


#define IMAGEVIEW_WIDTH 44
#define CORNER_RADIUS 5

#define IMAGEVIEW_TOP_PADDING 18
#define IMAGEVIEW_LEFT_PADDING 13
#define LABEL_LEFT_PADDING 18

#define MAX_VERTICAL_PADDING 14
#define MIN_VERTICAL_PADDING 7

#define PRICE_TOP_PADDING 15

#define MIN_HORIZONTAL_PADDING 7

#define ACTIVITY_VERTICAL_PADDING 2
#define ACTiVITY_WIDTH 250

#define LABEL_RIGHT_PADDING 30
#define PRICE_LABEL_WIDTH 100
#define REMAINCOUNT_LABEL_WIDTH 100
#define SALES_LABEL_WIDTH 120
#define ADDRESS_LABEL_WIDTH 210

#define SALESVIEW_LEFT_PADDING 13

#define STARVIEW_HEIGHT 14
#define STARVIEW_WIDTH 65

#define MAX_ACTIVITY_COUNT 5
#define PRICE_NAME @" 起"
#define PRICE_TEXT @"价格 "
#define TIME_LIMIT @"限时 "
#define REMIAN_COUNT @"剩余:"
#define RMB_SYMBLE @"¥"

@interface KDShopCellTableViewCell : KDBaseTableViewCell

//图标
@property(nonatomic,strong)UIImageView *iconImageView;

//标题
@property(nonatomic,strong)UILabel *titleLabel;

//售价
@property(nonatomic,strong)UILabel *priceLabel;

//售价
@property(nonatomic,strong)UILabel *activityPriceLabel;

//剩余数量
@property(nonatomic,strong)UILabel *remainCountLabel;

//销量
@property(nonatomic,strong)UILabel *salesLabel;

//地址
@property(nonatomic,strong)UILabel *addressLabel;

//活动数组
@property(nonatomic,strong)NSMutableArray *activityViews;

//平分
@property(nonatomic,strong)CWStarRateView *starPanel;

//数据模型
@property(nonatomic,strong)KDShopModel *model;

//是否已经布局
@property(nonatomic,assign)BOOL hasLayout;

//配置函数
-(void)configureCellWithModel:(KDShopModel *)model;

@end
