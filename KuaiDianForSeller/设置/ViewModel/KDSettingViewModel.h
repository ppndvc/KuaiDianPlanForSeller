//
//  KDSettingViewModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"
@class KDActionModel;
@class KDUserModel;

@interface KDSettingViewModel : KDBaseModel

//section数目
-(NSInteger)tableViewSections;

//section对应的行数
-(NSInteger)tableViewRowsForSection:(NSInteger)section;

//配置对应行的cell
-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

//获取对应航的action
-(KDActionModel *)tableViewActionModelForIndexPath:(NSIndexPath *)indexPath;

//获取用户信息
-(KDUserModel *)getUserInfoModel;

@end
