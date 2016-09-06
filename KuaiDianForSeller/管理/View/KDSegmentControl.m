//
//  KDSegmentControl.m
//  Masonry iOS Examples
//
//  Created by zy on 16/7/9.
//  Copyright © 2016年 Jonas Budelmann. All rights reserved.
//

#import "KDSegmentControl.h"

#define BOTTPM_BAR_HEIGHT 2.5

#define SEPERATOR_VIEW_WIDTH 1

#define ANIMATION_DURATION 0.3f

#define LABEL_TAG 1000

@interface KDSegmentControl()<UICollectionViewDataSource,UICollectionViewDelegate>

//collectionview
@property(nonatomic,strong) UICollectionView *collectionView;

//底部滑动栏
@property(nonatomic,strong) UIView *bottomBar;

//数据源
@property(nonatomic,strong) NSMutableArray *dataSource;

//cell宽度
@property(nonatomic,assign) CGFloat itemWidth;

//当前选中的index
@property(nonatomic,strong) NSIndexPath *currentSelectIndex;

@end

@implementation KDSegmentControl

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (self)
    {
        _dataSource = [[NSMutableArray alloc] init];
        [self setupUI];
    }
    return self;
}

//数组初始化方法
-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (self)
    {
        _dataSource = [[NSMutableArray alloc] initWithArray:items];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    //collectionView初始化
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,self.frame.size.height - BOTTPM_BAR_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.scrollEnabled = NO;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"segmentCell"];
    
    //底部滑动栏
    _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - BOTTPM_BAR_HEIGHT, _itemWidth, BOTTPM_BAR_HEIGHT)];
    _bottomBar.backgroundColor = APPD_RED_COLOR;
    [self addSubview:_bottomBar];
    
    [self updateItemWidth];
    

}

-(void)updateItemWidth
{
    if (_dataSource.count > 0)
    {
        _itemWidth = SCREEN_WIDTH/(1.0 * _dataSource.count);
    }
    else
    {
        _itemWidth = SCREEN_WIDTH;
    }
    
    if (_bottomBar)
    {
        _bottomBar.frame = CGRectMake(0, self.frame.size.height - BOTTPM_BAR_HEIGHT, _itemWidth, BOTTPM_BAR_HEIGHT);
    }
}

-(void)reloadView
{
    [self updateItemWidth];
    [self.collectionView reloadData];
}
-(void)moveBottomBarTo:(CGFloat)xPosition animated:(BOOL)animated
{
    if (xPosition < 0 || xPosition > SCREEN_WIDTH - _itemWidth)
    {
        return;
    }

    CGRect frame = _bottomBar.frame;

    if (frame.origin.x == xPosition)
    {
        return;
    }
    
    frame.origin.x = xPosition;
    
    if (animated)
    {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            _bottomBar.frame = frame;
        }];
    }
    else
    {
        _bottomBar.frame = frame;
    }
}
//添加item
-(void)addItemWithTitle:(NSString *)title
{
    if (_dataSource && title && title.length > 0)
    {
        [_dataSource addObject:title];
        [self reloadView];
    }
}

//更新底部栏的位置
-(void)updateBottomBarWithOffset:(CGFloat)offset
{
    [self moveBottomBarTo:offset animated:NO];
}
//设置选中位置
-(void)setSeletAtIndex:(NSInteger)index
{
    [self singleSelectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}
-(NSInteger)selectedIndex
{
    NSInteger selectedIndex = 0;
    if (_currentSelectIndex)
    {
        selectedIndex = _currentSelectIndex.row;
    }
    return selectedIndex;
}
#pragma mark - collectionView delegate
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger cellCount = 0;
    
    if (_dataSource && _dataSource.count > 0)
    {
        cellCount = _dataSource.count;
    }
    
    return cellCount;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"segmentCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _itemWidth, self.frame.size.height - BOTTPM_BAR_HEIGHT)];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = LABEL_TAG;
    label.font = [UIFont systemFontOfSize:TEXT_FONT_BIG_SIZE];
    [cell.contentView addSubview:label];
    
    
    if (cell && _dataSource && _dataSource.count > indexPath.row)
    {
        //默认选中第一个item
        if(indexPath.row == 0)
        {
            label.textColor = APPD_RED_COLOR;
            _currentSelectIndex = indexPath;
        }
        else
        {
            UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, label.frame.size.height/4.0, SEPERATOR_VIEW_WIDTH, label.frame.size.height/2.0)];
            seperatorView.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:seperatorView];
        }
        
        NSString *title = _dataSource[indexPath.row];
        label.text = title;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self singleSelectAtIndexPath:indexPath];
    
    [self moveBottomBarTo:_itemWidth*indexPath.row animated:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSeletedAtIndex:)])
    {
        [_delegate didSeletedAtIndex:indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSource && _dataSource.count > 0)
    {
        return CGSizeMake(_itemWidth, self.frame.size.height - BOTTPM_BAR_HEIGHT);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)singleSelectAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentSelectIndex)
    {
        [self setCellSelect:NO atIndexPath:_currentSelectIndex];
    }
    
    _currentSelectIndex = indexPath;
    [self setCellSelect:YES atIndexPath:_currentSelectIndex];
}

-(void)setCellSelect:(BOOL)select atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && _collectionView)
    {
        UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
        if (cell)
        {
            UILabel *label = [cell.contentView viewWithTag:LABEL_TAG];
            
            if (label)
            {
                if (select)
                {
                    label.textColor = APPD_RED_COLOR;
                }
                else
                {
                    label.textColor = TEXT_HIGH_COLOR;
                }
            }
        }
    }
}
@end
