//
//  KDSetFoodLabelViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/15.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSetFoodLabelViewController.h"
#import "KDFoodLabelModel.h"
#import "KDCheckViewCell.h"
#import "KDSetFoodLabelViewModel.h"
#import "KDCheckView.h"

#define ITEM_COUNT_PER_ROW 3
#define BUTTON_WIDTH 80

#define ITEM_WIDTH 80
#define ITEM_HEIGHT 30

@interface KDSetFoodLabelViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

//viewmodel
@property(nonatomic,strong)KDSetFoodLabelViewModel *viewModel;

@property(nonatomic,assign)KDTasteType type;

@property(nonatomic,strong)KDCheckView *checkView;

@end

@implementation KDSetFoodLabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = SET_FOOD_LABEL_TITLE;
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    
    [self setupUI];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setupUI
{
    UIButton *rightBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH, TEXT_FONT_BIG_SIZE)];
    rightBTN.titleLabel.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    [rightBTN setTitle:BUTTON_TITLE_SURE forState:UIControlStateNormal];
    [rightBTN addTarget:self action:@selector(onTapRightBTN) forControlEvents:UIControlEventTouchUpInside];
    rightBTN.backgroundColor = [UIColor clearColor];
    rightBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBTN];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _viewModel = [[KDSetFoodLabelViewModel alloc] init];
    
    if (VALIDATE_DICTIONARY(self.parameters))
    {
        _type = [[self.parameters objectForKey:SET_FOOD_LABEL_TASTE_KEY] integerValue];
        [_viewModel setModelSelectWithTasteType:_type];
    }
//    KDCheckViewCell.h
//    [_collectionView registerNib:[UINib nibWithNibName:@"KDCheckViewCell" bundle:nil]  forCellWithReuseIdentifier:kCheckViewCell];
//    
//    _collectionView.dataSource = self;
//    _collectionView.delegate = self;
//    _collectionView.backgroundColor = [UIColor clearColor];
//    
//    [_collectionView setCollectionViewLayout:flowLayout];
    
    CGRect checkViewFrame = _titleLabel.frame;
    checkViewFrame.origin = CGPointMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + VIEW_VERTICAL_PADDING);
    checkViewFrame.size = CGSizeMake(SCREEN_HEIGHT - 2*VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, 200);
    
    _checkView = [[KDCheckView alloc] initWithFrame:checkViewFrame dataSource:[_viewModel getAllTableData] supportMultiSelect:YES];
    [self.view addSubview:_checkView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect checkViewFrame = _titleLabel.frame;
    checkViewFrame.origin = CGPointMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + VIEW_VERTICAL_PADDING);
    checkViewFrame.size = CGSizeMake(SCREEN_HEIGHT - 2*VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, 200);
    
    _checkView.frame = checkViewFrame;
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
    KDCheckViewCell *cell = (KDCheckViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCheckViewCell forIndexPath:indexPath];
    
    [cell sizeToFit];
    
    if (_viewModel)
    {
        [_viewModel configureCollectionViewCell:cell indexPath:indexPath];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KDFoodLabelModel *model = [_viewModel collectionViewModelForIndexPath:indexPath];
    if (VALIDATE_MODEL(model, @"KDFoodLabelModel"))
    {
        model.isSelected = !model.isSelected;
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
//    switch (indexPath.row)
//    {
//        case 0:
//        {
//            [[KDRouterManger sharedManager] pushVCWithKey:@"KDFoodManageVC" parentVC:self];
//        }
//            break;
//        case 1:
//        {
//            [[KDRouterManger sharedManager] pushVCWithKey:@"KDFoodEvalueVC" parentVC:self];
//        }
//            break;
//        case 2:
//        {
//            [[KDRouterManger sharedManager] pushVCWithKey:@"KDSaleActivityVC" parentVC:self];
//        }
//            break;
//        case 3:
//        {
//            [[KDRouterManger sharedManager] pushVCWithKey:@"KDShopInfoVC" parentVC:self];
//        }
//            break;
//        default:
//            break;
//    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

-(void)onTapRightBTN
{
    if (self.vcDisappearBlock)
    {
        self.vcDisappearBlock(@"KDSetFoodLabelViewController",[NSNumber numberWithInteger:[_viewModel getSelectedTaste]]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    DDLogInfo(@"-KDSetFoodLabelViewController dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
