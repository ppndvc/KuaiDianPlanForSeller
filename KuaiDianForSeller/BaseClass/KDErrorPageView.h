//
//  KDErrorPageView.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/25.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KDErrorPageView : UIView

//回调函数
@property(nonatomic,copy)KDNetworkErrorPageTapBlock tapBlock;

//类方法
+(instancetype)errorPageWithFrame:(CGRect)frame tapBlock:(KDNetworkErrorPageTapBlock)tapBlock;

//点击事件
- (IBAction)onTapReloadButton:(id)sender;

//隐藏
-(void)hide;

@end
