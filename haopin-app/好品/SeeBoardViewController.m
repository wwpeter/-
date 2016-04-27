//
//  SeeBoardViewController.m
//  好品
//
//  Created by 朱明科 on 15/12/9.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "SeeBoardViewController.h"
#import "DataManager.h"
#import "BondCell.h"
#import "Bond.h"
#import "AddBondController.h"
#import "BondDetailController.h"


#define kItemWidth   ([UIScreen mainScreen].bounds.size.width-50)/4
#define kItemsHeight 280
@interface SeeBoardViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UICollectionView *collectionView;
@property(nonatomic)NSMutableArray *dataArray;

@end

@implementation SeeBoardViewController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self addButton];
    [self addCollection];
    [self createData];
}
-(void)addButton{
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(0, 0, 45, 44);
    //[addBtn setBackgroundImage:[UIImage imageNamed:@"add-to"] forState:UIControlStateNormal];
    [addBtn setImage:[[UIImage imageNamed:@"add-to"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(bondAddClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    //管理按钮
    UIButton *GLBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    GLBtn.frame = CGRectMake(0, 0, 40, 40);
    [GLBtn addTarget:self action:@selector(bondGLClick) forControlEvents:UIControlEventTouchUpInside];
    [GLBtn setTitle:@"管理" forState:UIControlStateNormal];
    [GLBtn setTitleColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0] forState:UIControlStateNormal];
    [GLBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    //UIBarButtonItem *GLItem = [[UIBarButtonItem alloc]initWithCustomView:GLBtn];
    
    //self.navigationItem.rightBarButtonItems = @[GLItem,addItem];
    self.navigationItem.rightBarButtonItem = addItem;
}
-(void)addCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kItemWidth, kItemsHeight);
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    //注册
    [_collectionView registerNib:[UINib nibWithNibName:@"BondCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
}
-(void)createData{
    self.dataArray = [[DataManager sharedInstance]fetchByYear:[_userDeft objectForKey:@"selectSTR"]];
    [self.collectionView reloadData];
}
//添加
-(void)bondAddClick{
    AddBondController *addBondController = [[AddBondController alloc]init];
    [self presentViewController:addBondController animated:YES completion:nil];
}
//管理
//-(void)bondGLClick{
//    DeleBondController *deleController = [[DeleBondController alloc]init];
//    [self presentViewController:deleController animated:YES completion:nil];
//}
#pragma mark - collectionview data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    NSInteger count = self.dataArray.count;
    Bond *bond = self.dataArray[count-1 - indexPath.row];
    cell.rootImageView.image = bond.bondImage;
    cell.nameLabel.text = bond.bondName;
    cell.nameLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    cell.timeLabel.text = bond.bondTime;
    cell.timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    return cell;
}
//点击某个cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = self.dataArray.count;
    Bond *bond = self.dataArray[count-1 - indexPath.row];
    BondDetailController *bondDetailController = [[BondDetailController alloc]init];
    bondDetailController.bond = bond;
    [self presentViewController:bondDetailController animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self createData];
}
@end
