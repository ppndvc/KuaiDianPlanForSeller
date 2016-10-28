//
//  KDEditFoodViewController.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/24.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDEditFoodItemViewController.h"
#import "KDTasteLabelView.h"
#import "KDFoodItemModel.h"
#import "JMActionSheet.h"
#import "KDDatePicker.h"
#import "KDFoodCategoryModel.h"
#import "KDEditFoodViewModel.h"

#define HEADERVIEW_HEIGHT 120
#define MAX_IMAGE_WIDTH 1024

#define NON_SELECTED_INDEX (-1)

#define PICTURE_BUTTON_TITLE @"从相册选取"
#define CAMERA_BUTTON_TITLE @"相机拍摄"

#define FOOD_NAME_LENGTH_STRING @"20个字以内"
#define FOOD_DECS_LENGTH_STRING @"50个字以内"

#define FOOD_NAME @"菜名"
#define FOOD_DESC @"描述"


@interface KDEditFoodItemViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

//数据源
@property(nonatomic,strong)NSArray *dataSource;

//菜品
@property(nonatomic,strong)UITextField *foodTextField;

//描述
@property(nonatomic,strong)UITextField *descriptionTextField;

//分类
@property(nonatomic,strong)UITextField *cateTextField;

//单价
@property(nonatomic,strong)UITextField *priceTextField;

//
@property(nonatomic,strong)KDFoodItemModel *foodModel;

//
@property(nonatomic,strong)KDFoodItemModel *originalFoodModel;

//
@property(nonatomic,strong)NSArray *foodCateArray;

//
@property(nonatomic,strong)KDEditFoodViewModel *viewModel;

//编辑模式
@property(nonatomic, assign)BOOL isEditMode;

@end

@implementation KDEditFoodItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = FOOD_EDIT_TITLE;
    [self setNaviBarItemWithType:KDNavigationBackToPreviousVC];
    _viewModel = [[KDEditFoodViewModel alloc] init];
    
    _dataSource = @[@[FOOD_NAME,FOOD_DESCRIPTION],@[FOOD_CATEFORY,FOOD_PRICE,FOOD_LABEL]];
    
    if (VALIDATE_DICTIONARY(self.parameters))
    {
        _foodCateArray = [self.parameters objectForKey:FOOD_CATEGORY_ARRAY_KEY];
        _foodModel = [self.parameters objectForKey:FOOD_ITEM_KEY];
    }
    
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //启用滑动返回
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];

    //启用滑动返回
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}

-(void)setupUI
{
    UITapGestureRecognizer *tapLabelView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLabel)];
    [_labelView addGestureRecognizer:tapLabelView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHeaderView)];
    [_imageView addGestureRecognizer:tapHeader];
    
    _foodPriceTextField.delegate = self;
    
    if (VALIDATE_MODEL(_foodModel, @"KDFoodItemModel"))
    {
        [_foodNameButton setTitle:_foodModel.name forState:UIControlStateNormal];
        [_foodDescButton setTitle:_foodModel.descriptionString forState:UIControlStateNormal];
        [_foodCategoryButton setTitle:[self getFoodCategoryStringWithID:_foodModel.category] forState:UIControlStateNormal];
        _foodPriceTextField.text = [NSString stringWithFormat:@"%.2f",_foodModel.price];
        [_labelView updateTastes:_foodModel.tasteType];
        
        //从缓存读取
        UIImage *image = (UIImage *)[[KDCacheManager userCache] objectForKey:_foodModel.imageURL];
        [self setImageViewImage:image contentMode:UIViewContentModeScaleAspectFill];
        
        _deleteFoodButton.enabled = YES;
        _originalFoodModel = [_foodModel copy];
        _isEditMode = YES;
    }
    else
    {
        _foodModel = [[KDFoodItemModel alloc] init];
        _deleteFoodButton.enabled = NO;
        _isEditMode = NO;
    }
}
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
}

