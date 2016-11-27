//
//  KDDateView.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDPickerView : UIView

//初始化方法
-(instancetype)initWithType:(KDDatePickerType)type;
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame type:(KDDatePickerType)type;

//设置pickerview的数据源
-(void)setDateViewDataSource:(NSArray *)pickerViewDataSource selectedIndex:(NSInteger)index;

//获取数据
-(NSArray *)getPickerData;

@end
