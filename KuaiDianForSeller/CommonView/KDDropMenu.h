//
//  KDDropMenu.h
//  Routable
//
//  Created by ppnd on 16/6/28.
//  Copyright © 2016年 TurboProp Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDDropMenu : UIView

//获取对象的类方法参数：frame/是否遮住背景
-(instancetype)initDropMenuWithFrame:(CGRect)frame clipsBackground:(BOOL)clipsBackground;

//添加item，标题、customView
-(void)addDropMenuItemWith:(NSString *)title customView:(UIView *)customView;

//隐藏menu
-(void)hideDropMenuAnimated:(BOOL)animated;

@end