-(void)onTapHeaderView
{
    if (_isEditMode)
    {
        return;
    }
    
    [self.view endEditing:YES];

    __block UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.view.backgroundColor = [UIColor clearColor];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [imagePicker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    JMActionSheetDescription *desc = [[JMActionSheetDescription alloc] init];
    desc.actionSheetTintColor = [UIColor grayColor];
    desc.actionSheetCancelButtonFont = [UIFont boldSystemFontOfSize:17.0f];
    desc.actionSheetOtherButtonFont = [UIFont systemFontOfSize:16.0f];
    
    JMActionSheetItem *cancelItem = [[JMActionSheetItem alloc] init];
    cancelItem.title = BUTTON_TITLE_CANCEL;
    desc.cancelItem = cancelItem;
    
    WS(ws);
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        JMActionSheetItem *cameraAction = [[JMActionSheetItem alloc] init];
        cameraAction.title = CAMERA_BUTTON_TITLE;
        cameraAction.action = ^(void){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [ws presentViewController:imagePicker animated:YES completion:nil];
        };
        [items addObject:cameraAction];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        JMActionSheetItem *pictureAction = [[JMActionSheetItem alloc] init];
        pictureAction.title = PICTURE_BUTTON_TITLE;
        
        pictureAction.action = ^(void){
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [ws presentViewController:imagePicker animated:YES completion:nil];
        };
        [items addObject:pictureAction];
    }
    
    desc.items = items;
    [JMActionSheet showActionSheet:desc];
}

-(void)dealloc
{
    DDLogInfo(@"-KDEditFoodViewController dealloc");
}

- (IBAction)onTapFoodName:(id)sender
{
    [self.view endEditing:YES];

    WS(ws);
    [[KDRouterManger sharedManager] pushVCWithKey:@"KDCommonTextEditVC" parentVC:self params:@{COMMON_INPUT_TITLE_KEY:FOOD_NAME,COMMON_INPUT_PLACEHOLDER_KEY:FOOD_NAME_LENGTH_STRING,COMMON_INPUT_CHARACTER_CONSTRAIN_KEY:[NSNumber numberWithInteger:SHORT_TEXT_CHARACTER_CONSTRAIN],COMMON_INPUT_STYLE_KEY:[NSNumber numberWithInteger:KDCommonInputStyleOfSingleRow]} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
        
        __strong __typeof(ws) strongSelf = ws;
        
        if (params && [params isKindOfClass:[NSDictionary class]])
        {
            NSString *str = [params objectForKey:COMMON_INPUT_RESULT_STRING_KEY];
            
            if (VALIDATE_STRING(str))
            {
                [strongSelf.foodNameButton setTitle:str forState:UIControlStateNormal];
                strongSelf.foodModel.name = str;
            }
        }
    }];

}

- (IBAction)onTapFoodDesc:(id)sender
{
    [self.view endEditing:YES];

    WS(ws);
    [[KDRouterManger sharedManager] pushVCWithKey:@"KDCommonTextEditVC" parentVC:self params:@{COMMON_INPUT_TITLE_KEY:FOOD_DESC,COMMON_INPUT_INITSTRING_KEY:@"",COMMON_INPUT_CHARACTER_CONSTRAIN_KEY:[NSNumber numberWithInteger:LONG_TEXT_CHARACTER_CONSTRAIN],COMMON_INPUT_STYLE_KEY:[NSNumber numberWithInteger:KDCommonInputStyleOfMultiRows]} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
        __strong __typeof(ws) strongSelf = ws;
        
        if (params && [params isKindOfClass:[NSDictionary class]])
        {
            NSString *str = [params objectForKey:COMMON_INPUT_RESULT_STRING_KEY];
            
            if (VALIDATE_STRING(str))
            {
                [strongSelf.foodDescButton setTitle:str forState:UIControlStateNormal];
                strongSelf.foodModel.descriptionString = str;
            }
        }
    }];

}

