//
//  SeeGoodsController.m
//  好品
//
//  Created by 朱明科 on 15/12/11.
//  Copyright © 2015年 zhumingke. All rights reserved.
//xaiwu

#import "SeeGoodsController.h"
#import "DataBase.h"
#import "AddClothController.h"
#import "HeadCollectionView.h"//头视图
#import "DetailController.h"//详情
#import "SiftController.h"

#define kItemW   (self.view.frame.size.width-60)/5.0
@interface SeeGoodsController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate>
@property(nonatomic)NSMutableArray *dataArray;//数据源
@property(nonatomic)NSMutableArray *headName;
@property(nonatomic)UICollectionView *collectionView;
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)NSMutableArray *sectionsArray;//返回的分区
@property(nonatomic,copy)NSString *returnYaerStr;//返回的年份
@property(nonatomic)NSInteger nums;
@property(nonatomic,copy)NSString *chooeseType;
@property (nonatomic) BOOL zoom;//缩放
@property (nonatomic) NSMutableArray *numberArray;//用于计算cell的宽度
@end

@implementation SeeGoodsController
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(NSMutableArray *)headName{
    if (_headName == nil) {
        _headName = [[NSMutableArray alloc]init];
    }
    return _headName;
}
-(NSMutableArray *)sectionsArray{
    if (_sectionsArray == nil) {
        _sectionsArray = [[NSMutableArray alloc]init];
    }
    return _sectionsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self initializePageSubviews];
}
- (void)initializePageSubviews {
    self.navigationController.navigationBar.translucent = NO;
    
    self.zoom = YES;
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addBtn.frame = CGRectMake(0, 0, 45, 44);
    [addBtn setImage:[[UIImage imageNamed:@"add-to"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    //管理按钮
//    UIButton *GLBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    GLBtn.frame = CGRectMake(0, 0, 40, 40);
//    [GLBtn addTarget:self action:@selector(GLClick) forControlEvents:UIControlEventTouchUpInside];
//    [GLBtn setTitle:@"管理" forState:UIControlStateNormal];
//    [GLBtn setTitleColor:[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0] forState:UIControlStateNormal];
//    [GLBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
//    UIBarButtonItem *GLItem = [[UIBarButtonItem alloc]initWithCustomView:GLBtn];
    //筛选
    UIButton *choesBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    choesBtn.frame = CGRectMake(0, 0, 45, 44);
    choesBtn.tintColor = [UIColor clearColor];
    [choesBtn setImage:[[UIImage imageNamed:@"sort"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [choesBtn addTarget:self action:@selector(ChoseClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *choseItem = [[UIBarButtonItem alloc]initWithCustomView:choesBtn];
    
    //self.navigationItem.rightBarButtonItems = @[GLItem,addItem,choseItem];
    self.navigationItem.rightBarButtonItems = @[addItem,choseItem];
    
    //缩放按钮
    UIButton *zoomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    zoomBtn.frame = CGRectMake(0, 0, 70, 40);
    zoomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    zoomBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [zoomBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [zoomBtn setTitle:@"看大图" forState:UIControlStateNormal];
    zoomBtn.tintColor = [UIColor clearColor];
    [zoomBtn setTitle:@"看整体" forState:UIControlStateSelected];
    [zoomBtn setTitleColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0] forState:UIControlStateNormal];
    
    [zoomBtn setTitleColor:[UIColor colorWithRed:108.0/255 green:108.0/255 blue:108.0/255 alpha:1.0] forState:UIControlStateSelected];
    [zoomBtn addTarget:self action:@selector(zoom:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *zoomItem = [[UIBarButtonItem alloc]initWithCustomView:zoomBtn];
    self.navigationItem.leftBarButtonItem = zoomItem;
    [self createData];
    [self suofang];
}

#pragma mark - 缩放的点击事件
- (void)zoom:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.zoom = NO;
        [self.collectionView removeFromSuperview];
        [self createUI];
    } else {
        self.zoom = YES;
        [self.collectionView removeFromSuperview];
        [self suofang];
    }
    [self.collectionView reloadData];
}

-(void)createData{
    self.nums = 0;
    self.dataArray = nil;
    self.headName = nil;
    self.sectionsArray = nil;
    //获取当前年份
    self.returnYaerStr = [_userDeft objectForKey:@"selectSTR"];
    //获取当前年份的品类
    NSString *typeStr = [NSString stringWithFormat:@"%@type",self.returnYaerStr];
    NSMutableArray *typeOfArray = [NSMutableArray arrayWithArray:[_userDeft objectForKey:typeStr]];
    if ([self.chooeseType isEqualToString:@"品类"]) {
        self.headName = typeOfArray;
        for (NSInteger m = 0; m < typeOfArray.count; m ++) {
            NSMutableArray *arr = [[DataBase shareInstance]fetchBySession:self.returnYaerStr andType:typeOfArray[m]];
            [self.sectionsArray addObject:arr];
            ++_nums;
        }
    }else if ([self.chooeseType isEqualToString:@"设计师"] ){
        NSString *strDesignor = [NSString stringWithFormat:@"%@design",self.returnYaerStr];
        NSMutableArray *designArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:strDesignor]];
        self.headName = designArr;
        for (NSInteger i = 0; i < designArr.count; i ++) {
            NSMutableArray *arr = [[DataBase shareInstance]fetchBySession:self.returnYaerStr andDesignor:designArr[i]];
            [self.sectionsArray addObject:arr];
            ++_nums;
        }
    }else{
        //self.dataArray = [[DataBase shareInstance]fetchBySession:self.returnYaerStr];
        self.headName = typeOfArray;
        for (NSInteger m = 0; m < typeOfArray.count; m ++) {
            NSMutableArray *arr = [[DataBase shareInstance]fetchBySession:self.returnYaerStr andType:typeOfArray[m]];
            [self.sectionsArray addObject:arr];
            ++_nums;
        }
    }
    [self.collectionView reloadData];
    //判断是不是筛选的 同类型的产品放在一起
//    if ([self.chooeseType isEqualToString:@"品类"]) {
//        self.dataArray = nil;
//        /**
//        self.nums = 0;
//        for (NSInteger m = 0; m < _sectionsArray.count; m ++) {
//            NSMutableArray *arr1 = [[NSMutableArray alloc]init];
//            for (NSInteger n = 0; n < typeArr.count; n ++) {
//                NSMutableArray *arr2 = [[DataBase shareInstance]fetchBySession:self.returnYaerStr andBod:self.sectionsArray[m] andType:typeArr[n]];
//                if (arr2.count != 0) {
//                    [arr1 addObjectsFromArray:arr2];
//                }
//            }
//            if (arr1.count != 0) {
//                self.nums += 1;
//                [self.dataArray addObject:arr1];
//                [self.headName addObject:_sectionsArray[m]];
//            }
//            
//        }
//          */
//        for (NSInteger m = 0; m < typeArr.count; m ++) {
//            NSMutableArray *arr = [[DataBase shareInstance]fetchBySession:self.returnYaerStr andType:typeArr[m]];
//            [self.dataArray addObjectsFromArray:arr];
//        }
//    }else if ([self.chooeseType isEqualToString:@"色系"]){
//        NSArray *colorArr = [[DataBase shareInstance]allColorBySession:self.returnYaerStr];
//        self.dataArray = nil;
//        /**
//         self.nums = 0;
//        for (NSInteger m = 0; m < _sectionsArray.count; m ++) {
//            NSMutableArray *arr1 = [[NSMutableArray alloc]init];
//            for (NSInteger n = 0; n < colorArr.count; n ++) {
//                NSMutableArray *arr2 = [[DataBase shareInstance]fetchBySession:self.returnYaerStr andBod:self.sectionsArray[m] andColor:colorArr[n]];
//                if (arr2.count != 0) {
//                    [arr1 addObjectsFromArray:arr2];
//                }
//            }
//            if (arr1.count != 0) {
//                self.nums += 1;
//                [self.dataArray addObject:arr1];
//                [self.headName addObject:_sectionsArray[m]];
//            }
//        }
//         */
//        for (NSInteger n = 0; n < colorArr.count; n ++) {
//            NSMutableArray *arr = [[DataBase shareInstance]fetchBySession:self.returnYaerStr andColor:colorArr[n]];
//            [self.dataArray addObjectsFromArray:arr];
//        }
//    }else if ([self.chooeseType isEqualToString:@"设计师"] ){
//        self.dataArray = nil;
//        NSString *strDesignor = [NSString stringWithFormat:@"%@design",self.returnYaerStr];
//        NSMutableArray *designArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:strDesignor]];
//        for (NSInteger i = 0; i < designArr.count; i ++) {
//            NSMutableArray *arr = [[DataBase shareInstance]fetchBySession:self.returnYaerStr andDesignor:designArr[i]];
//            [self.dataArray addObjectsFromArray:arr];
//        }
//    }else{
//        self.dataArray = nil;
//        /**
//        self.nums = 0;
//        //记录每个分区的数据  数据库
//        for (NSInteger i = 0; i < _sectionsArray.count; i ++) {
//           // NSMutableArray *arr = [[DataBase shareInstance]fetchBySession:self.returnYaerStr bods:self.sectionsArray[i]];
//            if (arr.count != 0) {
//                self.nums += 1;
//                [self.dataArray addObject:arr];
//                [self.headName addObject:_sectionsArray[i]];
//            }
//        }
//         */
//        self.dataArray = [[DataBase shareInstance]fetchBySession:self.returnYaerStr];
//    }
    
}
//根据设置里的波段数量显示collection的section数量
-(void)createUI{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(kItemW, 240);
    layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-110) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册cell
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    //注册headview头视图
        [_collectionView registerClass:[HeadCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"headerID"];
    [self.view addSubview:_collectionView];
}
- (void)suofang {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(68, 68);
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumLineSpacing = 10;
    layOut.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-110) collectionViewLayout:layOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册cell
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    //注册headview头视图
        [_collectionView registerClass:[HeadCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"headerID"];
    [self.view addSubview:_collectionView];
}
#pragma mark - collect dele
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    if (self.chooeseType) {
//        return _nums;
//    }else{
//        return 1;
//    }
    return _nums;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.sectionsArray[section];
    return arr.count;
//    if (self.chooeseType) {
//        NSArray *arr = _sectionsArray[section];
//        return arr.count;
//    }else{
//        return self.dataArray.count;
//    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.zoom == NO) {
//            NSString *cellID = [NSString stringWithFormat:@"cellID%ld",(long)(indexPath.section*100+indexPath.row)];
//            [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
            ClothPhoto *photo = [[ClothPhoto alloc]init];
            photo = self.sectionsArray[indexPath.section][indexPath.row];
//            NSInteger count = self.dataArray.count;
//            if (self.chooeseType) {
//                photo = self.sectionsArray[indexPath.section][indexPath.row];
//            }else{
//                photo = self.dataArray[count-1 - indexPath.row];
//            }
            //ClothPhoto *photo = self.dataArray[count-1 - indexPath.row];
            //ClothPhoto *photo = self.dataArray[indexPath.section][indexPath.row];
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kItemW, 204)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = photo.image;//只显示正面图
//            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 214, (kItemWidth-10)/2, 30)];
//            label1.textAlignment = NSTextAlignmentLeft;
//            label1.text = [NSString stringWithFormat:@"%@%@",photo.type,photo.color];
//            label1.backgroundColor = [UIColor whiteColor];
//            label1.numberOfLines = 0;
//            [imageView addSubview:label1];
//            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake((kItemWidth-10)/2+4, 214, (kItemWidth-10)/2, 30)];
//            label2.textAlignment = NSTextAlignmentRight;
//            if (photo.designor != nil) {
//                label2.text = [NSString stringWithFormat:@"%@",photo.designor];
//            }
//            label2.backgroundColor = [UIColor whiteColor];
//            label2.numberOfLines = 0;
//            [imageView addSubview:label2];
//            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(5, 243, kItemWidth-5, 30)];
//            label3.textAlignment = NSTextAlignmentLeft;
//            if (photo.price == nil) {
//                label3.text = [NSString stringWithFormat:@"￥--"];
//            }else{
//                label3.text = [NSString stringWithFormat:@"￥%@",photo.price];
//            }
//            label3.textColor = [UIColor redColor];
//            label3.backgroundColor = [UIColor whiteColor];
//            label3.numberOfLines = 0;
//            [imageView addSubview:label3];
            imageView.layer.borderWidth = 1.0;
            imageView.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
//            UIImageView *boolImage = [[UIImageView alloc]initWithFrame:CGRectMake(kItemWidth-60, 0, 60, 60)];
//            boolImage.image = [UIImage imageNamed:@"budayang"];
//            if ([photo.pinkuan isEqualToString:@"不上货"]) {
//                [imageView addSubview:boolImage];
//            }
            cell.backgroundView = imageView;
            return cell;
    } else {
//        NSString *cellID = [NSString stringWithFormat:@"cellID%ld",(long)(indexPath.section*100+indexPath.row)];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
        ClothPhoto *photo = [[ClothPhoto alloc]init];
        photo = self.sectionsArray[indexPath.section][indexPath.row];
//        NSInteger count = self.dataArray.count;
//        if (self.chooeseType) {
//            photo = self.sectionsArray[indexPath.section][indexPath.row];
//        }else{
//            photo = self.dataArray[count-1 - indexPath.row];
//        }
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kItemW/2, 88)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        //imageView.backgroundColor = [UIColor redColor];
        imageView.image = photo.image;
        //        imageView.layer.borderWidth = 1.0;
        //        imageView.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
        cell.backgroundView = imageView;
        return cell;
    }
}
//点击
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //NSMutableArray *tmpArr = self.dataArray[indexPath.row];
    ClothPhoto *photo = [[ClothPhoto alloc]init];
    photo = self.sectionsArray[indexPath.section][indexPath.row];
//    NSInteger count = self.dataArray.count;
//    if (self.chooeseType) {
//        photo = self.sectionsArray[indexPath.section][indexPath.row];
//    }else{
//        photo = self.dataArray[count-1 - indexPath.row];
//    }
    
    DetailController *detalController = [[DetailController alloc] init];
    detalController.cloth = photo;
    detalController.hidesBottomBarWhenPushed = YES;
    //block刷新
    [detalController setRefreshHandler:^{
        [self createData];
    }];
    [self.navigationController pushViewController:detalController animated:YES];
}
//头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    NSString *headID = [NSString stringWithFormat:@"headID%ld",(long)indexPath.section];
//    [_collectionView registerClass:[HeadCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headID];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HeadCollectionView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerID" forIndexPath:indexPath];
        headView.backgroundColor = [UIColor whiteColor];
        headView.aboutStr = [NSString stringWithFormat:@"   %@",_headName[indexPath.section]];
        return headView;
    }
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSArray *array = self.sectionsArray[section];
    if (array.count) {
        return CGSizeMake(0, 30);
    }
    return CGSizeZero;
}
//添加按钮
-(void)click{
    AddClothController *addClothController = [[AddClothController alloc]init];
    [addClothController setHandler:^(NSString *refresh) {
        
        if ([refresh isEqualToString:@"YES"]) {
           [self createData];
        }
    }];
    [self presentViewController:addClothController animated:YES completion:nil];
}
//筛选按钮
//
-(void)ChoseClick:(UIButton *)button{
    SiftController *siftController = [[SiftController alloc]init];
    [siftController setDidSelectedHandler:^(NSString *string) {
        if ([string isEqualToString:@"品类"]) {
            self.chooeseType = @"品类";
            [self createData];
        }else{
            self.chooeseType = @"设计师";
            [self createData];
        }
    }];
    siftController.modalPresentationStyle = UIModalPresentationPopover;
    siftController.preferredContentSize = CGSizeMake(230, 50);
    UIPopoverPresentationController *popController = siftController.popoverPresentationController;
    popController.sourceView = button;
    popController.sourceRect = button.bounds;
    popController.delegate = self;
    popController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    [self presentViewController:siftController animated:NO completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
//    self.dataArray = nil;
//    self.sectionsArray = nil;
//    self.headName = nil;
    /**
    //获取通知中心单例对象
    [self createData];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"refresh" object:nil];
    self.navigationController.navigationBar.translucent = NO;
    */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fresh) name:@"typeRefresh" object:nil];
}
-(void)fresh{
    [self createData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/**
- (void)notice:(NSNotificationCenter *)center {
    [self createData];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
 */
@end
