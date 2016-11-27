//
//  KDTools.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/17.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDTools : NSObject

//根据颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//压缩图片尺寸
+ (UIImage *)compressWithSourceImage:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//获取类属性
+(NSArray *)getPropertiesOfClass:(Class)cls;

@end
