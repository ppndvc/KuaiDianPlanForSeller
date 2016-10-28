//
//  KDActivityIconView.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/8/28.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDActivityIconView.h"

#define PADDING 5
#define BASE_TAG 100

#define ACTIVITY_PREFIX @"activity"

@interface KDActivityIconView ()

@property(nonatomic,strong)NSMutableArray *iconArray;

@property(nonatomic,assign)NSInteger iconCount;

@end

@implementation KDActivityIconView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI
{
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    
    _iconCount = viewWidth / (viewHeight + PADDING);
    
    CGFloat nextX = 0;
    NSInteger tag = BASE_TAG;
    
    for (int i = 0; i < _iconCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = tag;
        CGRect frame = CGRectMake(nextX, 0, viewHeight, viewHeight);
        imageView.frame = frame;
        [self addSubview:imageView];
        
        nextX += (viewHeight + PADDING);
        tag++;
    }
}

-(void)updateActivities:(KDActivityType)type
{
    NSInteger index = 0;
    
    if (type != KDActivityTypeOfNone)
    {
        KDActivityType baseType = KDActivityTypeOfNew;

        for (; index < _iconCount; index++)
        {
            NSInteger showCount = 0;
            
            for (; index < _iconCount; index++)
            {
                if (type & baseType)
                {
                    UIImageView *imageView = [self viewWithTag:BASE_TAG + showCount];
                    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",ACTIVITY_PREFIX,(int)baseType]];
                    showCount ++;
                }
                
                baseType = baseType << 1;
            }
        }
    }

    //没有的赋值为nil
    for (; index < _iconCount; index++)
    {
        UIImageView *imageView = [self viewWithTag:BASE_TAG + index];
        imageView.image = nil;
    }
}
@end
