//
//  KDSearchViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/25.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDSearchViewModel : KDBaseViewModel

//根据关键字搜索
-(void)startSearchWithKeywords:(NSString *)keywords beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock;
@end
