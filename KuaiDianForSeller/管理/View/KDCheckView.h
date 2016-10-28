//
//  KDCheckView.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/23.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDCheckView : UICollectionView

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource supportMultiSelect:(BOOL)supportMultiSelect;

//获取选中列表
-(NSArray *)getSelectedItems;

@end
