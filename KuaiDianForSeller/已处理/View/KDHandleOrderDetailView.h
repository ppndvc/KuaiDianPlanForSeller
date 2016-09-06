//
//  KDhandleOrderDetailView.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KDOrderModel;

@protocol KDHandleOrderDetailViewDelegate <NSObject>

@optional

//点击确定按钮
-(void)onTapActionButtonWithModel:(id)model;

@end


@interface KDHandleOrderDetailView : UIView

//获取对象的类方法
+(instancetype)detailView;


@property(nonatomic,weak)id<KDHandleOrderDetailViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
//次序
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//下单时间
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
//取货时间
@property (weak, nonatomic) IBOutlet UILabel *pickUpTimeLabel;
//取货码
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
//用户名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//用户号码
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
//备注
@property (weak, nonatomic) IBOutlet UILabel *memoLabel;
//菜品详情
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//按钮
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)onTapActionButton:(id)sender;
-(void)showDetailViewWithModel:(KDOrderModel *)model;
@end
