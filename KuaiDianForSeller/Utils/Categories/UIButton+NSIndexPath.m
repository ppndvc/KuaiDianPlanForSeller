//
//  UIButton+NSIndexPath.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/17.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "UIButton+NSIndexPath.h"

static const void *kIndexPathKey = &kIndexPathKey;

@implementation UIButton (NSIndexPath)
- (NSIndexPath *)indexPath
{
    return objc_getAssociatedObject(self, kIndexPathKey);
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, kIndexPathKey, indexPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
