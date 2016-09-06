//
//  KDDefines.h
//  KuaiDianPlan
//
//  Created by ppnd on 16/6/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#pragma mark - Metric & System

//系统版本定义
#define IS_OS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue]>= 7.0)
//系统版本定义
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue]>= 8.0)
//屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//判断是否合法字符串
#define VALIDATE_STRING(a) ((a) && [(a) isKindOfClass:[NSString class]] && (a).length > 0)

//导航栏 + 状态栏高度
#define NAVIGATION_BAR_HEIHT 64

//状态栏高度
#define STATUS_BAR_HEIHT 20

//tabbar高度
#define TAB_BAR_HEIHT 49

//分割栏高度
#define GENERAL_SEPERATOR_HEIGHT 10.0f

//view和屏幕边缘的水平间距
#define VIEW_HORIZONTAL_PADDING_TO_SCREEN_BORDER 14.0f

//view之间的垂直间距
#define VIEW_VERTICAL_PADDING 14.0f

//按钮高度
#define BUTTON_HEIGHT 37.5f

//圆角半径
#define CORNER_RADIUS 5.0f

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#pragma mark - Colors

//导航栏颜色
#define NAVIBAR_BG_COLOR ([UIColor colorWithRed:234/255.0 green:64/255.0 blue:54/255.0 alpha:1])
//导航栏标题颜色
#define NAVIBAR_TITLE_COLOR ([UIColor whiteColor])
//tabbar背景颜色
#define TABBAR_BG_COLOR ([UIColor whiteColor])
//页面背景颜色
#define APP_BG_COLOR ([UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1])
//分割线颜色
#define SEPERATOR_COLOR ([UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1])
//次要文本颜色
#define TEXT_LOW_COLOR ([UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1])
//详细文本颜色
#define TEXT_MEDIUM_COLOR ([UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1])
//重要文本标题颜色
#define TEXT_HIGH_COLOR ([UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1])
//tabbar选中标题颜色
#define TABBAR_SELECTED_TEXT_COLOR ([UIColor colorWithRed:234/255.0 green:63/255.0 blue:53/255.0 alpha:1])
//hud背景颜色
#define HUD_BG_COLOR ([UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.9])
//hud前景颜色
#define HUD_FG_COLOR ([UIColor whiteColor])
//价格橘色
#define PRICE_ORANG_COLOR ([UIColor colorWithRed:253/255.0 green:97/255.0 blue:33/255.0 alpha:1])
//红色
#define APPD_RED_COLOR ([UIColor colorWithRed:234/255.0 green:63/255.0 blue:53/255.0 alpha:1])

#pragma mark - Font Size

//导航栏标题字体
#define NAVIBAR_TITLE_FONT_SIZE 20.0f

//文本字体巨大
#define TEXT_FONT_HUGE_SIZE 27.0f

//文本字体特大
#define TEXT_FONT_VERY_BIG_SIZE 20.0f
//文本字体大
#define TEXT_FONT_BIG_SIZE 16.0f
//文本字体中
#define TEXT_FONT_MEDIUM_SIZE 14.0f
//文本字体小
#define TEXT_FONT_SMALL_SIZE 12.0f
//hud文本字体
#define HUD_FONT_SIZE 16.0f

#pragma mark - Enums

//网络错误页面类型
typedef NS_ENUM(NSInteger, KDNetworkErrorType)
{
    //网络不可达
    KDNetworkNoReachable = 0,
    //网络请求请求错误
    KDNetworkRequestError = 1,
};

//网络环境类型
typedef NS_ENUM(NSInteger, KDEnvironmentType)
{
    //生产环境
    KDEnvironmentTypeOfProduct = 0,
    //测试环境
    KDEnvironmentTypeOfTest = 1,
};
//URL前缀类型
typedef NS_ENUM(NSInteger, KDURLPrefixType)
{
    //http
    KDURLPrefixTypeOfHTTP = 0,
    //https
    KDURLPrefixTypeOfHTTPS = 1,
};

//导航栏返回类型
typedef NS_ENUM(NSInteger, KDNavigationBackType)
{
    //返回上一页面
    KDNavigationBackToPreviousVC = 0,
    //返回根视图
    KDNavigationBackToRootVC = 1,
    //不显示返回按钮
    KDNavigationNoBackAction = 2,
};

