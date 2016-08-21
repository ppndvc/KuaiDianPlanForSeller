//
//  KDDropMenu.m
//  Routable
//
//  Created by ppnd on 16/6/28.
//  Copyright © 2016年 TurboProp Inc. All rights reserved.
//

#import "KDDropMenu.h"
#import "KDDropMenuModel.h"

#define LINE_WIDTH 0.5f
#define LINE_HEIGHT_RATE (0.67f)
#define INIT_INDEX -1

#define NORMAL_TITLE_COLOR ([UIColor grayColor])
#define HIGHLIGHT_TITLE_COLOR ([UIColor redColor])

#define SEPERATOR_TAG 1001
#define TITLE_LABEL_TAG 1000

#define MENU_TITLE_FONT 14

@interface KDDropMenu()<UICollectionViewDataSource,UICollectionViewDelegate>

//menu视图
@property(nonatomic,strong) UICollectionView *menuView;

//背景
@property(nonatomic,strong) UIView *backgroundView;

//数据源
@property(nonatomic,strong) NSMutableArray *dataSource;

//当前显示的view的index
@property(nonatomic,assign)NSInteger currentShowViewIndexPath;

//keywindow
@property(nonatomic,strong)UIWindow *keyView;

//是否遮住背景
@property(nonatomic,assign)BOOL clipsBackground;

@end

@implementation KDDropMenu

//获取对象的类方法
-(instancetype)initDropMenuWithFrame:(CGRect)frame clipsBackground:(BOOL)clipsBackground
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _dataSource = [[NSMutableArray alloc] init];
        _currentShowViewIndexPath = INIT_INDEX;
        _clipsBackground = clipsBackground;
        [self setupUI];
    }
    
    return self;
}
//添加item，标题、生成customView的block
-(void)addDropMenuItemWith:(NSString *)title customView:(UIView *)customView
{
    if (title && customView)
    {
        KDDropMenuModel *model = [[KDDropMenuModel alloc] init];
        model.title = title;
        model.customView = customView;
        
        [_dataSource addObject:model];
        [_menuView reloadData];
    }
}
-(void)hideDropMenuAnimated:(BOOL)animated
{
    [self hideViewWithIndex:_currentShowViewIndexPath animated:animated completion:nil];
}
#pragma mark - UICollectionVeiw Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (_dataSource && _dataSource.count > 0)
    {
        count = _dataSource.count;
    }
    return count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_dataSource && _dataSource.count > indexPath.row)
    {
        KDDropMenuModel *model = (KDDropMenuModel *)_dataSource[indexPath.row];
        
        UILabel *label = [cell.contentView viewWithTag:TITLE_LABEL_TAG];
        UIView *seperator = [cell.contentView viewWithTag:SEPERATOR_TAG];
        
        if (!seperator)
        {
            seperator = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/_dataSource.count - LINE_WIDTH, (self.frame.size.height*(1 - LINE_HEIGHT_RATE))/2.0, LINE_WIDTH, self.frame.size.height*LINE_HEIGHT_RATE)];
            seperator.tag = SEPERATOR_TAG;
            seperator.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:seperator];
        }
        
        if (!label)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width/_dataSource.count, self.frame.size.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = TITLE_LABEL_TAG;
            [cell.contentView addSubview:label];
        }
        
        //最后一个分隔符隐藏
        if (indexPath.row == _dataSource.count - 1)
        {
            seperator.hidden = YES;
        }
        else
        {
            seperator.hidden = NO;
        }
        
        label.text = model.title;
        label.font = [UIFont systemFontOfSize:MENU_TITLE_FONT];
    
        [cell addSubview:[model accesstoryImageViewInRect:CGRectMake(0, 0, SCREEN_WIDTH/_dataSource.count, self.frame.size.height)]];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width/_dataSource.count, self.frame.size.height);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
//水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentShowViewIndexPath == INIT_INDEX)
    {
        [self showViewWithIndex:indexPath.row animated:YES];
    }
    else
    {
        if (indexPath.row != _currentShowViewIndexPath)
        {
            __weak __typeof(self) weakSelf = self;
            [self hideViewWithIndex:_currentShowViewIndexPath animated:YES completion:^(BOOL finished) {
                [weakSelf showViewWithIndex:indexPath.row animated:YES];
            }];
            
        }
        else
        {
            [self hideViewWithIndex:_currentShowViewIndexPath animated:YES completion:nil];
        }
    }
}

