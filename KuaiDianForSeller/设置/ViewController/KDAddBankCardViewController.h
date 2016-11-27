//
//  KDAddBankCardViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/31.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDAddBankCardViewController : KDBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *bankCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *clientProtocolLabel;

- (IBAction)onTapCheckButton:(id)sender;
- (IBAction)onTapSureButton:(id)sender;
- (IBAction)onTapGetCodeButton:(id)sender;

@end
