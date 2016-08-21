//
//  KDDropMenuModel.h
//  Routable
//
//  Created by ppnd on 16/7/2.
//  Copyright © 2016年 TurboProp Inc. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDDropMenuModel : KDBaseModel

//标题
@property(nonatomic,copy)NSString *title;

//customView
@property(nonatomic,strong)UIView *customView;

//customView正常高度
@property(nonatomic,assign)CGFloat normalHeight;

//箭头图标
@property(nonatomic,strong)UIImageView *accesstoryImageView;

//设置箭头旋转
-(void)setAccessViewExpend:(BOOL)isExpend;
//在rect里面添加accessView
-(UIImageView *)accesstoryImageViewInRect:(CGRect)rect;
@end