- (IBAction)onTapFoodCate:(id)sender
{
    [self.view endEditing:YES];
    if (VALIDATE_ARRAY(_foodCateArray))
    {
        WS(ws);
        KDDatePicker *pickerView = [[KDDatePicker alloc] initWithType:KDPickerTypeOfNormalPickerView completeBlock:^(NSString *date1, KDFoodCategoryModel *model) {
            
            __strong __typeof(ws) strongSelf = ws;

            if (VALIDATE_MODEL(model, @"KDFoodCategoryModel"))
            {
                [strongSelf.foodCategoryButton setTitle:date1 forState:UIControlStateNormal];
                strongSelf.foodModel.categoryDescription = model.name;
                strongSelf.foodModel.category = model.category;
            }
            
        } superView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        
        [pickerView setPickerViewDataSource:_foodCateArray selectedIndex:NON_SELECTED_INDEX];
        [pickerView showDatePickerWithAnimated:YES];
    }
}

- (IBAction)onTapDelete:(id)sender
{
}
- (IBAction)onTapSure:(id)sender
{
    if ([self isValidateFoodItem])
    {
        WS(ws);
        
        if (_isEditMode)
        {
            [_viewModel updateFoodItemRequestWithFood:_foodModel beginBlock:^{
                [ws showHUD];
            } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
                __strong __typeof(ws) strongSelf = ws;
                if (isSuccess)
                {
                    [strongSelf hideHUD];
                    if (strongSelf.vcDisappearBlock)
                    {
                        strongSelf.vcDisappearBlock(nil,params);
                        [strongSelf leftBarButtonAction];
                    }
                }
                else
                {
                    [strongSelf showErrorHUDWithStatus:[error localizedDescription]];
                    //修改失败 改为原来的模型值
                    [strongSelf.foodModel updateModel:strongSelf.originalFoodModel];
                }
            }];
        }
        else
        {
            [_viewModel startAddFoodItemRequestWithFood:_foodModel beginBlock:^{
                [ws showHUD];
            } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
                __strong __typeof(ws) strongSelf = ws;
                if (isSuccess)
                {
                    [strongSelf hideHUD];
                    if (strongSelf.vcDisappearBlock)
                    {
                        strongSelf.vcDisappearBlock(nil,params);
                        [strongSelf leftBarButtonAction];
                    }
                }
                else
                {
                    [strongSelf showErrorHUDWithStatus:[error localizedDescription]];
                }
            }];
        }
    }
}

-(void)onTapLabel
{
    [self.view endEditing:YES];

    WS(ws);
    [[KDRouterManger sharedManager] pushVCWithKey:@"KDSetFoodLabelVC" parentVC:self params:@{SET_FOOD_LABEL_TASTE_KEY:[NSNumber numberWithInteger:KDTasteSweet]} animate:YES vcDisappearBlock:^(NSString *vcKey, id params) {
        
        __strong __typeof(ws) strongSelf = ws;

        if (VALIDATE_MODEL(params, @"NSNumber"))
        {
            [strongSelf.labelView updateTastes:[params integerValue]];
            strongSelf.foodModel.tasteType = [params integerValue];
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self processImage:selectedImage];
}
-(void)processImage:(UIImage *)srcImage
{
    [self showHUD];
    srcImage = [KDTools compressWithSourceImage:srcImage targetWidth:MAX_IMAGE_WIDTH];
    [self setImageViewImage:srcImage contentMode:UIViewContentModeScaleAspectFill];
    [self hideHUD];

    WS(ws);
    [_viewModel uploadImage:srcImage foodCategoryID:_foodModel.category beginBlock:^{
        [ws showHUD];
    } completeBlock:^(BOOL isSuccess, id params, NSError *error) {
        [ws hideHUD];
    }];
}
-(void)setImageViewImage:(UIImage *)image contentMode:(UIViewContentMode)mode
{
    if (VALIDATE_MODEL(image, @"UIImage"))
    {
        _imageView.contentMode = mode;
        _imageView.clipsToBounds = YES;
        _imageView.image = image;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *priceStr = _foodPriceTextField.text;
    if (VALIDATE_STRING(priceStr))
    {
        _foodModel.price = [priceStr floatValue];
    }
}
-(BOOL)isValidateFoodItem
{
    if (!VALIDATE_MODEL(_foodModel, @"KDFoodItemModel"))
    {
        return NO;
    }
    else
    {
        if (VALIDATE_STRING(_foodModel.name) && VALIDATE_STRING(_foodModel.category) && _foodModel.price > 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}
-(NSString *)getFoodCategoryStringWithID:(NSString *)cateID
{
    __block NSString *cateStr = nil;
    if (VALIDATE_ARRAY(_foodCateArray) && VALIDATE_STRING(cateID))
    {
        [_foodCateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            KDFoodCategoryModel *model = obj;
            if (VALIDATE_MODEL(model, @"KDFoodCategoryModel"))
            {
                if ([model.category isEqualToString:cateID])
                {
                    cateStr = model.name;
                    *stop = YES;
                }
            }
        }];
    }
    
    return cateStr;
}
-(void)leftBarButtonAction
{
    //提示是否取消编辑？
    [self.navigationController popViewControllerAnimated:YES];
}
@end
