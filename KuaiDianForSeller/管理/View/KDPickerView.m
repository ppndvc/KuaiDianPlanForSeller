//
//  KDDateView.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/11/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDPickerView.h"
#import "KDFoodCategoryModel.h"

#define LABEL_WIDTH 50
#define VIEW_HEIGHT 220
#define SEPERATOR_VIEW_RATE 0.6
#define SEPERATOR_VIEW_WIDTH 0.5

#define START_TITLE @"开始"
#define END_TITLE @"结束"
#define ERROR_DATE @"开始时间不能小于结束时间"

@interface KDPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

//显示类型
@property(nonatomic,assign)KDDatePickerType type;

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
@property(nonatomic,strong)UIView *seperatorView;

//
@property(nonatomic,strong)NSArray *pickerViewDataSource;

@end

@implementation KDPickerView

//初始化方法
-(instancetype)initWithType:(KDDatePickerType)type
{
    return [[KDPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER, VIEW_HEIGHT) type:type];
}
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame type:(KDDatePickerType)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _type = type;
        [self setupUI];
    }
    return self;
}

//设置pickerview的数据源
-(void)setDateViewDataSource:(NSArray *)pickerViewDataSource selectedIndex:(NSInteger)index
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

-(void)setupUI
{
    self.backgroundColor = CLEAR_COLOR;
    
    CGFloat halfWidth = self.frame.size.width / 2.0;
    
    CGFloat offset = 5;
    
    _title1 = [[UILabel alloc] initWithFrame:CGRectMake((halfWidth - LABEL_WIDTH)/2.0, offset, LABEL_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
    _title1.font = [UIFont systemFontOfSize:TEXT_FONT_MEDIUM_SIZE];
    _title1.textAlignment = NSTextAlignmentCenter;
    _title1.textColor = [UIColor blackColor];
    _title1.hidden = YES;
    [self addSubview:_title1];
    
    _title2 = [[UILabel alloc] initWithFrame:CGRectMake(halfWidth + (halfWidth - LABEL_WIDTH)/2.0, offset, LABEL_WIDTH, TEXT_FONT_MEDIUM_SIZE)];
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
            _dp1 = [[UIDatePicker alloc] init];
            _dp1.frame = CGRectMake(0 , yOriginOfPicker,self.frame.size.width,VIEW_HEIGHT - yOriginOfPicker);
            _dp1.datePickerMode = UIDatePickerModeDate;
            
            [self addSubview:_dp1];
        }
            break;
        case KDDatePickerTypeOfDoubleTime:
        {
            _dp1 = [[UIDatePicker alloc] init];
            _dp1.frame = CGRectMake(0 , yOriginOfPicker,self.frame.size.width/2.0,VIEW_HEIGHT - yOriginOfPicker);
            _dp1.datePickerMode = UIDatePickerModeTime;
            
            _dp2 = [[UIDatePicker alloc] init];
            _dp2.frame = CGRectMake(self.frame.size.width/2.0 , yOriginOfPicker,self.frame.size.width/2.0,VIEW_HEIGHT - yOriginOfPicker);
            _dp2.datePickerMode = UIDatePickerModeTime;
            
            CGFloat x1 = _dp1.frame.origin.x + _dp1.frame.size.width;
            CGFloat x2 = _dp2.frame.origin.x;
            
            CGFloat sh = _dp1.frame.size.height * SEPERATOR_VIEW_RATE;
            CGFloat yPos = _dp1.frame.origin.y + (_dp1.frame.size.height - sh)/2.0;
            
            _seperatorView = [[UIView alloc] initWithFrame:CGRectMake((x1 + x2)/2.0, yPos, SEPERATOR_VIEW_WIDTH, sh)];
            _seperatorView.backgroundColor = [UIColor lightGrayColor];
            
            [self addSubview:_seperatorView];
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
            _pickerView = [[UIPickerView alloc] init];
            _pickerView.frame = CGRectMake(0 , yOriginOfPicker,self.frame.size.width,VIEW_HEIGHT - yOriginOfPicker);
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            
            [self addSubview:_pickerView];
        }
            break;
        case KDDatePickerTypeOfTime:
        default:
        {
            _dp1 = [[UIDatePicker alloc] init];
            _dp1.frame = CGRectMake(0 , yOriginOfPicker,self.frame.size.width,VIEW_HEIGHT - yOriginOfPicker);
            _dp1.datePickerMode = UIDatePickerModeTime;
            
            [self addSubview:_dp1];
        }
            break;
    }
}
-(NSArray *)getPickerData
{
    NSMutableArray *dataArray = [NSMutableArray new];
    switch (_type)
    {
        case KDDatePickerTypeOfDate:
        {
            if (_dp1.date)
            {
                [dataArray addObject:_dp1.date];
            }
        }
            break;
        case KDDatePickerTypeOfDoubleTime:
        {
            if (_dp1.date && _dp2.date)
            {
                [dataArray addObject:_dp1.date];
                [dataArray addObject:_dp2.date];
            }
        }
            break;
        case KDPickerTypeOfNormalPickerView:
        {
            NSInteger selectedRow = [_pickerView selectedRowInComponent:0];
            if (VALIDATE_ARRAY(_pickerViewDataSource) && _pickerViewDataSource.count > selectedRow)
            {
                id model = _pickerViewDataSource[selectedRow];
                if (model)
                {
                    [dataArray addObject:model];
                }
            }
        }
            break;
        case KDDatePickerTypeOfTime:
        default:
        {
            if (_dp1.date)
            {
                [dataArray addObject:_dp1.date];
            }
        }
            break;
    }
    return dataArray;
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
@end
