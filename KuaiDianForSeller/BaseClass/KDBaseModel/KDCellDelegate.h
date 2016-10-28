//
//  KDCellDelegate.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/25.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KDCellDelegate <NSObject>

@optional

//点击事件
-(void)onTapTableCell:(UITableViewCell *)cell model:(id)model;

@end
