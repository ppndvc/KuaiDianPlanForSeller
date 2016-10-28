//
//  KDDatePicker.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/26.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDDatePicker.h"
#import "KDFoodCategoryModel.h"

#define BUTTON_WIDTH 50
#define LABEL_WIDTH 50
#define VIEW_HEIGHT 220

#define ALPHA 0.0
#define ANIMATION_DURATION 0.3

#define START_TITLE @"开始"
#define END_TITLE @"结束"
#define ERROR_DATE @"开始时间不能小于结束时间"

@interface KDDatePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

//
@property(nonatomic,weak)UIView *superView;

//
@property(nonatomic,strong)UIView *bgView;

//显示类型
@property(nonatomic,assign)KDDatePickerType type;

//
@property(nonatomic,strong)UIButton *cancelButton;

//
@property(nonatomic,strong)UIButton *sureButton;

//
@property(nonatomic,strong)UIDatePicker *dp1;

//
@property(nonatomic,strong)UIDatePicker *dp2;

//
@property(nonatomic,strong)UIPickerView *pickerView;

//
@property(nonatomic,strong)UILabel *title1;

//
@property(nonatomic,strong)UILabel *title2;

//
@property(nonatomic,copy)KDDatePickerCompleteBlock completeBlock;

//
@property(nonatomic,strong)NSArray *pickerViewDataSource;

@end

@implementation KDDatePicker

+(void)showDatePickerWithType:(KDDatePickerType)type completeBlock:(KDDatePickerCompleteBlock)completeBlock superView:(UIView *)superView
{
    KDDatePicker *dp = [[KDDatePicker alloc] initWithType:type completeBlock:completeBlock superView:superView];
    if (dp)
    {
        [dp showDatePickerWithAnimated:YES];
    }
}

-(instancetype)initWithType:(KDDatePickerType)type completeBlock:(KDDatePickerCompleteBlock)completeBlock superView:(UIView *)superView
{
    self = [super init];
    if (self)
    {
        if (superView)
        {
            _type = type;
            _superView = superView;
            _completeBlock = completeBlock;
            self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, VIEW_HEIGHT);

            [self setupUI];
        }
    }
    
    return self;
}

-(void)setupUI
{
    self.backgroundColor = SEPERATOR_COLOR;
    //菜单栏
    [self setupToolBar];

    CGFloat halfWidth = self.frame.size.width / 2.0;
    
    CGFloat offset = 5;
    
    _title1 = [[UILabel alloc] initWithFrame:CGRectMake((halfWidth - LABEL_WIDTH)/2.0,offset + _cancelButton.frame.size.height, LABEL_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
    _title1.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    _title1.textAlignment = NSTextAlignmentCenter;
    _title1.textColor = [UIColor blackColor];
    _title1.hidden = YES;
    [self addSubview:_title1];
    
    _title2 = [[UILabel alloc] initWithFrame:CGRectMake(halfWidth + (halfWidth - LABEL_WIDTH)/2.0, offset + _cancelButton.frame.size.height, LABEL_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
    _title2.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    _title2.textAlignment = NSTextAlignmentCenter;
    _title2.textColor = [UIColor blackColor];
    _title2.hidden = YES;
    [self addSubview:_title2];
    
    CGFloat yOriginOfPicker = _title2.frame.origin.y + _title2.frame.size.height - offset;
    switch (_type)
    {
        case KDDatePickerTypeOfDate:
        {
            _dp1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0 , yOriginOfPicker,self.frame.size.width,VIEW_HEIGHT - yOriginOfPicker)];
            _dp1.datePickerMode = UIDatePickerModeDate;
            
            [self addSubview:_dp1];
        }
            break;
        case KDDatePickerTypeOfDoubleTime:
        {
            _dp1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0 , yOriginOfPicker,self.frame.size.width/2.0,VIEW_HEIGHT - yOriginOfPicker)];
            _dp1.datePickerMode = UIDatePickerModeTime;
            
            _dp2 = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0 , yOriginOfPicker,self.frame.size.width/2.0,VIEW_HEIGHT - yOriginOfPicker)];
            _dp2.datePickerMode = UIDatePickerModeTime;
            
            [self addSubview:_dp1];
            [self addSubview:_dp2];
            
            _title1.text = START_TITLE;
            _title2.text = END_TITLE;
            
            _title1.hidden = NO;
            _title2.hidden = NO;
        }
            break;
        case KDPickerTypeOfNormalPickerView:
        {
            _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0 , yOriginOfPicker,self.frame.size.width,VIEW_HEIGHT - yOriginOfPicker)];
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            
            [self addSubview:_pickerView];
        }
            break;
        case KDDatePickerTypeOfTime:
        default:
        {
            _dp1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(0 , yOriginOfPicker,self.frame.size.width,VIEW_HEIGHT - yOriginOfPicker)];
            _dp1.datePickerMode = UIDatePickerModeTime;
            
            [self addSubview:_dp1];
        }
            break;
    }
    
}

