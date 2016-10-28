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
        
        /*
         {
         classifyid = 1;
         id = 6;
         lab = 11;
         logourl = "/root/img/demoUpload6a7d41c862304ecf4cd20ab306625a1d";
         name = "\U91cc\U810a\U76d6\U996d";
         price = 12;
         remark = "\U6d4b\U8bd5\U7f13\U5b58";
         soldinmonth = 0;
         state = 0;
         storeid = 1;
         }
         
         */
        
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
@end
