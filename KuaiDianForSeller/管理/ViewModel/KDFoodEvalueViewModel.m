//
//  KDFoodEvalueViewModel.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/5.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDFoodEvalueViewModel.h"
#import "KDCustomerReplyModel.h"
#import "KDEvalueTableCell.h"

@interface KDFoodEvalueViewModel ()

@property(nonatomic,strong)NSArray *dataSource;

@end

@implementation KDFoodEvalueViewModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        KDCustomerReplyModel *c1 = [[KDCustomerReplyModel alloc] init];
        c1.replyerName = @"sdafadf";
        c1.score = 4.5;
        c1.content = @"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟，时而盘旋穿梭，时而引吭高歌；仿佛我就是那潺潺流泻于山涧的一汪清泉，涟漪轻盈，浩淼长流；仿佛我就是那竦峙在天地间的一座山峦，伟岸高耸，从容绵延。我不相信佛，只是喜欢玄冥空灵的梵音经贝";
        c1.date = @"1473084359";
        c1.sellerReply = [[KDBaseReplyModel alloc] init];
        c1.sellerReply.replyerName = @"管理员回复";
        c1.sellerReply.date = @"1473084459";
        c1.sellerReply.content = @"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟，时而盘旋穿梭，时而引吭高歌；";
        
        KDCustomerReplyModel *c2 = [[KDCustomerReplyModel alloc] init];
        c2.replyerName = @"sdafadf";
        c2.score = 2.5;
        c2.content = @"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟，时而盘旋穿梭，时而引吭高歌；仿佛我就是那潺潺流泻于山涧的一汪清泉，涟漪轻盈，浩淼长流；仿佛我就是那竦峙在天地间的一座山峦，伟岸高耸，从容绵延";
        c2.date = @"1473084359";
        c2.sellerReply = [[KDBaseReplyModel alloc] init];
        c2.sellerReply.replyerName = @"店铺小二回复";
        c2.sellerReply.date = @"1473084459";
        c2.sellerReply.content = @"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟，时而盘旋穿梭，时而引吭高歌；茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟，时而盘旋穿梭，时而引吭高歌；仿佛我就是那潺潺流泻于山涧的一汪清泉，涟漪轻盈，浩淼长流；仿佛我就是那竦峙在天地间的一座山峦，伟岸高耸，从容绵延。我不相信佛，只是喜欢玄冥空灵的梵音经贝茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟，时而盘旋穿梭，时而引吭高歌；仿佛我就是那潺潺流泻于山涧的一汪清泉，涟漪轻盈，浩淼长流；仿佛我就是那竦峙在天地间的一座山峦，伟岸高耸，从容绵延。我不相信佛，只是喜欢玄冥空灵的梵音经贝";
        
        KDCustomerReplyModel *c3 = [[KDCustomerReplyModel alloc] init];
        c3.replyerName = @"sdafadf";
        c3.score = 2.5;
        c3.content = @"日落时分，沏上一杯山茶，听一曲意境空远的《禅》，心神随此天籁，沉溺于玄妙的幻境里。仿佛我就是那穿梭于葳蕤山林中的一只飞鸟，时而盘旋穿梭，时而引吭高歌；仿佛我就是那潺潺流泻于山涧的一汪清泉，涟漪轻盈，浩淼长流；仿佛我就是那竦峙在天地间的一座山峦，伟岸高耸，从容绵延";
        c3.date = @"1473084359";
        
        _dataSource = @[c1,c3,c2];
    }
    
    return self;
}

-(NSInteger)tableViewRowsForSection:(NSInteger)section
{
    NSInteger rows = 0;
    if (_dataSource && _dataSource.count > 0)
    {
        rows = _dataSource.count;
    }
    return rows;
}

-(void)configureTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (cell && indexPath)
    {
        if (_dataSource && _dataSource.count > indexPath.row)
        {
            [((KDEvalueTableCell *)cell) configureCellWithModel:_dataSource[indexPath.row]];
        }
    }
}
@end
