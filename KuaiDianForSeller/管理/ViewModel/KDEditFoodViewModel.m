//
//  KDEditFoodViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/16.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDEditFoodViewModel.h"
#import "KDFoodItemModel.h"

#define IMAGEURL_PLACEHOLDER @"#"
#define FOOD_STATE @"1"
#define FOOD_SOLD @"0"

@implementation KDEditFoodViewModel

-(void)startAddFoodItemRequestWithFood:(KDFoodItemModel *)foodModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (!VALIDATE_MODEL(foodModel, @"KDFoodItemModel"))
    {
        return;
    }
    
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    WS(ws);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (VALIDATE_STRING(foodModel.name))
    {
        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
    }
    
    if (VALIDATE_STRING(foodModel.category))
    {
        [params setObject:foodModel.category forKey:REQUEST_KEY_CLASSIFY_ID];
    }
    
    if (VALIDATE_STRING(foodModel.descriptionString))
    {
        [params setObject:foodModel.descriptionString forKey:REQUEST_KEY_DESCRIPITION];
    }
    
    if (foodModel.tasteType != KDTasteNone)
    {
        [params setObject:[NSString stringWithFormat:@"%d",(int)foodModel.tasteType] forKey:REQUEST_KEY_FOOD_LABEL];
    }
    
    if (VALIDATE_STRING(foodModel.name))
    {
        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
    }
    
    if (VALIDATE_STRING(foodModel.name))
    {
        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
    }
    
    [params setObject:FOOD_SOLD forKey:REQUEST_KEY_FOOD_SOLD_IN_MONTH];
    [params setObject:FOOD_STATE forKey:REQUEST_KEY_STATE];
    [params setObject:IMAGEURL_PLACEHOLDER forKey:REQUEST_KEY_LOGO_URL];
    [params setObject:[NSString stringWithFormat:@"%.2f",foodModel.price] forKey:REQUEST_KEY_PRICE];

    [KDRequestAPI sendAddFoodItemWithParam:params completeBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"添加食品请求失败：%@",error.localizedDescription);
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,error);
                });
            }
        }
        else
        {
//            NSDictionary *dict = [responseObject objectForKey:RESPONSE_PAYLOAD];
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(YES,nil,nil);
                });
            }
//            if (VALIDATE_ARRAY(array))
//            {
//                NSArray *foodArray = [NSArray yy_modelArrayWithClass:[KDFoodItemModel class] json:array];
//                
//                if (VALIDATE_ARRAY(foodArray))
//                {
//                    if (VALIDATE_ARRAY(ws.foodListArray))
//                    {
//                        if (ws.foodListArray.count > index)
//                        {
//                            [ws.foodListArray replaceObjectAtIndex:index withObject:foodArray];
//                        }
//                        else
//                        {
//                            [ws.foodListArray addObject:foodArray];
//                        }
//                    }
//                    else
//                    {
//                        ws.foodListArray = [[NSMutableArray alloc] init];
//                        [ws.foodListArray addObject:foodArray];
//                    }
//                    
//                    [[KDCacheManager userCache] setObject:ws.foodListArray forKey:UC_FOOD_LIST_KEY];
//                    
//                    if (completeBlock)
//                    {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            completeBlock(YES,foodArray,nil);
//                        });
//                    }
//                }
//                else
//                {
//                    if (completeBlock)
//                    {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            completeBlock(NO,nil,nil);
//                        });
//                    }
//                }
//                
//            }
//            else
//            {
//                if (completeBlock)
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        completeBlock(NO,nil,nil);
//                    });
//                }
//            }
        }
    }];
}

