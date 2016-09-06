//
//  KDEditFoodViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDEditFoodViewController : KDBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *foodNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *foodDescTextField;
@property (weak, nonatomic) IBOutlet UITextField *foodCateTextField;
@property (weak, nonatomic) IBOutlet UITextField *foodPriceTextField;
@property (weak, nonatomic) IBOutlet UIView *foodLabelTextField;

- (IBAction)onTapFoodName:(id)sender;
- (IBAction)onTapFoodDesc:(id)sender;
- (IBAction)onTapFoodCate:(id)sender;
- (IBAction)onTapFoodPrice:(id)sender;

- (IBAction)onTapDelete:(id)sender;
- (IBAction)onTapSure:(id)sender;

@end
