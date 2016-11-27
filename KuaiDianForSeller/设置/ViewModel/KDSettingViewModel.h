//
//  KDSettingViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDSettingViewModel : KDBaseViewModel


//设置图片下载技术回调
-(void)setFinishDownloadLogoHandler:(ImageDownloadCompletedHandler)handler;

//请求个人信息
-(void)startRequestBankInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

//请求商铺信息
-(void)startRequestShopInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

@end

