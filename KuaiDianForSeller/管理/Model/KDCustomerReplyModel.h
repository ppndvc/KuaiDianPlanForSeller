//
//  KDCustomerReplyModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseReplyModel.h"

@interface KDCustomerReplyModel : KDBaseReplyModel

//用户头像url
@property(nonatomic,copy)NSString *imageURL;

//用户id
@property(nonatomic,copy)NSString *customerID;

//平分
@property(nonatomic,assign)CGFloat score;

//商家回复
@property(nonatomic,strong)KDBaseReplyModel *sellerReply;

@end
