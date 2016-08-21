//
//  KDActivityView.m
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/27.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDActivityView.h"
#import "KDActivityModel.h"

#define LABEL_VERTICAL_PADDING 0
#define IMAGE_VERTICAL_PADDING 0

#define TITLE_LABEL_CONTENT_INSET 5

#define LABEL_HORIZONTAL_PADDING 4

@interface KDActivityView ()

//活动图片
@property(nonatomic,strong)UIImageView *imageView;
//活动标题
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong)KDActivityModel *model;

@end

@implementation KDActivityView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height + TITLE_LABEL_CONTENT_INSET, 0, self.frame.size.width - self.frame.size.height - TITLE_LABEL_CONTENT_INSET, self.frame.size.height)];
    _titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SMALL_SIZE];
    _titleLabel.textColor = TEXT_MEDIUM_COLOR;
    
    [self addSubview:_titleLabel];
}

-(void)setupWithModel:(KDActivityModel *)model
{
    if (model)
    {
        _imageView.image = [UIImage imageNamed:model.imageName];
        _titleLabel.text = model.title;
    }
}

@end
