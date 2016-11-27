//
//  KDSettingViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/18.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDSettingViewModel.h"
#import "KDActionModel.h"
#import "KDBankModel.h"

#define IMAGE_NAME @"image_name"
#define ROW_NAME @"row_name"

#define IMAGE_WIDTH 18

@interface KDSettingViewModel()

//数据源
@property(nonatomic,strong)NSArray *dataSource;

@property(nonatomic,copy)ImageDownloadCompletedHandler handler;

@end

@implementation KDSettingViewModel
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        KDActionModel *model = [KDActionModel new];
        model.title = MY_ACCOUNT;
        model.imageName = @"user";
        KDActionModel *model2 = [KDActionModel new];
        model2.title = CONNECT_US;
        model2.imageName = @"server";
        KDActionModel *model3 = [KDActionModel new];
        model3.title = FEEDBACK;
        model3.imageName = @"help";
        _dataSource = @[@[model],@[model2,model3]];
    }
    return self;
}
-(NSInteger)tableViewSections
{
    NSInteger sections = 0;
    
    if (_dataSource && _dataSource.count > 0)
    {
        sections = _dataSource.count;
    }
    return sections;
}

-(NSInteger)tableViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if (_dataSource && _dataSource.count > section)
    {
        NSArray *rowArray = _dataSource[section];
        if (rowArray && rowArray.count > 0)
        {
            rows = rowArray.count;
        }
    }
    return rows;
}

-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.section)
        {
            NSArray *rowArray = _dataSource[indexPath.section];
            if (rowArray && rowArray.count > indexPath.row)
            {
                KDActionModel *model = (KDActionModel *)rowArray[indexPath.row];
                cell.imageView.image = [UIImage imageNamed:model.imageName];
                cell.textLabel.text = model.title;
                CGSize itemSize = CGSizeMake(IMAGE_WIDTH, IMAGE_WIDTH);
                UIGraphicsBeginImageContext(itemSize);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [cell.imageView.image drawInRect:imageRect];
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }
    }
}

-(id)tableViewModelForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.section)
        {
            NSArray *rowArray = _dataSource[indexPath.section];
            if (rowArray && rowArray.count > indexPath.row)
            {
                return rowArray[indexPath.row];
            }
        }
    }
    
    return nil;
}

-(void)setFinishDownloadLogoHandler:(ImageDownloadCompletedHandler)handler
{
    _handler = handler;
}
-(void)startRequestBankInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    /*
     accountname = "\U8363\U6d69";
     bankname = 1;
     card = 6227000060540475669;
     id = 1;
     identity = 130286200011091511;
     phone = 13502051792;
     sellerid = 13;
     */
    
    [KDRequestAPI sendGetBankCardInfoWithParam:nil completeBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"获取银行卡信息请求失败：%@",error.localizedDescription);

            if (completeBlock)
            {
                KDBankModel *model = [[KDUserManager sharedInstance] getUserBankInfo];
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
                KDBankModel *model = [KDBankModel yy_modelWithDictionary:dict];
                
                if (VALIDATE_MODEL(model, @"KDBankModel"))
                {
                    [[KDUserManager sharedInstance] updateUserBankInfo:model];
                    
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(YES,model,nil);
                        });
                    }
                }
                else
                {
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(NO,nil,nil);
                        });
                    }
                    
                }
            }
            else
            {
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(NO,nil,nil);
                    });
                }
                
            }
        }
    }];
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
    
    [KDRequestAPI sendGetShopInfoRequestWithParam:nil completeBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"获取餐厅信息请求失败：%@",error.localizedDescription);
            
            KDShopModel *model = [[KDShopManager sharedInstance] getShopInfo];
            
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
-(void)dealloc
{
    DDLogInfo(@"- KDSettingViewModel dealloc");
}
@end
