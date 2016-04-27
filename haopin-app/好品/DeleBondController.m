//
//  DeleBondController.m
//  好品
//
//  Created by 朱明科 on 16/1/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "DeleBondController.h"
#import "DataManager.h"
#import "BondCell.h"

@interface DeleBondController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UICollectionView *collectionView;
@end

@implementation DeleBondController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self initCollection];
    [self createData];
}
-(void)delet:(UIButton *)button{
    for (NSInteger i = 0; i < self.deleArr.count; i ++) {
        Bond *bond = self.deleArr[i];
        [self.dataArr removeObject:bond];
        [[DataManager sharedInstance]deleteByDetailTimer:bond.bondDetail];
    }
    self.deleArr = nil;
    [self.collectionView reloadData];
}
-(void)done:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createData{
    self.dataArr = [[DataManager sharedInstance]fetchByYear:[_userDeft objectForKey:@"selectSTR"]];
    [self.collectionView reloadData];
}
-(void)initCollection{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    layOut.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 69, kWidth, kHeight-69) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = YES;//允许多选
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"BondCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
}
#pragma mark - collectionview data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    Bond *bond = self.dataArr[indexPath.row];
    cell.rootImageView.image = bond.bondImage;
    cell.nameLabel.text = bond.bondName;
    cell.timeLabel.text = bond.bondTime;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Bond *bond = self.dataArr[indexPath.row];
    BondCell *cell = (BondCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor];
    [self.deleArr addObject:bond];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    Bond *bond = self.dataArr[indexPath.row];
    BondCell *cell = (BondCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
    [self.deleArr removeObject:bond];
}
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
@end
