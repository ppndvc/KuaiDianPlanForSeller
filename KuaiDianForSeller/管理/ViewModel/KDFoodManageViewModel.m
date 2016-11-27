//
//  KDFoodManageViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/10.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDFoodManageViewModel.h"
#import "KDFoodCategoryModel.h"
#import "KDFoodItemModel.h"

@interface KDFoodManageViewModel ()

@property(nonatomic,strong)NSArray *categoryArray;

@property(nonatomic,strong)NSMutableArray *foodListArray;

@property(nonatomic,copy)ImageDownloadCompletedHandler handler;


@end

@implementation KDFoodManageViewModel
-(BOOL)needRequestInitData
{
    BOOL need = YES;
    if (VALIDATE_ARRAY(_categoryArray))
    {
        need = NO;
    }
    return need;
}
-(void)startRequestFoodCategoryInfoWithBeginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    WS(ws);
    
        [KDRequestAPI sendGetFoodCategoryInfoRequestWithParam:nil completeBlock:^(id responseObject, NSError *error) {
            if (error)
            {
                DDLogInfo(@"获取餐厅信息请求失败：%@",error.localizedDescription);
                
                ws.categoryArray = (NSArray *)[[KDCacheManager userCache] objectForKey:UC_FOOD_CATEGORY_KEY];
                
                if (completeBlock)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        completeBlock(NO,model,error);
                    });
                }
            }
            else
            {
                NSArray *array = [responseObject objectForKey:RESPONSE_PAYLOAD];
                
                if (VALIDATE_ARRAY(array))
                {
                    NSArray *cateArray = [NSArray yy_modelArrayWithClass:[KDFoodCategoryModel class] json:array];
                    
                    if (VALIDATE_ARRAY(cateArray))
                    {
                        ws.categoryArray = cateArray;
                        [[KDCacheManager userCache] setObject:cateArray forKey:UC_FOOD_CATEGORY_KEY];

                        if (completeBlock)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completeBlock(YES,cateArray,nil);
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
-(void)startRequestFoodListWithID:(NSString *)foodID index:(NSInteger)index beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    WS(ws);
    
    [KDRequestAPI sendGetFoodListInfoRequestWithParam:foodID completeBlock:^(id responseObject, NSError *error) {
        
        if (error)
        {
            DDLogInfo(@"获取食品列表息请求失败：%@",error.localizedDescription);
            
            ws.foodListArray = [[NSMutableArray alloc] initWithArray:(NSArray *)[[KDCacheManager userCache] objectForKey:UC_FOOD_LIST_KEY]];
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                        completeBlock(NO,model,error);
                });
            }
        }
        else
        {
            NSArray *array = [responseObject objectForKey:RESPONSE_PAYLOAD];
            
            if (VALIDATE_ARRAY(array))
            {
                NSArray *foodArray = [NSArray yy_modelArrayWithClass:[KDFoodItemModel class] json:array];
                
                if (VALIDATE_ARRAY(foodArray))
                {
                    [ws startDownloadFoodImageWithArray:foodArray];
                    
                    if (VALIDATE_ARRAY(ws.foodListArray))
                    {
                        if (ws.foodListArray.count > index)
                        {
                            [ws.foodListArray replaceObjectAtIndex:index withObject:foodArray];
                        }
                        else
                        {
                            [ws.foodListArray addObject:foodArray];
                        }
                    }
                    else
                    {
                        ws.foodListArray = [[NSMutableArray alloc] init];
                        [ws.foodListArray addObject:foodArray];
                    }
                    
                    [[KDCacheManager userCache] setObject:ws.foodListArray forKey:UC_FOOD_LIST_KEY];
                    
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(YES,foodArray,nil);
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
-(NSArray *)getAllTableData
{
    return _categoryArray;
}
-(void)setFinishDownloadLogoHandler:(ImageDownloadCompletedHandler)handler
{
    _handler = handler;
}
-(void)startDownloadFoodImageWithArray:(NSArray *)foodArray
{
    if (VALIDATE_ARRAY(foodArray))
    {
        for (KDFoodItemModel *item in foodArray)
        {
            WS(ws);
            if (![[KDCacheManager systemCache] objectForKey:item.imageURL])
            {
                [KDRequestAPI downloadFoodLogoWithFilePath:item.imageURL completeBlock:^(NSDictionary *fileData, NSString *filePath, NSError *error) {
                    NSData *imageData = [fileData objectForKey:RESPONSE_PAYLOAD];
                    if (VALIDATE_MODEL(imageData, @"NSData"))
                    {
                        UIImage *image = [[UIImage alloc] initWithData:imageData];
                        if (VALIDATE_MODEL(image, @"UIImage"))
                        {
                            [[KDCacheManager systemCache] setObject:image forKey:item.imageURL];
                            if (ws.handler)
                            {
                                ws.handler(image);
                            }
                        }
                    }
                }];
            }
        }
    }
}
@end