-(void)setupToolBar
{
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, BUTTON_HEIGHT)];
    toolBar.backgroundColor = [UIColor whiteColor];
    UIView *topSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    topSeperator.backgroundColor = SEPERATOR_COLOR;
    UIView *bottomSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, BUTTON_HEIGHT, self.frame.size.width, 0.5)];
    bottomSeperator.backgroundColor = SEPERATOR_COLOR;
    [toolBar addSubview:topSeperator];
    [toolBar addSubview:bottomSeperator];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:BUTTON_TITLE_CANCEL forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[self tintColor] forState:UIControlStateNormal];
    _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cancelButton addTarget:self action:@selector(onTapCancel) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.frame = CGRectMake(VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setTitle:BUTTON_TITLE_SURE forState:UIControlStateNormal];
    [_sureButton setTitleColor:[self tintColor] forState:UIControlStateNormal];
    _sureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_sureButton addTarget:self action:@selector(onTapSure) forControlEvents:UIControlEventTouchUpInside];
    _sureButton.frame = CGRectMake(self.frame.size.width - BUTTON_WIDTH - VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
    
    [toolBar addSubview:_cancelButton];
    [toolBar addSubview:_sureButton];
    
    [self addSubview:toolBar];
}

-(void)setPickerViewDataSource:(NSArray *)pickerViewDataSource selectedIndex:(NSInteger)index
{
    if (VALIDATE_ARRAY(pickerViewDataSource))
    {
        _pickerViewDataSource = [[NSArray alloc] initWithArray:pickerViewDataSource];
        [_pickerView reloadAllComponents];
        
        if (index > 0 && _pickerViewDataSource.count > index)
        {
            [_pickerView selectRow:index inComponent:0 animated:NO];
        }
    }
}

-(void)onTapCancel
{
    [self hideDatePickerWithAnimated:YES];
}

-(void)onTapSure
{
    NSDate* date1 = [_dp1 date];
    NSDate* date2 = [_dp2 date];
    
    if (_type == KDDatePickerTypeOfDoubleTime)
    {
        if ([date1 compare:date2] == NSOrderedAscending)
        {
            if (_completeBlock)
            {
                _completeBlock(date1,date2);
            }
            
            [self hideDatePickerWithAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:ERROR_DATE];
        }
    }
    else if (_type == KDPickerTypeOfNormalPickerView)
    {
        if (_completeBlock)
        {
            NSInteger selectedRow = [_pickerView selectedRowInComponent:0];
            KDFoodCategoryModel *model = _pickerViewDataSource[selectedRow];
            NSString *title = @"";
            if (VALIDATE_MODEL(model, @"KDFoodCategoryModel"))
            {
                title = model.name;
            }
            _completeBlock(title,model);
        }
        
        [self hideDatePickerWithAnimated:YES];
    }
    else
    {
        if (_completeBlock)
        {
            _completeBlock(date1,date2);
        }
        
        [self hideDatePickerWithAnimated:YES];
    }
}

-(void)showDatePickerWithAnimated:(BOOL)animated
{
    if (animated)
    {
        [_superView addSubview:self.bgView];
        [_superView addSubview:self];

        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.frame = CGRectMake(0, SCREEN_HEIGHT - VIEW_HEIGHT, SCREEN_WIDTH, VIEW_HEIGHT);
        }];
    }
    else
    {
        [_superView addSubview:self.bgView];
        [_superView addSubview:self];

        self.frame = CGRectMake(0, SCREEN_HEIGHT - VIEW_HEIGHT, SCREEN_WIDTH, VIEW_HEIGHT);
    }
}
-(void)hideDatePickerWithAnimated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, VIEW_HEIGHT);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.bgView removeFromSuperview];
        }];
    }
    else
    {
        [self removeFromSuperview];
        [self.bgView removeFromSuperview];
    }
}
#pragma Mark -- UIPickerViewDataSource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rows = 0;
    
    if (VALIDATE_ARRAY(_pickerViewDataSource))
    {
        rows = _pickerViewDataSource.count;
    }
    
    return rows;
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    
    if (VALIDATE_ARRAY(_pickerViewDataSource) && _pickerViewDataSource.count > row)
    {
        KDFoodCategoryModel *model = _pickerViewDataSource[row];
        if (VALIDATE_MODEL(model, @"KDFoodCategoryModel"))
        {
            title = model.name;
        }
    }
    
    if (!VALIDATE_STRING(title))
    {
        title = @"";
    }
    
    return title;
}

-(UIView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[UIView alloc] initWithFrame:[_superView bounds]];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:ALPHA];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCancel)];
        [_bgView addGestureRecognizer:tap];
    }
    
    return _bgView;
}
@end
