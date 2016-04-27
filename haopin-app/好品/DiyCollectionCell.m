//
//  DiyCollectionCell.m
//  haopin
//
//  Created by 朱明科 on 16/3/24.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "DiyCollectionCell.h"

@implementation DiyCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.bjLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 10, 10)];
    _bjLabel.layer.borderWidth = 1;
    _bjLabel.layer.borderColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0].CGColor;
    
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 100, 40)];
    self.textLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0];
    [self addSubview:_bjLabel];
    [self addSubview:_textLabel];
}
@end
