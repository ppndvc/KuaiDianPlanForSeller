//
//  KDPayBrandView.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

//支付类型
typedef NS_ENUM(NSInteger, KDPaymentType)
{
    //银行卡支付
    KDPaymentTypeOfBankPay = 1,
    //支付宝支付
    KDPaymentTypeOfAliPay = 2,
    //微信支付
    KDPaymentTypeOfWeiChatPay = 3,
};

@interface KDPayBrandView : UIView

-(instancetype)init UNAVAILABLE_ATTRIBUTE;
-(instancetype)new UNAVAILABLE_ATTRIBUTE;


//设置支付类型面板的数据
-(void)setPayBrandViewType:(KDPaymentType)type number:(NSString *)number;
@end
