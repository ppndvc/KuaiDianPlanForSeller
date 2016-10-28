//
//  KDManageViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/29.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDManageViewController.h"
#import "KDManageCollectionCell.h"
#import "KDManageViewModel.h"

#define COLLECTION_CELL_WIDTH 80
#define COLLECTION_CELL_HEIGHT 80

#define COLLECTION_CELL_INSET 20
#define COLLECTION_CELL_TOP_INSET 11
#define COLLECTION_CELL_BOTTOM_INSET 14

static NSString *kManageCollectionCellIdentifier = @"kManageCollectionCell";

@interface KDManageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)KDManageViewModel *viewModel;

@end

@implementation KDManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [[KDManageViewModel alloc] init];
    self.navigationItem.title = MANAGE_TITLE;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"KDManageCollectionCell" bundle:nil]  forCellWithReuseIdentifier:kManageCollectionCellIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];

    [_collectionView setCollectionViewLayout:flowLayout];
    
}

#pragma mark - collection view delegate methods

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    rows = [_viewModel collectionViewRowsForSection:section];
    return rows;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDManageCollectionCell *cell = (KDManageCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kManageCollectionCellIdentifier forIndexPath:indexPath];
    
    [cell sizeToFit];
    
    if (_viewModel)
    {
        [_viewModel configureCollectionViewCell:cell indexPath:indexPath];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDFoodManageVC" parentVC:self];
        }
            break;
        case 1:
        {
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDFoodEvalueVC" parentVC:self];
        }
            break;
        case 2:
        {
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDSaleActivityVC" parentVC:self];
        }
            break;
        case 3:
        {
            [[KDRouterManger sharedManager] pushVCWithKey:@"KDShopInfoVC" parentVC:self];
        }
            break;
        default:
            break;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [_viewModel dataSourceCount];
    count = MAX(count, 1);
    
    return CGSizeMake(SCREEN_WIDTH/count, SCREEN_WIDTH/count);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    DDLogInfo(@"-KDManageViewController dealloc");
}
- (IBAction)onTapCheckDetail:(id)sender
{
}
@end
