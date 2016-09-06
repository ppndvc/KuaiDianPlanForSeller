//
//  KDLinkageTableVIew.m
//  TextViewDemo
//
//  Created by zy on 16/7/4.
//  Copyright © 2016年 ppnd. All rights reserved.
//

#import "KDLinkageTableVIew.h"
#import "KDLinkageTVModel.h"

#import "KDSegmentControl.h"
#import "KDScrollView.h"

#define SEPERATER_POSITION 160

@interface KDLinkageTableView ()

//左侧
@property(nonatomic,strong)UITableView *leftTableView;

//右侧
@property(nonatomic,strong)UITableView *rightTableView;

//头部视图
@property(nonatomic,strong)UIView *headerView;

//数据源
@property(nonatomic,strong)NSMutableArray *dataSource;

//headerview高度
@property(nonatomic,assign)CGFloat headerViewHeight;

@end

@implementation KDLinkageTableView

-(instancetype)init
{
    self = [super init];
    if (self)
    {
//        [self setupUI];
        [self testScrollView];
    }
    return self;
}

-(void)setupUI
{
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _leftTableView.backgroundColor = [UIColor redColor];
    [self addSubview:_leftTableView];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _rightTableView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_rightTableView];
    
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_headerView];
    
    _headerViewHeight = 100;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapView)];
    [_headerView addGestureRecognizer:tap];
}

-(void)testScrollView
{
    KDScrollView *scrollView = [[KDScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, 400) segmentControllHeight:40];
    [self addSubview:scrollView];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 360)];
    view1.backgroundColor = [UIColor redColor];
    [scrollView addView:view1 title:@"test1"];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 360)];
    view2.backgroundColor = [UIColor yellowColor];
    [scrollView addView:view2 title:@"test2"];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 360)];
    view3.backgroundColor = [UIColor greenColor];
    [scrollView addView:view3 title:@"test3"];
}
-(void)onTapView
{
    _headerViewHeight = 50;
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
}
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}
- (void)updateConstraints {
    
//    [self.headerView updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(@0);
//        make.left.equalTo(self.mas_left).offset(@0);
//        make.right.equalTo(self.mas_right).offset(@0);
//        make.width.equalTo(self);
//        make.height.equalTo(@(_headerViewHeight));
//    }];
//    
//    [self.leftTableView updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_headerView.mas_bottom).with.offset(@0);
//        make.left.equalTo(self.mas_left).offset(@0);
//        make.bottom.equalTo(self.mas_bottom).offset(@0);
//        make.width.equalTo(@(SEPERATER_POSITION));
//        make.height.equalTo(_rightTableView);
//    }];
//    
//    [self.rightTableView updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_headerView.mas_bottom).with.offset(@0);
//        make.left.equalTo(_leftTableView.mas_right).offset(@0);
//        make.bottom.equalTo(self.mas_bottom).offset(@0);
//        make.right.equalTo(self.mas_right).offset(@0);
//        make.height.equalTo(_leftTableView);
//    }];
//    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

@end
