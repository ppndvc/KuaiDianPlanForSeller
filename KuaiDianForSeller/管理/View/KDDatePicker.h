//
//  KDDatePicker.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/26.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

//datepicker的回调
typedef void (^KDDatePickerCompleteBlock)(id date1 , id date2);

@interface KDDatePicker : UIView

//类方法
+(void)showDatePickerWithType:(KDDatePickerType)type completeBlock:(KDDatePickerCompleteBlock)completeBlock superView:(UIView *)superView;

//初始化方法
-(instancetype)initWithType:(KDDatePickerType)type completeBlock:(KDDatePickerCompleteBlock)completeBlock superView:(UIView *)superView;

//设置pickerview的数据源
-(void)setPickerViewDataSource:(NSArray *)pickerViewDataSource selectedIndex:(NSInteger)index;

//显示
-(void)showDatePickerWithAnimated:(BOOL)animated;

@end
