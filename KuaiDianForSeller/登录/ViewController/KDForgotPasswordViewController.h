//
//  KDForgotPasswordViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/16.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDForgotPasswordViewController : KDBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
- (IBAction)onTapActionBTN:(id)sender;


@end
