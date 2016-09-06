//
//  KDScrollView.h
//  Masonry iOS Examples
//
//  Created by ppnd on 16/7/10.
//  Copyright © 2016年 Jonas Budelmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDScrollViewDelegate <NSObject>

@optional

//page情况下，选中了第几页
-(void)didSelectedAtPageIndex:(NSInteger)index;

@end

@interface KDScrollView : UIView

@property(nonatomic,weak)id<KDScrollViewDelegate> kdScrollViewDelegate;

//初始化方法，指定segment高度
-(instancetype)initWithFrame:(CGRect)frame segmentControllHeight:(CGFloat)segmentHeight;

//添加视图
-(void)addView:(UIView *)subView title:(NSString *)title;

@end
