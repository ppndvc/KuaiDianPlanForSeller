//
//  KDLoginViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/10.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDLoginViewController : KDBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)onTapLoginButton:(id)sender;

//设置结束回调
-(void)setDisapperBlock:(KDRouterVCDisappearBlock)disappearBlock;

@end
