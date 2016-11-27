//
//  KDPayBrandView.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KDPayBrandViewDelegate <NSObject>

@optional
//点击代理函数
-(void)onTapPayBrandViewWithPaymentType:(KDPaymentType)type;

@end

@interface KDPayBrandView : UIView

//代理函数
@property(nonatomic,weak)id<KDPayBrandViewDelegate> delegate;

-(instancetype)init UNAVAILABLE_ATTRIBUTE;
-(instancetype)new UNAVAILABLE_ATTRIBUTE;


//设置支付类型面板的数据
-(void)setPayBrandViewType:(KDPaymentType)type number:(NSString *)number;

@end
