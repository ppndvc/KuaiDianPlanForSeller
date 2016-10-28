//
//  KDAvatarViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDAvatarViewController : KDBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)onTapActionButton:(id)sender;

@end
