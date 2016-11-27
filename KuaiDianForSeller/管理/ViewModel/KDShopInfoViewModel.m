//
//  KDShopInfoViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/11.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDShopInfoViewModel.h"
#import "KDShopModel.h"

@interface KDShopInfoViewModel ()

//数据源
@property(nonatomic,strong)NSArray *dataSource;

//餐厅信息model
@property(nonatomic,strong)KDShopModel *shopInfo;

@property(nonatomic,copy)ImageDownloadCompletedHandler handler;

@property(nonatomic,assign)BOOL isInfoChanged;

@property(nonatomic,strong)NSArray *shopInfoPropertyArray;

@end

@implementation KDShopInfoViewModel
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _dataSource = @[SHOP_IMAGE,SHOP_NAME,SHOP_BELONG_SCHOOL,SHOP_BELONG_RESTRAUNT,SHOP_ADDRESS,SHOP_OPEN_TIME,SHOP_NOTICE,SHOP_TELEPHONE,SHOP_OPEN_STATUS,SHOP_PAY_STYLE];
        _isInfoChanged = NO;
    }
    
    return self;
}
-(void)setFinishDownloadLogoHandler:(ImageDownloadCompletedHandler)handler
{
    _handler = handler;
}

-(id)getShopInfoModel
{
    return _shopInfo;
}
-(NSInteger)tableViewRowsForSection:(NSInteger)section
{
    NSInteger rowss = 0;
    if (_dataSource && _dataSource.count > 0 && _shopInfo)
    {
        rowss = _dataSource.count;
    }
    
    return rowss;
}