#pragma mark - Private Methods

-(void)setupUI
{
    _keyView = [UIApplication sharedApplication].keyWindow;
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _menuView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) collectionViewLayout:flowLayout];
    _menuView.dataSource = self;
    _menuView.delegate = self;
    _menuView.scrollEnabled = NO;
    _menuView.showsHorizontalScrollIndicator = NO;
    _menuView.showsVerticalScrollIndicator = NO;
    
    [_menuView setBackgroundColor:[UIColor clearColor]];
    
    UIView *topSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, LINE_WIDTH, [[UIScreen mainScreen] bounds].size.width, LINE_WIDTH)];
    topSeperator.backgroundColor = [UIColor lightGrayColor];
    
    UIView *bottomSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - LINE_WIDTH, [[UIScreen mainScreen] bounds].size.width, LINE_WIDTH)];
    bottomSeperator.backgroundColor = [UIColor lightGrayColor];
    
    [_menuView addSubview:topSeperator];
    [_menuView addSubview:bottomSeperator];
    
    //注册Cell
    [_menuView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self addSubview:_menuView];
}

-(void)showViewWithIndex:(NSInteger)index animated:(BOOL)animated
{
    NSParameterAssert(_dataSource && _dataSource.count > index);

    KDDropMenuModel *model = (KDDropMenuModel*)_dataSource[index];
    
    NSParameterAssert(model);
    
    _currentShowViewIndexPath = index;
    
    [model setAccessViewExpend:YES];
    
    UICollectionViewCell *cell = [_menuView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UILabel *label = [cell.contentView viewWithTag:TITLE_LABEL_TAG];
    
    [label setTextColor:HIGHLIGHT_TITLE_COLOR];
    //是否显示背景
    if (_clipsBackground)
    {
        self.backgroundView.hidden = NO;
    }
    
    [self convertOriginOfView:model.customView];
    [_keyView addSubview:model.customView];
    
    if (animated)
    {
        model.customView.hidden = NO;

        [UIView animateWithDuration:0.2
                              delay:0
             usingSpringWithDamping:0.6
              initialSpringVelocity:8
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = model.customView.frame;
                             frame.size.height = model.normalHeight;
                             model.customView.frame = frame;
                         } completion:nil];
    }
    else
    {
        CGRect frame = model.customView.frame;
        frame.size.height = model.normalHeight;
        model.customView.frame = frame;
    }
    
    
}
-(void)hideViewWithIndex:(NSInteger)index animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion
{
    if (index == INIT_INDEX)
    {
        return;
    }
    
    NSParameterAssert(_dataSource && _dataSource.count > index);
    
    KDDropMenuModel *model = (KDDropMenuModel*)_dataSource[index];
    
    NSParameterAssert(model);
    
    _currentShowViewIndexPath = INIT_INDEX;

    UICollectionViewCell *cell = [_menuView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UILabel *label = [cell.contentView viewWithTag:TITLE_LABEL_TAG];
    
    [label setTextColor:NORMAL_TITLE_COLOR];
    
    [model setAccessViewExpend:NO];
    
    if (animated)
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             CGRect frame = model.customView.frame;
                             frame.size.height = 0;
                             model.customView.frame = frame;
                         } completion:^(BOOL finished) {
                             [model.customView removeFromSuperview];
                             model.customView.hidden = YES;
                             self.backgroundView.hidden = YES;
                             if (completion)
                             {
                                 completion(finished);
                             }
                         }];
    }
    else
    {
        CGRect frame = model.customView.frame;
        frame.size.height = 0;
        model.customView.frame = frame;
        self.backgroundView.hidden = YES;
        
        if (completion)
        {
            completion(YES);
        }
    }
}
-(void)convertOriginOfView:(UIView *)view
{
    if (view)
    {
        CGPoint location = CGPointMake(self.frame.origin.x,self.frame.size.height);
        location = [_menuView convertPoint:location toView:_keyView.rootViewController.view];
        CGRect frame = view.frame;
        frame.origin = location;
        view.frame = frame;
    }
}
-(UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _backgroundView.hidden = YES;
        [_keyView addSubview:_backgroundView];
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBackground)];
        [_backgroundView addGestureRecognizer:tapToClose];
    }
    
    [self convertOriginOfView:_backgroundView];
    
    return _backgroundView;
}
-(void)onTapBackground
{
    [self hideDropMenuAnimated:YES];
}

@end
