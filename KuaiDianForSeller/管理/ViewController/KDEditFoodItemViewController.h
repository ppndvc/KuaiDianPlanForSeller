//
//  KDEditFoodViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@class KDTasteLabelView;

@interface KDEditFoodItemViewController : KDBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *foodNameButton;
@property (weak, nonatomic) IBOutlet UIButton *foodDescButton;
@property (weak, nonatomic) IBOutlet UITextField *foodPriceTextField;
@property (weak, nonatomic) IBOutlet UIView *foodLabelTextField;
@property (weak, nonatomic) IBOutlet KDTasteLabelView *labelView;
@property (weak, nonatomic) IBOutlet UIButton *foodCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteFoodButton;

- (IBAction)onTapFoodName:(id)sender;
- (IBAction)onTapFoodDesc:(id)sender;
- (IBAction)onTapFoodCate:(id)sender;

- (IBAction)onTapDelete:(id)sender;
- (IBAction)onTapSure:(id)sender;

@end
