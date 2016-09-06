//
//  KDManageViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/29.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDManageViewController : KDBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *turnoverLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleMountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)onTapCheckDetail:(id)sender;

@end
