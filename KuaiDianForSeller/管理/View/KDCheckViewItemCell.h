//
//  KDCheckViewItemCellTableViewCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/20.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseTableViewCell.h"

@interface KDCheckViewItemCell : KDBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//默认初始化方法（不用）
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier NS_UNAVAILABLE;

//自定义初始化方法
-(instancetype)initWithCheckStyle:(KDCheckViewItemStyle)checkStyle reuseIdentifier:(NSString *)reuseIdentifier;

//设置选中
-(void)setSelect:(BOOL)isSelected;
@end
