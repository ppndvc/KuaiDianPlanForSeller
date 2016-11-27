//
//  KDBaseReplyModel.h
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDBaseModel.h"

@interface KDBaseReplyModel : KDBaseModel

//id
@property(nonatomic,copy)NSString *identifier;

//评论人姓名
@property(nonatomic,copy)NSString *replyerName;

//评论时间
@property(nonatomic,copy)NSString *date;

//评论内容
@property(nonatomic,copy)NSString *content;

@end
