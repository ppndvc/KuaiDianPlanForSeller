//
//  UIButton+BackgroundColor.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/25.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "UIButton+BackgroundColor.h"


@implementation UIButton (BackgroundColor)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[KDTools imageWithColor:backgroundColor] forState:state];
}

@end
