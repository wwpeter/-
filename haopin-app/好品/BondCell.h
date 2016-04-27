//
//  BondCell.h
//  好品
//
//  Created by 朱明科 on 15/12/28.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BondCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rootImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *squlateView;

@end
