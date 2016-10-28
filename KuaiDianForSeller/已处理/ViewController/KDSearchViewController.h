//
//  KDSearchViewController.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/25.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseViewController.h"

@interface KDSearchViewController : KDBaseViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searhBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end
