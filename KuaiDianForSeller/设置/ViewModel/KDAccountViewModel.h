//
//  KDAccountViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/20.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDAccountViewModel : KDBaseViewModel

//请求个人信息
-(void)startRequestUserInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

@end
