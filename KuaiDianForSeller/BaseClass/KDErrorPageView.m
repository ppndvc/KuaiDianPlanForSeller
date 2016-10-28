//
//  KDErrorPageView.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/25.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDErrorPageView.h"


@implementation KDErrorPageView

+(instancetype)errorPageWithFrame:(CGRect)frame tapBlock:(KDNetworkErrorPageTapBlock)tapBlock
{
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"KDErrorPageView" owner:nil options:nil];
    KDErrorPageView *view = [objs lastObject];
    view.frame = frame;
    view.tapBlock = tapBlock;
    return view;
}
- (IBAction)onTapReloadButton:(id)sender
{
    if (_tapBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _tapBlock();
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hide];
    });
}
-(void)hide
{
    _tapBlock = nil;
    self.hidden = YES;
    [self removeFromSuperview];
}
-(void)dealloc
{
    DDLogInfo(@"- KDErrorPageView dealloc");
}
@end
