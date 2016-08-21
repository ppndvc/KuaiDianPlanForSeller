//
//  KDLoginVIewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/13.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDLoginViewModel : KDBaseModel

//开始登陆请求，带有开始和结束回调
-(void)startLoginWithParams:(NSDictionary *)params beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;

@end
