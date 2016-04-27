//
//  CombinCell.m
//  好品
//
//  Created by 朱明科 on 15/12/23.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "CombinCell.h"

@implementation CombinCell

- (void)awakeFromNib {
    self.rootImageView.frame = CGRectMake(0, 0, self.frame.size.width, 240);
    self.squlateVIew.frame = CGRectMake(0, 242, 240, 1);
    self.namelabel.frame = CGRectMake(0, 245, 120, 35);
    self.timeLabel.frame = CGRectMake(120, 245, 120, 35);
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
}

@end
