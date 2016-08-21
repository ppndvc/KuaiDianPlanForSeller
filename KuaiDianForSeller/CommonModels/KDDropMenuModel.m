//
//  KDDropMenuModel.m
//  Routable
//
//  Created by ppnd on 16/7/2.
//  Copyright © 2016年 TurboProp Inc. All rights reserved.
//

#import "KDDropMenuModel.h"

#define ACCESSVIEW_WIDTH 10
#define ACCESSVIEW_HEIGHT 6
#define ACCESSVIEW_PADDING 10

#define IMAGE_NAME_NORMAL @"up_trangle"
#define IMAGE_NAME_EXPEND @"up_trangle_red"

@implementation KDDropMenuModel

-(void)setCustomView:(UIView *)customView
{
    NSParameterAssert(customView);
    
    CGRect frame = customView.frame;
    
    customView.layer.masksToBounds = YES;
    _normalHeight = frame.size.height;
    frame.size.height = 0;
    customView.frame = frame;
    _customView = customView;
    _customView.hidden = YES;
}
-(UIImageView *)accesstoryImageViewInRect:(CGRect)rect
{
    if (!_accesstoryImageView)
    {
        _accesstoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ACCESSVIEW_WIDTH, ACCESSVIEW_HEIGHT)];
        _accesstoryImageView.image = [UIImage imageNamed:IMAGE_NAME_NORMAL];
    }
    
    
    CGRect accessViewFrame = _accesstoryImageView.frame;
    CGPoint accessViewLocation = CGPointMake(rect.size.width - (2*ACCESSVIEW_PADDING + ACCESSVIEW_WIDTH), (rect.size.height - ACCESSVIEW_HEIGHT)/2);
    accessViewFrame.origin = accessViewLocation;
    
    _accesstoryImageView.frame = accessViewFrame;
    
    return _accesstoryImageView;
}

-(void)setAccessViewExpend:(BOOL)isExpend
{
    NSParameterAssert(_accesstoryImageView);
    //旋转箭头
    if (isExpend)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            _accesstoryImageView.image = [UIImage imageNamed:IMAGE_NAME_EXPEND];
            _accesstoryImageView.transform = CGAffineTransformMakeRotation(M_PI);
            
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            _accesstoryImageView.image = [UIImage imageNamed:IMAGE_NAME_NORMAL];
            _accesstoryImageView.transform = CGAffineTransformMakeRotation(0);
            
        } completion:nil];
    }
}

@end
