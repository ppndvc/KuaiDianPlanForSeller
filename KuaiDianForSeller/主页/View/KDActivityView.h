//
//  KDActivityView.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/7/27.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KDActivityModel;

@interface KDActivityView : UIView

//用model更新ui
-(void)setupWithModel:(KDActivityModel *)model;

@end
