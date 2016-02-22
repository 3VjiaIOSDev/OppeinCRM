//
//  StoreCollectionCell.m
//  Crm
//
//  Created by 3Vjia on 15/12/11.
//  Copyright © 2015年 com.3vjia. All rights reserved.
//

#import "StoreCollectionCell.h"


@implementation StoreCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float Screen_Width = [UIScreen mainScreen].bounds.size.width;
        CGFloat imageW = (Screen_Width-30)/2;
        CGFloat imageH = (3*imageW)/4;
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageW, imageH)];
        self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imageView];
        
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), CGRectGetWidth(self.frame), 40)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        
        self.textLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, (Screen_Width-30), 20)];
        self.textLab.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:self.textLab];
        
        self.subLab = [[UILabel alloc]initWithFrame:CGRectMake((Screen_Width-30)/2/2, 10, (Screen_Width-30)/2/2-5, 20)];
        self.subLab.textAlignment = NSTextAlignmentRight;
        self.subLab.font = [UIFont systemFontOfSize:13];
        self.subLab.textColor = [UIColor colorWithRed:246/255.0 green:136/255.0 blue:8/255.0 alpha:1.0f];//(246/255.0, 136/255.0, 8/255.0f, 1.0f);//RGBA(246, 136, 8, 1);
        [bgView addSubview:self.subLab];
    }
    return self;
}


@end
