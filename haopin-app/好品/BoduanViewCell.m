//
//  BoduanViewCell.m
//  haopin
//
//  Created by 朱明科 on 16/4/13.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "BoduanViewCell.h"

@implementation BoduanViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
-(void)initUI{
    self.boDuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 55)];
    _boDuanLabel.textColor = [UIColor whiteColor];
    _boDuanLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _boDuanLabel.textAlignment = NSTextAlignmentCenter;
    _boDuanLabel.layer.borderWidth = 1;
    _boDuanLabel.userInteractionEnabled = YES;
    _boDuanLabel.layer.borderColor = [UIColor colorWithRed:135.0/256 green:135.0/256 blue:135.0/256 alpha:1.0].CGColor;
    [self addSubview:_boDuanLabel];
}
@end
