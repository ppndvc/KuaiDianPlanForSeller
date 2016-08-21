//
//  KDBaseVCModel.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface KDBaseModel : NSObject<NSCoding,NSCopying>

-(void)updateModel:(id)model;

@end
