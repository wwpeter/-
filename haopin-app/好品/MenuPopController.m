//
//  MenuPopController.m
//  haopin
//
//  Created by 朱明科 on 16/3/29.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "MenuPopController.h"

@interface MenuPopController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@end

@implementation MenuPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}
-(void)initUI{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(50, 30);
    layOut.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layOut.minimumLineSpacing = 5;
    layOut.minimumInteritemSpacing = 5;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, 170, 40) collectionViewLayout:layOut];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:collectionView];
}
#pragma mark - uicollectionview delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [[UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1.0]CGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.textColor = [UIColor colorWithRed:102.0/255 green:96.0/255 blue:0 alpha:1.0];
    label.text = self.dataArray[indexPath.row];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    cell.backgroundView = label;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.dataArray[indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.tintColor = [UIColor colorWithRed:62.0/255 green:202.0/255 blue:72.0/255 alpha:1.0];
    if (self.selectHandler) {
        self.selectHandler(str);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
