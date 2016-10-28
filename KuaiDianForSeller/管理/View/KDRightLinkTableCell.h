//
//  KDRightLinkTableCell.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/16.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseTableViewCell.h"
@class KDTasteLabelView;

@protocol KDLinkageTableRightSideDelegate <NSObject>

@optional

//点击编辑按钮
-(void)onTapEditWithCell:(UITableViewCell *)cell model:(id)model;
//点击删除按钮
-(void)onTapDeleteWithCell:(UITableViewCell *)cell model:(id)model;
//点击更改状态按钮
-(void)onTapChangeStatusWithCell:(UITableViewCell *)cell model:(id)model;

@end

@interface KDRightLinkTableCell : KDBaseTableViewCell

@property(nonatomic,weak)id<KDLinkageTableRightSideDelegate> linkTableDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet KDTasteLabelView *tasteLabelView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *saleActionButton;

- (IBAction)onTapEditButton:(id)sender;
- (IBAction)onTapDeleteButton:(id)sender;
- (IBAction)onTapChangeStatusButton:(id)sender;

@end
