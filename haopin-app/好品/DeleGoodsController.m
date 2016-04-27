//
//  DeleGoodsController.m
//  好品
//
//  Created by 朱明科 on 16/1/19.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "DeleGoodsController.h"
#import "DataBase.h"

@interface DeleGoodsController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UICollectionView *collectionView;
@end

@implementation DeleGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self initCollection];
    [self createData];
}
-(void)delet:(UIButton *)button{
    for (NSInteger i = 0; i < self.deleArr.count; i ++) {
        ClothPhoto *photo = self.deleArr[i];
        [self.dataArr removeObject:photo];
        [[DataBase shareInstance]deleteClothByInd:photo.ind];
    }
    self.deleArr = nil;
    [self.collectionView reloadData];
}
-(void)done:(UIButton *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createData{
    self.dataArr = [[DataBase shareInstance]fetchBySession:[_userDeft objectForKey:@"selectSTR"]];
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
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
}
#pragma mark - collectionview data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ClothPhoto *photo = self.dataArr[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kItemWidth, 244)];
    imageView.image = photo.image;//只显示正面图
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 244, kItemWidth, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%@%@%@",photo.year,photo.type,photo.color];
    label.backgroundColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    [imageView addSubview:label];
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
    cell.backgroundView = imageView;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ClothPhoto *photo = self.dataArr[indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor];
    [self.deleArr addObject:photo];
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    ClothPhoto *photo = self.dataArr[indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
    [self.deleArr removeObject:photo];
}
-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


@end
