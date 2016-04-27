//
//  SeeCombinationController.m
//  好品
//
//  Created by 朱明科 on 15/12/9.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "SeeCombinationController.h"
#import "CombinCell.h"
#import "AddCombinController.h"//添加页面
#import "DBManager.h"
#import "CombinDetailController.h"


#define kItemWidth   ([UIScreen mainScreen].bounds.size.width-50)/4
#define kItemHeightt 280
@interface SeeCombinationController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UICollectionView *collectionView;
@property(nonatomic)NSMutableArray *dataArray;
@end

@implementation SeeCombinationController
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
-(void)createData{
    self.dataArray = [[DBManager sharedInstance]fetchByYear:[_userDeft objectForKey:@"selectSTR"]];
    [self.collectionView reloadData];
}
-(void)addButton{
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(0, 0, 45, 44);
    //[addBtn setBackgroundImage:[UIImage imageNamed:@"add-to"] forState:UIControlStateNormal];
    [addBtn setImage:[[UIImage imageNamed:@"add-to"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(combinAddClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    //管理按钮
    UIButton *GLBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    GLBtn.frame = CGRectMake(0, 0, 40, 40);
    
    [GLBtn addTarget:self action:@selector(combinGLClick) forControlEvents:UIControlEventTouchUpInside];
    [GLBtn setTitle:@"管理" forState:UIControlStateNormal];
    [GLBtn setTitleColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0] forState:UIControlStateNormal];
    [GLBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    //UIBarButtonItem *GLItem = [[UIBarButtonItem alloc]initWithCustomView:GLBtn];
    
    //self.navigationItem.rightBarButtonItems = @[GLItem,addItem];
    self.navigationItem.rightBarButtonItem = addItem;
}
-(void)addCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kItemWidth, kItemHeightt);
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    //注册
    [_collectionView registerNib:[UINib nibWithNibName:@"CombinCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
}
//添加
-(void)combinAddClick{
    AddCombinController *addCombinController = [[AddCombinController alloc]init];
    [self presentViewController:addCombinController animated:YES completion:nil];
}
//管理
//-(void)combinGLClick{
//    DeleCombinController *delCombinController = [[DeleCombinController alloc]init];
//    [self presentViewController:delCombinController animated:YES completion:nil];
//}
#pragma mark - collection data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CombinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    NSInteger count = self.dataArray.count;
    Combin *combin = self.dataArray[count-1 - indexPath.row];
    cell.rootImageView.image = combin.combinImage;
    cell.timeLabel.text = combin.combinTime;
    cell.timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    cell.namelabel.text = combin.combinName;
    cell.namelabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger count = self.dataArray.count;
    Combin *combin = self.dataArray[count-1 - indexPath.row];
    CombinDetailController *detailController = [[CombinDetailController alloc]init];
    detailController.combin = combin;
    [self presentViewController:detailController animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self createData];
}
@end