-(void)updateFoodItemRequestWithFood:(KDFoodItemModel *)foodModel beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (!VALIDATE_MODEL(foodModel, @"KDFoodItemModel"))
    {
        return;
    }
    
    if (beginBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            beginBlock();
        });
    }
    
    WS(ws);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (VALIDATE_STRING(foodModel.name))
    {
        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
    }
    
    if (VALIDATE_STRING(foodModel.category))
    {
        [params setObject:foodModel.category forKey:REQUEST_KEY_CLASSIFY_ID];
    }
    
    if (VALIDATE_STRING(foodModel.descriptionString))
    {
        [params setObject:foodModel.descriptionString forKey:REQUEST_KEY_DESCRIPITION];
    }
    
    if (foodModel.tasteType != KDTasteNone)
    {
        [params setObject:[NSString stringWithFormat:@"%d",(int)foodModel.tasteType] forKey:REQUEST_KEY_FOOD_LABEL];
    }
    
    if (VALIDATE_STRING(foodModel.name))
    {
        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
    }
    
    if (VALIDATE_STRING(foodModel.name))
    {
        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
    }
    
    [params setObject:FOOD_SOLD forKey:REQUEST_KEY_FOOD_SOLD_IN_MONTH];
    [params setObject:[NSString stringWithFormat:@"%d",(int)foodModel.status] forKey:REQUEST_KEY_STATE];
    [params setObject:[NSString stringWithFormat:@"%.2f",foodModel.price] forKey:REQUEST_KEY_PRICE];
    
    [KDRequestAPI sendUpdateFoodItemWithParam:params completeBlock:^(id responseObject, NSError *error) {
        if (error)
        {
            DDLogInfo(@"更新食品请求失败：%@",error.localizedDescription);
            
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(NO,nil,error);
                });
            }
        }
        else
        {
//            NSDictionary *dict = [responseObject objectForKey:RESPONSE_PAYLOAD];
            if (completeBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(YES,nil,nil);
                });
            }
        }
    }];
}
-(void)uploadImage:(UIImage *)image foodCategoryID:(NSString *)cateID beginBlock:(KDViewModelBeginCallBackBlock)beginBlock completeBlock:(KDViewModelCompleteCallBackBlock)completeBlock
{
    if (VALIDATE_MODEL(image, @"UIImage"))
    {
        NSString *currentTime = [NSString getCurrentDateString];
        currentTime = [NSString longMD5WithString:currentTime];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:cateID forKey:REQUEST_KEY_CLASSIFY_ID];
        [params setObject:currentTime forKey:REQUEST_KEY_FILE_NAME];
        
        NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
        
        if (VALIDATE_MODEL(fileData, @"NSData"))
        {
            if (beginBlock)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    beginBlock();
                });
            }

            [KDRequestAPI sendUploadFileWithParam:params fileData:fileData fileName:currentTime progressBlock:nil completeBlock:^(id responseObject, NSError *error) {
                if (error)
                {
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(NO,nil,error);
                        });
                    }
                }
                else
                {
                    /*
                     Printing description of responseObject:
                     {
                     data = "/root/img/demoUpload0f9b081bc951c59c138d4087872e66db";
                     msg = OK;
                     }
                     */
                    NSDictionary *dict = [responseObject objectForKey:RESPONSE_PAYLOAD];
                    if (completeBlock)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completeBlock(YES,nil,nil);
                        });
                    }
                }
            }];
        }
    }
//    if (!VALIDATE_MODEL(foodModel, @"KDFoodItemModel"))
//    {
//        return;
//    }
//    
//    if (beginBlock)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            beginBlock();
//        });
//    }
//
//    WS(ws);
//    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    if (VALIDATE_STRING(foodModel.name))
//    {
//        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
//    }
//    
//    if (VALIDATE_STRING(foodModel.category))
//    {
//        [params setObject:foodModel.category forKey:REQUEST_KEY_CLASSIFY_ID];
//    }
//    
//    if (VALIDATE_STRING(foodModel.descriptionString))
//    {
//        [params setObject:foodModel.descriptionString forKey:REQUEST_KEY_DESCRIPITION];
//    }
//    
//    if (foodModel.tasteType != KDTasteNone)
//    {
//        [params setObject:[NSString stringWithFormat:@"%d",(int)foodModel.tasteType] forKey:REQUEST_KEY_FOOD_LABEL];
//    }
//    
//    if (VALIDATE_STRING(foodModel.name))
//    {
//        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
//    }
//    
//    if (VALIDATE_STRING(foodModel.name))
//    {
//        [params setObject:foodModel.name forKey:REQUEST_KEY_NAME];
//    }
//    
//    [params setObject:FOOD_SOLD forKey:REQUEST_KEY_FOOD_SOLD_IN_MONTH];
//    [params setObject:[NSString stringWithFormat:@"%d",(int)foodModel.status] forKey:REQUEST_KEY_STATE];
//    [params setObject:[NSString stringWithFormat:@"%.2f",foodModel.price] forKey:REQUEST_KEY_PRICE];
//    
//    [KDRequestAPI sendUpdateFoodItemWithParam:params completeBlock:^(id responseObject, NSError *error) {
//        if (error)
//        {
//            DDLogInfo(@"更新食品请求失败：%@",error.localizedDescription);
//            
//            if (completeBlock)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completeBlock(NO,nil,error);
//                });
//            }
//        }
//        else
//        {
//            //            NSDictionary *dict = [responseObject objectForKey:RESPONSE_PAYLOAD];
//            if (completeBlock)
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completeBlock(YES,nil,nil);
//                });
//            }
//        }
//    }];
}
@end