//Mall页面类型
typedef NS_ENUM(NSInteger, KDMallType)
{
    //快点
    KDMallTypeOfDefault = 0,
    //美食
    KDMallTypeOfDeliciousFood = 1,
    //品牌馆
    KDMallTypeOfBrandShop = 2,
    //商城
    KDMallTypeOfNormalShop = 3,
    //早餐
    KDMallTypeOfBreakFast = 4,
};

//订单状态类型
typedef NS_ENUM(NSInteger, KDOrderStatus)
{
    //未支付
    KDOrderStatusOfNotCharged = 0,
    //未接单
    KDOrderStatusOfNotAccepted = 1,
    //已接单
    KDOrderStatusOfAlreadyAccepted = 2,
    //正在派送
    KDOrderStatusOfDelivering = 3,
    //已完成但未评价
    KDOrderStatusOfSuccessButNoEvaluated = 4,
    //已完成以评价
    KDOrderStatusOfSuccessAndEvaluated = 5,
};

//输入状态类型
typedef NS_ENUM(NSInteger, KDInputState)
{
    //输入电话号码状态
    KDInputCellPhoneNumberState = 1,
    //输入验证码状态
    KDInputCodeState = 2,
    //输入新密码状态
    KDInputNewPasswordState = 3,
};

//活动类型
typedef NS_ENUM(NSInteger, KDActivityType)
{
    //新品
    KDActivityTypeOfNew = 1 << 0,
    //赠送
    KDActivityTypeOfPresent = 1 << 1,
    //减价
    KDActivityTypeOfReduce = 1 << 2,
    //特价
    KDActivityTypeOfSpecialOffer = 1 << 3,
};

//口味类型
typedef NS_ENUM(NSInteger, KDTasteType)
{
    //酸
    KDTasteSour = 1 << 0,
    //甜
    KDTasteSweet = 1 << 1,
    //辣
    KDTasteHot = 1 << 2,
    //麻
    KDTasteSpicy = 1 << 3,
};

//菜品做法
typedef NS_ENUM(NSInteger, KDFoodCookieStyle)
{
    //煎
    KDFoodCookieStyleOfFried = 1,
    //炸
    KDFoodCookieStyleOfBlast = 2,
    //烤
    KDFoodCookieStyleOfRoast = 3,
    //蒸
    KDFoodCookieStyleOfSteam = 4,
    //煮
    KDFoodCookieStyleOfBoil = 5,
};

typedef NS_ENUM(NSInteger, KDEvalueStarLevel)
{
    //一星
    KDOneStar = 1,
    //二星
    KDTwoStar = 2,
    //三星
    KDThreeStar = 3,
    //四星
    KDFourStar = 4,
    //五星
    KDFiveStar = 5,
    //全部
    KDNoneSpecific = 6,
};

#pragma mark - Blocks

//错误页面的点击回调
typedef void (^KDNetworkErrorPageTapBlock)(KDNetworkErrorType type);

//视图显示的回调
typedef void (^KDRouterVCAppearBlock)(void);

//视图消失的回调
typedef void (^KDRouterVCDisappearBlock)(NSString *vcKey, id params);

//刷新页面回调
typedef void (^KDMainPageUpdateCallBackBlock)(NSArray *headerViewModels);

//viewmodel开始回调
typedef void (^KDViewModelBeginCallBackBlock)(void);

//viewmodel结束回调
typedef void (^KDViewModelCompleteCallBackBlock)(BOOL isSuccess ,id params , NSError *error);

#pragma mark - static strings

//日志等级
extern int const ddLogLevel;

//系统缓存
extern NSString *const kSystemCacheName;

//用户缓存
extern NSString *const kUserCacheName;

//系统缓存测试环境
extern NSString *const kSystemCacheNameForTest;

//用户缓存测试环境
extern NSString *const kUserCacheNameForTest;

//通用内存缓存
extern NSString *const kCommonCacheInMemoryName;

//订单
extern NSString *const kOrderTableViewCell;

//订单详情
extern NSString *const kOrderDetailTableViewCell;

#pragma mark - defined strings


#define YYYY_MM_DD_HH_MM_SS @"yyyy-MM-dd HH:mm:ss"

#define APP_NAME @"快点"

#define TABBAR_UNHANDLE_TITLE @"未处理"

#define TABBAR_HANDLE_TITLE @"已处理"

