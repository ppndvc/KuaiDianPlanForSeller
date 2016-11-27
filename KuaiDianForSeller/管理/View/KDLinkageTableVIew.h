//
//  KDLinkageTableVIew.h
//  TextViewDemo
//
//  Created by zy on 16/7/4.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDLinkTableViewDelegate <NSObject>

@optional

//选中了哪一行
-(void)didSelectedAtIndexPath:(NSIndexPath *)indexPath params:(id)params;

//是否显示hud
-(void)showHUDWithFlag:(BOOL)shouldShow;

//获取食品类别
-(NSArray *)getFoodCategoryArray;

@end

@interface KDLinkageTableView : UIView

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

//代理
@property(nonatomic,weak)id<KDLinkTableViewDelegate> delegate;

//设置俯视图
-(void)setSuperView:(UIViewController *)superView;

//设置headerview高度
-(void)setHeaderViewHeight:(CGFloat)headerViewHeight;

//更新数据
-(void)updateLeftTableData:(NSArray *)array;
-(void)updateRightTableData:(NSArray *)array atIndex:(NSInteger)index;

//获取左侧数据
-(NSArray *)getLeftTableData;

//重新加载数据
-(void)reloadRightTableViewData;
@end
