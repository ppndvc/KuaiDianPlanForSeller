//
//  KDTasteLabelView.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/9/17.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDTasteLabelView.h"

#define PADDING 5
#define BASE_TAG 100
#define MAX_IMAGE_WIDTH 20

#define TASTE_PREFIX @"taste"

@interface KDTasteLabelView ()

@property(nonatomic,strong)NSMutableArray *iconArray;

@property(nonatomic,assign)NSInteger iconCount;

@end

@implementation KDTasteLabelView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI
{
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    
    CGFloat imageWidth = MIN(viewHeight, MAX_IMAGE_WIDTH);
    
    _iconCount = viewWidth / (viewHeight + PADDING);
    
    CGFloat nextX = 0;
    NSInteger tag = BASE_TAG;
    
    for (int i = 0; i < _iconCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = tag;
        CGRect frame = CGRectMake(nextX, (viewHeight - imageWidth)/2.0, imageWidth, imageWidth);
        imageView.frame = frame;
        [self addSubview:imageView];
        
        nextX += (imageWidth + PADDING);
        tag++;
    }
}

-(void)updateTastes:(KDTasteType)type
{
    NSInteger index = 0;
    
    if (type != KDTasteNone)
    {
        KDTasteType baseType = KDTasteSour;
        NSInteger showCount = 0;
        
        for (; index < _iconCount; index++)
        {
            if (type & baseType)
            {
                UIImageView *imageView = [self viewWithTag:BASE_TAG + showCount];
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",TASTE_PREFIX,(int)baseType]];
                showCount ++;
            }
            
            baseType = baseType << 1;
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
