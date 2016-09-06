//
//  KDScrollView.m
//  Masonry iOS Examples
//
//  Created by ppnd on 16/7/10.
//  Copyright © 2016年 Jonas Budelmann. All rights reserved.
//

#import "KDScrollView.h"
#import "KDSegmentControl.h"

@interface KDScrollView()<KDSegmentControlDelegate,UIScrollViewDelegate>

//scrollview
@property(nonatomic,strong)UIScrollView *scrollView;

//segment
@property(nonatomic,strong)KDSegmentControl *segmentControl;

//保存视图的数组
@property(nonatomic,strong)NSMutableArray *views;

//segment高度
@property(nonatomic,assign)CGFloat segmentHeight;

@end

@implementation KDScrollView

-(instancetype)initWithFrame:(CGRect)frame segmentControllHeight:(CGFloat)segmentHeight
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _views = [[NSMutableArray alloc] init];
        _segmentHeight = segmentHeight;
        [self setupUI];
    }
    
    return self;
}

-(void)setupUI
{
    _segmentControl = [[KDSegmentControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _segmentHeight)];
    _segmentControl.delegate = self;
    [self addSubview:_segmentControl];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentHeight, self.frame.size.width, self.frame.size.height - _segmentHeight)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;

    _scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height - _segmentHeight);
    [self addSubview:_scrollView];
}
-(void)addView:(UIView *)subView title:(NSString *)title
{
    if (subView && _views)
    {
        if (!title)
        {
            title = @"";
        }
        
        [_segmentControl addItemWithTitle:title];
        [_views addObject:subView];
        
        NSInteger index = _views.count;
        
        if (index > 0)
        {
            CGRect frame = subView.frame;
            frame.origin.x = (index - 1) * self.frame.size.width;
            frame.origin.y = 0;
            subView.frame = frame;
            
            [_scrollView addSubview:subView];
            
            CGSize contentSize = _scrollView.contentSize;
            contentSize.width = index * self.frame.size.width;
            
            _scrollView.contentSize = contentSize;
        }
    }
}
#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_segmentControl && _views)
    {
        [_segmentControl updateBottomBarWithOffset:scrollView.contentOffset.x/(1.0 * _views.count)];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    if (_segmentControl)
    {
        NSInteger index = (int)offset/(int)self.frame.size.width;
        [_segmentControl setSeletAtIndex:index];
        
        if (_kdScrollViewDelegate && [_kdScrollViewDelegate respondsToSelector:@selector(didSelectedAtPageIndex:)])
        {
            [_kdScrollViewDelegate didSelectedAtPageIndex:index];
        }
    }
}


#pragma mark - KDSegmentDelegate
-(void)didSeletedAtIndex:(NSInteger)index
{
    [_scrollView setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:NO];
    if (_kdScrollViewDelegate && [_kdScrollViewDelegate respondsToSelector:@selector(didSelectedAtPageIndex:)])
    {
        [_kdScrollViewDelegate didSelectedAtPageIndex:index];
    }
}
@end
