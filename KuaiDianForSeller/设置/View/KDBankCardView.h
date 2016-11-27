//
//  KDBankCardView.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/1.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDBankModel;

@interface KDBankCardView : UIView

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

//类方法
+(instancetype)normalBankCardViewWithBank:(KDBankModel *)bank;

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame bank:(KDBankModel *)bank;

//更新视图
-(void)updateViewWithModel:(KDBankModel *)model;

@end
