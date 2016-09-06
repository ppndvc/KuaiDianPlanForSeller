//
//  KDhandleOrderDetailView.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDhandleOrderDetailView.h"
#import "KDOrderModel.h"
#import "KDOrderDetailTableViewCell.h"


#define VERTICAL_PADDING 14
#define HONRIZONTAL_PADDING 14
#define SHARP_STRING @"#"

#define ORDER_DETAIL_ROWHEIGHT 25
#define PAYED_STRING @"(已支付)"
#define UNPAYED_STRING @"(未支付)"
#define TOTAL_PRICE_STRING @"总价"

#define DATE_FORMATER @"yyyy.MM.dd HH:mm:ss"
#define TIME_FORMATER @"HH:mm:ss"

#define TWO_HOUR_SECOND 3600*2


@interface KDHandleOrderDetailView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)KDOrderModel *model;
@end

@implementation KDHandleOrderDetailView

+(instancetype)detailView
{
    
    NSBundle *bundle=[NSBundle mainBundle];
    NSArray *objs=[bundle loadNibNamed:@"KDHandleOrderDetailView" owner:nil options:nil];
    KDHandleOrderDetailView *view = (KDHandleOrderDetailView *)[objs lastObject];;
    view.frame = [[UIScreen mainScreen] bounds];
    return view;
}

- (void)awakeFromNib
{
    [_tableView registerNib:[UINib nibWithNibName:@"KDOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:kOrderDetailTableViewCell];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.userInteractionEnabled = NO;
    _tableView.scrollEnabled = NO;
    [_tableView setRowHeight:ORDER_DETAIL_ROWHEIGHT];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDismiss)];
    [_backgroundView addGestureRecognizer:tap];
}

- (IBAction)onTapActionButton:(id)sender
{
    [self onTapDismiss];
    if (_delegate && [_delegate respondsToSelector:@selector(onTapActionButtonWithModel:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate onTapActionButtonWithModel:_model];
        });
    }
}
-(void)onTapDismiss
{
    self.hidden = YES;
    [self clearView];
}
-(void)showDetailViewWithModel:(KDOrderModel *)model
{
    if (model && [model isKindOfClass:[KDOrderModel class]])
    {
        _model = model;
        
        //次序
        NSMutableAttributedString *countString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",SHARP_STRING,_model.orderID]];
        
        [countString addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE]
                            range:NSMakeRange(0, [SHARP_STRING length])];
        [countString addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:TEXT_FONT_HUGE_SIZE]
                            range:NSMakeRange([SHARP_STRING length], countString.length - [SHARP_STRING length])];
        
        _countLabel.attributedText = countString;
        
        //下单时间
        _createTimeLabel.text = [NSString getTimeString:_model.createTime formater:DATE_FORMATER];
        
        //取货时间
        NSString *pickupStrStart = [NSString getTimeString:_model.startTime formater:TIME_FORMATER];
        NSString *pickupStrStop = [NSString getTimeString:_model.overTime formater:TIME_FORMATER];
        
        _pickUpTimeLabel.text = [NSString stringWithFormat:@"%@-%@",pickupStrStart,pickupStrStop];
        
        //取货码
        _codeLabel.text = _model.pickUpCode;
        
        //用户名
        _nameLabel.text = @"张三";
        
        //用户号码
        NSString *phoneNumber = [NSString getPhoneNumberWithString:_model.phoneNumber formater:PHONE_FORMATER_344];
        [_phoneNumberButton setTitle:phoneNumber forState:UIControlStateNormal];
        
        //备注
        _memoLabel.text = _model.orderDescriptionString;
        
        //详情tableview
        CGPoint tableOrigin = _tableView.frame.origin;
        CGFloat tableHeight = (_model.orderDetail.count + 1) * ORDER_DETAIL_ROWHEIGHT;
        _tableView.frame = CGRectMake(tableOrigin.x, tableOrigin.y, SCREEN_WIDTH, tableHeight);
        
        [_tableView reloadData];
        //操作按钮
        [_actionButton setTitle:BUTTON_TITLE_SURE forState:UIControlStateNormal];
        
        [self updateScrollViewContentSize];
        
        self.hidden = NO;
    }
}
-(void)clearView
{
    _countLabel.attributedText = nil;
    
    //下单时间
    _createTimeLabel.text = nil;
    _pickUpTimeLabel.text = nil;
    
    //取货码
    _codeLabel.text = nil;
    
    //用户名
    _nameLabel.text = nil;
    
    //用户号码
    [_phoneNumberButton setTitle:@"" forState:UIControlStateNormal];
    
    //备注
    _memoLabel.text = nil;
    
    _model = nil;
    [_tableView reloadData];
}
-(void)updateScrollViewContentSize
{
    //详情tableview
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _tableView.frame.origin.y + _tableView.frame.size.height);
    
    //让scrollview每次显示都滚动到最上边
    [_scrollView setContentOffset:CGPointMake(0, 0)];
}
#pragma mark - configure cell tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //默认为1，是因为有总价这一行
    NSInteger rows = 1;
    
    if (_model && _model.orderDetail && _model.orderDetail.count > 0)
    {
        rows = _model.orderDetail.count + 1;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KDOrderDetailTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kOrderDetailTableViewCell];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KDOrderDetailTableViewCell" owner:self options:nil] lastObject];
    }
    
    if (_model && _model.orderDetail && _model.orderDetail.count > indexPath.row)
    {
        KDFoodItemModel *item = _model.orderDetail[indexPath.row];
        [cell configureCellWithModel:item];
    }
    else
    {
        NSString *isPayed = (_model.isPayed?PAYED_STRING:UNPAYED_STRING);
        NSString *totalPrice = [NSString stringWithFormat:@"￥%.2f",_model.totalPrice];
        cell.nameLabel.text = TOTAL_PRICE_STRING;
        cell.countLabel.text = isPayed;
        cell.priceLabel.text = totalPrice;
        cell.priceLabel.textColor = APPD_RED_COLOR;
    }
    
    return cell;
}
@end
