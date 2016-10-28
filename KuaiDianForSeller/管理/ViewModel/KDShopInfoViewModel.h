//
//  KDShopInfoViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

#define SHOP_NAME @"餐厅名称"
#define SHOP_BELONG_SCHOOL @"所在大学"
#define SHOP_BELONG_RESTRAUNT @"所属食堂"
#define SHOP_ADDRESS @"餐厅地址"
#define SHOP_IMAGE @"餐厅照片"
#define SHOP_OPEN_TIME @"营业时间"
#define SHOP_NOTICE @"餐厅公告"
#define SHOP_TELEPHONE @"订餐电话"
#define SHOP_OPEN_STATUS @"营业状态"
#define SHOP_PAY_STYLE @"支付方式"

#define SHOP_OPENING_STATUS_STRING @"正常营业中"
#define SHOP_CLOSED_STATUS_STRING @"打烊"
#define SHOP_PRE_OPENING_STATUS_STRING @"试营业"
#define SHOP_NO_ACCEPT_NEW_ORDER_STATUS_STRING @"太忙不接收新订单"


#define SHOP_OFFLINE_PAY @"线下支付(刷卡)"
#define SHOP_ONLINE_PAY @"线上支付"

@interface KDShopInfoViewModel : KDBaseViewModel

//获取餐厅信息model
-(id)getShopInfoModel;

//开始请求餐厅信息
-(void)startRequestShopInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//更新
-(void)updateTableViewAtIndex:(NSInteger)index content:(NSString *)content;
@end
