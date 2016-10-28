//
//  KDFoodLabelCollectionCell.m
//  KuaiDianForSeller
//
//  Created by ppnd on 16/10/15.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "KDCheckViewCell.h"
#import "KDFoodLabelModel.h"
#import "KDCheckViewItemModel.h"

#define TASTE_PREFIX @"taste"

@interface KDCheckViewCell ()

@property(nonatomic,strong)id model;

@end

@implementation KDCheckViewCell

-(void)configureCellWithModel:(id)model
{
    _model = model;
    
    if (VALIDATE_MODEL(model, @"KDFoodLabelModel"))
    {
        [self configureCellWithFoodLabelModel:model];
    }
    else if(VALIDATE_MODEL(model, @"KDCheckViewItemModel"))
    {
        [self configureCellWithCheckModel:model];
    }
}

-(void)configureCellWithCheckModel:(KDCheckViewItemModel *)model
{
    _labelTitle.text = model.name;
    _labelImage.image = [UIImage imageNamed:model.imageName];
    _selectedImage.hidden = !model.isSelected;
}
-(void)configureCellWithFoodLabelModel:(KDFoodLabelModel *)model
{
    _labelTitle.text = model.name;
    _labelImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",TASTE_PREFIX,(int)model.tasteType]];
    _selectedImage.hidden = !model.isSelected;
}

-(void)prepareForReuse
{
    _selectedImage.hidden = YES;
    _labelTitle.text = nil;
    _labelImage.image = nil;
}

@end