-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && indexPath && _dataSource && _dataSource.count > indexPath.row && _shopInfo)
    {
        NSString *cellTitle = _dataSource[indexPath.row];
        cell.textLabel.text = cellTitle;
        
        switch (indexPath.row)
        {
            case 0:
            {
                UIImageView *headerImageView = (UIImageView *)cell.accessoryView;
                if (VALIDATE_MODEL(headerImageView, @"UIImageView"))
                {
                    headerImageView.image = (UIImage *)[[KDCacheManager systemCache] objectForKey:_shopInfo.imageURL];
                }
            }
                break;
            case 1:
            {
                cell.detailTextLabel.text = _shopInfo.name;
            }
                break;
            case 2:
            {
                cell.detailTextLabel.text = _shopInfo.belongSchool;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 3:
            {
                cell.detailTextLabel.text = _shopInfo.belongRestaurant;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 4:
            {
                cell.detailTextLabel.text = _shopInfo.address;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
            case 5:
            {
                NSString *openTime = [NSString getTimeString:[_shopInfo.openTime doubleValue] formater:HH_MM_DATE_FORMATER];
                NSString *closeTime = [NSString getTimeString:[_shopInfo.closeTime doubleValue] formater:HH_MM_DATE_FORMATER];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",openTime,closeTime];
            }
                break;
            case 6:
            {
                cell.detailTextLabel.text = _shopInfo.notice;
            }
                break;
            case 7:
            {
                cell.detailTextLabel.text = _shopInfo.telephone;
            }
                break;
            case 8:
            {
                NSString *statusStr = @"";
                switch (_shopInfo.shopStatus)
                {
                    case KDShopOpeningStatus:
                    {
                        statusStr = SHOP_OPENING_STATUS_STRING;
                    }
                        break;
                    case KDShopClosedStatus:
                    {
                        statusStr = SHOP_CLOSED_STATUS_STRING;
                    }
                        break;
                    case KDShopPreOpeningStatus:
                    {
                        statusStr = SHOP_PRE_OPENING_STATUS_STRING;
                    }
                        break;
                    case KDShopNoAcceptNewOrderStatus:
                    {
                        statusStr = SHOP_NO_ACCEPT_NEW_ORDER_STATUS_STRING;
                    }
                        break;
                    default:
                        statusStr = @"";
                        break;
                }
                cell.detailTextLabel.text = statusStr;
            }
                break;
            case 9:
            {
                NSString *payStr = @"";
                switch (_shopInfo.payStyle)
                {
                    case KDPayStyleOfOffline:
                    {
                        payStr = SHOP_OFFLINE_PAY;
                    }
                        break;
                    case KDPayStyleOfOnline:
                    {
                        payStr = SHOP_ONLINE_PAY;
                    }
                        break;
                    default:
                        payStr = @"";
                        break;
                }
                cell.detailTextLabel.text = payStr;
            }
                break;
            default:
                break;
        }
    }
}

-(void)updateTableViewAtIndex:(NSInteger)index content:(NSString *)content
{
    if (index > 0 && index < _dataSource.count && VALIDATE_STRING(content))
    {
        switch (index)
        {
            case 0:
            {
                //                cell.detailTextLabel.text = _shopInfo.name;
            }
                break;
            case 1:
            {
                _shopInfo.name = content;
            }
                break;
            case 5:
            {
                _shopInfo.openTime = content;
            }
                break;
            case 6:
            {
                _shopInfo.notice = content;
            }
                break;
            case 7:
            {
                _shopInfo.telephone = content;
            }
                break;
            case 8:
            {
                NSString *statusStr = @"";
                switch (_shopInfo.shopStatus)
                {
                    case KDShopOpeningStatus:
                    {
                        statusStr = SHOP_OPENING_STATUS_STRING;
                    }
                        break;
                    case KDShopClosedStatus:
                    {
                        statusStr = SHOP_CLOSED_STATUS_STRING;
                    }
                        break;
                    case KDShopPreOpeningStatus:
                    {
                        statusStr = SHOP_PRE_OPENING_STATUS_STRING;
                    }
                        break;
                    case KDShopNoAcceptNewOrderStatus:
                    {
                        statusStr = SHOP_NO_ACCEPT_NEW_ORDER_STATUS_STRING;
                    }
                        break;
                    default:
                        statusStr = @"";
                        break;
                }
            }
                break;
            case 9:
            {
                NSString *payStr = @"";
                switch (_shopInfo.payStyle)
                {
                    case KDPayStyleOfOffline:
                    {
                        payStr = SHOP_OFFLINE_PAY;
                    }
                        break;
                    case KDPayStyleOfOnline:
                    {
                        payStr = SHOP_ONLINE_PAY;
                    }
                        break;
                    default:
                        payStr = @"";
                        break;
                }
            }
                break;
            default:
                break;
        }
    }
}
-(void)startRequestShopInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    WS(ws);
//    NSString *shopID = [[[KDUserManager sharedInstance] getUserInfo] shopID];
//
//    if (VALIDATE_STRING(shopID) && !_shopInfo)
    
    if(!_shopInfo)
    {
        [KDRequestAPI sendGetShopInfoRequestWithParam:nil completeBlock:^(id responseObject, NSError *error) {
            if (error)
            {
                DDLogInfo(@"获取餐厅信息请求失败：%@",error.localizedDescription);
                
                KDShopModel *model = [[KDShopManager sharedInstance] getShopInfo];
                ws.shopInfo = model;
                
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(NO,model,error);
                    });
                }
            }
            else
            {
                NSDictionary *dict = [responseObject objectForKey:RESPONSE_PAYLOAD];
                
                if (VALIDATE_DICTIONARY(dict))
                {
                    KDShopModel *model = [KDShopModel yy_modelWithDictionary:dict];
                    
                    if (model && [model isKindOfClass:[KDShopModel class]])
                    {
                        ws.shopInfo = model;
                        [[KDShopManager sharedInstance] updateShopInfo:model];
                        [ws startDownloadShopLogoWithFilePath:model.imageURL];
                        
                        if (completeBlock)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completeBlock(YES,nil,nil);
                            });
                        }
                    }
                    else
                    {
                        KDShopModel *model = [[KDShopManager sharedInstance] getShopInfo];
                        ws.shopInfo = model;
                        
                        if (completeBlock)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completeBlock(NO,model,nil);
                            });
                        }

                    }
                }
                else
                {
                    KDShopModel *model = [[KDShopManager sharedInstance] getShopInfo];
                    ws.shopInfo = model;
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(NO,model,nil);
                        });
                    }

                }
            }
        }];
    }
    else
    {
        if (completeBlock)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(YES,nil,nil);
            });
        }
    }
}
-(void)startDownloadShopLogoWithFilePath:(NSString *)srcFilePath
{
    if (VALIDATE_STRING(srcFilePath))
    {
        WS(ws);
        if ([[KDCacheManager systemCache] objectForKey:srcFilePath])
        {
            if (ws.handler)
            {
                ws.handler((UIImage *)[[KDCacheManager systemCache] objectForKey:srcFilePath]);
            }
        }
        else
        {
            [KDRequestAPI downloadShopLogoWithFilePath:srcFilePath completeBlock:^(NSDictionary *fileData, NSString *filePath, NSError *error) {
                if (!error && VALIDATE_MODEL(fileData, @"NSDictionary"))
                {
                    NSData *imageData = [fileData objectForKey:RESPONSE_PAYLOAD];
                    if (VALIDATE_MODEL(imageData, @"NSData"))
                    {
                        UIImage *image = [[UIImage alloc] initWithData:imageData];
                        if (VALIDATE_MODEL(image, @"UIImage"))
                        {
                            [[KDCacheManager systemCache] setObject:image forKey:srcFilePath];
                            if (ws.handler)
                            {
                                ws.handler(image);
                            }
                        }
                    }
                }
            }];
        }
    }
}
-(void)changeValue:(id)value forPropety:(NSString *)property
{
    if (VALIDATE_STRING(property) && value)
    {
        if (!VALIDATE_ARRAY(_shopInfoPropertyArray))
        {
            _shopInfoPropertyArray = [KDTools getPropertiesOfClass:[KDShopModel class]];
        }
        
        if ([_shopInfoPropertyArray containsObject:property])
        {
            _isInfoChanged = YES;
            [_shopInfo setValue:value forKey:property];
        }
    }
}
-(BOOL)isShopInfoChanged
{
    return _isInfoChanged;
}

-(UIImage *)getLogoImage
{
    return (UIImage *)[[KDCacheManager systemCache] objectForKey:_shopInfo.imageURL];
}
@end
