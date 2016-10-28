//
//  KDSetFoodLabelViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/15.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewModel.h"

@interface KDSetFoodLabelViewModel : KDBaseViewModel

//设置选中的标签
-(void)setModelSelectWithTasteType:(KDTasteType)type;

//获取选中的标签
-(KDTasteType)getSelectedTaste;

@end
