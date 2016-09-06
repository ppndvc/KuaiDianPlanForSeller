//
//  KDSegmentControl.h
//  Masonry iOS Examples
//
//  Created by zy on 16/7/9.
//  Copyright © 2016年 Jonas Budelmann. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KDSegmentControlDelegate <NSObject>

//选中代理函数
-(void)didSeletedAtIndex:(NSInteger)index;

@end


@interface KDSegmentControl : UIView

//代理
@property(nonatomic,weak) id<KDSegmentControlDelegate> delegate;

//数组初始化方法
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

//添加item
-(void)addItemWithTitle:(NSString *)title;

//设置选中位置
-(void)setSeletAtIndex:(NSInteger)index;

//更新底部栏的位置
-(void)updateBottomBarWithOffset:(CGFloat)offset;

//返回选中的index
-(NSInteger)selectedIndex;

@end
