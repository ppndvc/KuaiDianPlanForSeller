//
//  KDChangePhoneNumberViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/22.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDChangePhoneNumberViewController : KDBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

- (IBAction)onTapActionButton:(id)sender;
@end