#define TABBAR_MANAGEMENT_TITLE @"管理"

#define TABBAR_SETTING_TITLE @"设置"

#define DELICIOUS_FOOD @"美食"
#define BRAND_SHOP @"品牌馆"
#define NORMAL_SHOP @"商城"
#define BREAKFAST @"早餐"

#define CATEGORY_SEARCH @"分类"
#define SORT_SEARCH @"排序"
#define FILTER_SEARCH @"筛选"

#define ORDER_NOT_ACCEPTED @"商家未接单"
#define ORDER_HAS_ACCEPTED @"商家已接单"
#define ORDER_IS_DELIVERING @"配送途中"
#define ORDER_COMPLETED @"订单已完成"

#define BEING_CHARGE_BUTTON_TITLE @"待支付"
#define ALREADY_CHARGED_BUTTON_TITLE @"已支付"
#define BEING_EVALUATE_BUTTON_TITLE @"评价"
#define ALREADY_EVALUATE_BUTTON_TITLE @"已评价"

#define LOGIN_TITLE @"登录"
#define FORGOT_PASSWORD @"修改密码"

#define PLACEHOLDER_FOR_CELLPHONE_NUMBER @"请输入手机号码"
#define PLACEHOLDER_FOR_CODE_NUMBER @"请输入验证码"
#define PLACEHOLDER_FOR_NEW_PASSWORD @"请输入新密码"

#define BUTTON_TITLE_FOR_GET_CODE @"获取验证码"
#define BUTTON_TITLE_SURE @"确定"
#define BUTTON_TITLE_CANCEL @"取消"
#define BUTTON_TITLE_FOR_CHANGE_PASSORD @"修改密码"

#define COOKIE_KEY @"Cookie"

#define ORDER_ARRAY_CACHE_KEY @"order_array_cache_key"

#define ALIPAY_NAME @"支付宝"
#define WEICHAT_PAY_NAME @"微信支付"
#define BANK_PAY_NAME @"银行卡"

#pragma mark - 未处理页面

#define UNHANDLE_TITLE @"未处理"


#pragma mark - 已处理页面

#define HANDLE_LIST_TITLE @"已处理"

#pragma mark - 设置页面
#define MY_ACCOUNT @"我的账户"
#define CONNECT_US @"联系我们"
#define FEEDBACK @"帮助与反馈"

#define USER_NAME @"用户名"
#define MY_MONEY @"我的余额"
#define SEE_DETAIL @"查看明细"
#define BIND_PHONE_NUMBER @"绑定手机"
#define CHANGE_PASSWORD @"修改密码"
#define LOGOU_CURRENT_USER @"退出当前账号"

#pragma mark - 管理页面

#define MANAGE_TITLE @"管理"

#define FOOD_MANAGE_TITLE @"菜品管理"
#define FOOD_EVALUE_TITLE @"菜品评价"
#define SALE_ACTIVITY_TITLE @"营销活动"
#define RESTAURANT_INFO_TITLE @"餐厅信息"

#define FOOD_EDIT_TITLE @"编辑菜品"

#define FOOD_NAME @"菜名"
#define FOOD_DESCRIPTION @"描述"
#define FOOD_CATEFORY @"分类"
#define FOOD_PRICE @"单价"
#define FOOD_LABEL @"标签"

#pragma mark - image name strings

//tabbar
#define TABBAR_UNHANDLED_IMAGE_NORMAL @"tabbar_unhandled_normal"
#define TABBAR_UNHANDLED_IMAGE_SELECTED @"tabbar_unhandled_selected"

#define TABBAR_HANDLED_IMAGE_NORMAL @"tabbar_handled_normal"
#define TABBAR_HANDLED_IMAGE_SELECTED @"tabbar_handled_selected"

#define TABBAR_MANAGMENT_IMAGE_NORMAL @"tabbar_managent_normal"
#define TABBAR_MANAGMENT_IMAGE_SELECTED @"tabbar_managent_selected"

#define TABBAR_SETTING_IMAGE_NORMAL @"tabbar_setting_normal"
#define TABBAR_SETTING_IMAGE_SELECTED @"tabbar_setting_selected"


#pragma mark - tools

//136-3476-5666
#define PHONE_FORMATER_344 @"3-4-4"

#define YYYY_MM_DD_DATE_FORMATER @"yyyy-MM-dd"