//
//  KDFoodEvalueViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/5.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDFoodEvalueViewModel : KDBaseViewModel

//获取model，并设置是否选中
-(id)collectionViewModelForIndexPath:(NSIndexPath *)indexPath setSelected:(BOOL)selected;
@end
