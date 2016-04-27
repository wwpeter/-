//
//  RemarkController.m
//  好品
//
//  Created by 朱明科 on 16/2/25.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "RemarkController.h"
#import "DiyCollectionCell.h"

#define kWidth self.view.frame.size.width-600
#define kHeight self.view.frame.size.height
@interface RemarkController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UITextField *priceText;
@property(nonatomic)UICollectionView *pingCollection;
@property(nonatomic)UICollectionView *yangCollection;
@property(nonatomic)UICollectionView *typeCollection;
@property(nonatomic)NSArray *pingDataArr;
@property(nonatomic)NSArray *yangDataArr;
@property(nonatomic)NSMutableArray *typeDataArr;
@property(nonatomic,copy)NSString *pingString;
@property(nonatomic,copy)NSString *yangString;
@property(nonatomic,copy)NSString *typeString;
@property(nonatomic)BOOL firstChoose;
@property(nonatomic)BOOL firstChoose1;
@property(nonatomic)BOOL firstChoose2;
@end

@implementation RemarkController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:247.0/255 alpha:1.0];
    self.typeString = self.tmpCloth.type;
    [self initData];
    [self createUI];
}
-(void)initData{
    NSString *typeStr = [NSString stringWithFormat:@"%@type",[_userDeft objectForKey:@"selectSTR"]];
    self.typeDataArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:typeStr]];
    self.pingDataArr = [NSArray arrayWithObjects:@"上货",@"不上货", nil];
    self.yangDataArr = [NSArray arrayWithObjects:@"打样",@"不打样", nil];
}
-(void)createUI{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(1,1, 80, 50);
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1.0]];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(kWidth-81, 1, 80, 50);
    [doneBtn setTitle:@"保存" forState:UIControlStateNormal];
    [doneBtn setTintColor:[UIColor colorWithRed:49.0/255 green:216.0/255 blue:92.0/255 alpha:1.0]];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [doneBtn setBackgroundColor:[UIColor whiteColor]];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 1, kWidth-160, 50)];
    headLabel.backgroundColor = [UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.text = @"编辑";
    headLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0];
    headLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:headLabel];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kWidth, 36)];
    priceLabel.text = @"价格";
    priceLabel.font = [UIFont systemFontOfSize:16];
    priceLabel.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    [self.view addSubview:priceLabel];
    
    self.priceText = [[UITextField alloc]initWithFrame:CGRectMake(1, 86, kWidth-2, 50)];
    _priceText.delegate = self;
    _priceText.borderStyle = UITextBorderStyleNone;
    _priceText.backgroundColor = [UIColor whiteColor];
    _priceText.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    _priceText.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.priceText];
    
    UILabel *kuanLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 136, kWidth, 36)];
    kuanLable.text = @"评款";
    kuanLable.font = [UIFont systemFontOfSize:16];
    kuanLable.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    [self.view addSubview:kuanLable];
    
    UILabel *yangLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 222, kWidth, 36)];
    yangLable.text = @"样品";
    yangLable.font = [UIFont systemFontOfSize:16];
    yangLable.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    [self.view addSubview:yangLable];
    
    UILabel *typeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 308, kWidth, 36)];
    typeLable.text = @"品类";
    typeLable.font = [UIFont systemFontOfSize:16];
    typeLable.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0];
    [self.view addSubview:typeLable];
    
    [self initCollectionView];
}
-(void)initCollectionView{
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc]init];
    layout1.itemSize = CGSizeMake(200, 50);
    layout1.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layout1.minimumInteritemSpacing = 0;
    layout1.minimumLineSpacing = 0;
    
    self.pingCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(1, 172, kWidth-2, 50) collectionViewLayout:layout1];
    _pingCollection.backgroundColor = [UIColor whiteColor];
    _pingCollection.delegate = self;
    _pingCollection.dataSource = self;
    [_pingCollection registerClass:[DiyCollectionCell class] forCellWithReuseIdentifier:@"cellID1"];
    [self.view addSubview:_pingCollection];
    
    
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc]init];
    layout2.itemSize = CGSizeMake(200, 50);
    layout2.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layout2.minimumInteritemSpacing = 0;
    layout2.minimumLineSpacing = 0;
    
    self.yangCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(1, 258, kWidth-2, 50) collectionViewLayout:layout2];
    _yangCollection.backgroundColor = [UIColor whiteColor];
    _yangCollection.delegate = self;
    _yangCollection.dataSource = self;
    [_yangCollection registerClass:[DiyCollectionCell class] forCellWithReuseIdentifier:@"cellID2"];
    [self.view addSubview:_yangCollection];
    
    UICollectionViewFlowLayout *layout3 = [[UICollectionViewFlowLayout alloc]init];
    layout3.itemSize = CGSizeMake(100, 50);
    layout3.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layout3.minimumInteritemSpacing = 0;
    layout3.minimumLineSpacing = 0;
    
    self.typeCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(1, 344, kWidth-2, 190) collectionViewLayout:layout3];
    _typeCollection.backgroundColor = [UIColor whiteColor];
    _typeCollection.delegate = self;
    _typeCollection.dataSource = self;
    [_typeCollection registerClass:[DiyCollectionCell class] forCellWithReuseIdentifier:@"cellID3"];
    [self.view addSubview:_typeCollection];
}
-(void)cancel:(UIButton *)button{
    [self.view removeFromSuperview];
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
    self.priceText.text = nil;
    self.typeString = nil;
    self.pingString = nil;
    self.yangString = nil;
}
-(void)done:(UIButton *)button{
    [[DataBase shareInstance]update:[self currentCloth]];
    [self.view removeFromSuperview];
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
    self.priceText.text = nil;
    self.typeString = nil;
    self.pingString = nil;
    self.yangString = nil;
    if (self.detailHandler) {
        self.detailHandler();
    }
}
-(ClothPhoto *)currentCloth{
    ClothPhoto *cloth = [[ClothPhoto alloc]init];
    cloth.ind = self.tmpCloth.ind;
    cloth.year = self.tmpCloth.year;
    cloth.type = self.typeString;
    cloth.bod = self.tmpCloth.bod;
    cloth.color = self.yangString;
    cloth.image = self.tmpCloth.image;
    cloth.backImage = self.tmpCloth.backImage;
    cloth.designor = self.tmpCloth.designor;
    cloth.price = self.priceText.text;
    cloth.pinkuan = self.pingString;
    return cloth;
}
#pragma mark - textField
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.priceText.text = textField.text;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.priceText resignFirstResponder];
}
#pragma mark - collectionview 的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.pingCollection || collectionView == self.yangCollection) {
        return 2;
    }else{
        return self.typeDataArr.count;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.pingCollection) {
        DiyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID1" forIndexPath:indexPath];
        cell.textLabel.text = self.pingDataArr[indexPath.row];
        return cell;
    }else if (collectionView == self.yangCollection){
        DiyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID2" forIndexPath:indexPath];
        cell.textLabel.text = self.yangDataArr[indexPath.row];
        return cell;
    }else if (collectionView == self.typeCollection){
        DiyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID3" forIndexPath:indexPath];
        cell.bjLabel.frame = CGRectMake(10, 20, 10, 10);
        cell.textLabel.frame = CGRectMake(30, 5, 70, 40);
        cell.textLabel.text = self.typeDataArr[indexPath.row];
        return cell;
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DiyCollectionCell *cell = (DiyCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bjLabel.backgroundColor = [UIColor greenColor];
    if (collectionView == self.pingCollection) {
        if (self.firstChoose1 == YES) {
            NSInteger m;
            for (NSInteger i = 0; i < self.pingDataArr.count; i ++) {
                if ([self.pingString isEqualToString:self.pingDataArr[i]]) {
                    m = i;
                    break;
                }
            }
            NSIndexPath *selectIndex2 = [NSIndexPath indexPathForRow:m inSection:0];
            DiyCollectionCell *cell2 = (DiyCollectionCell *)[self.pingCollection cellForItemAtIndexPath:selectIndex2];
            cell2.bjLabel.backgroundColor = [UIColor clearColor];
            self.firstChoose1 = NO;
        }
        self.pingString = cell.textLabel.text;
    }else if(collectionView == self.yangCollection){
        if (self.firstChoose2 == YES) {
            NSInteger m;
            for (NSInteger i = 0; i < self.yangDataArr.count; i ++) {
                if ([self.yangString isEqualToString:self.yangDataArr[i]]) {
                    m = i;
                    break;
                }
            }
            NSIndexPath *selectIndex3 = [NSIndexPath indexPathForRow:m inSection:0];
            DiyCollectionCell *cell3 = (DiyCollectionCell *)[self.yangCollection cellForItemAtIndexPath:selectIndex3];
            cell3.bjLabel.backgroundColor = [UIColor clearColor];
            self.firstChoose2 = NO;
        }
        self.yangString = cell.textLabel.text;
    }else if(collectionView == self.typeCollection){
        if (self.firstChoose == YES) {
            NSInteger m;
            for (NSInteger i = 0; i < self.typeDataArr.count; i ++) {
                if ([self.typeString isEqualToString:self.typeDataArr[i]]) {
                    m = i;
                    break;
                }
            }
            NSIndexPath *selectIndex = [NSIndexPath indexPathForRow:m inSection:0];
            DiyCollectionCell *cell = (DiyCollectionCell *)[self.typeCollection cellForItemAtIndexPath:selectIndex];
            cell.bjLabel.backgroundColor = [UIColor clearColor];
            
            self.firstChoose = NO;
        }
        self.typeString = cell.textLabel.text;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    DiyCollectionCell *cell = (DiyCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.bjLabel.backgroundColor = [UIColor clearColor];
}
-(void)viewDidAppear:(BOOL)animated{
    if (_tmpCloth.price) {
        _priceText.text = _tmpCloth.price;
    }else{
        _priceText.placeholder = @"  填写价格";
    }
    NSInteger m;
    self.typeString = self.tmpCloth.type;
    self.pingString = self.tmpCloth.pinkuan;
    self.yangString = self.tmpCloth.color;
    for (NSInteger i = 0; i < self.typeDataArr.count; i ++) {
        if ([self.typeString isEqualToString:self.typeDataArr[i]]) {
            m = i;
            self.firstChoose = YES;
            break;
        }
    }
    NSIndexPath *selectIndex = [NSIndexPath indexPathForRow:m inSection:0];
    DiyCollectionCell *cell = (DiyCollectionCell *)[self.typeCollection cellForItemAtIndexPath:selectIndex];
    cell.bjLabel.backgroundColor = [UIColor greenColor];
    //评款
    if (!(_tmpCloth.pinkuan == nil)) {
        NSLog(@"%@",_tmpCloth.pinkuan);
        for (NSInteger i = 0; i < self.pingDataArr.count; i ++) {
            if ([self.pingString isEqualToString:self.pingDataArr[i]]) {
                m = i;
                self.firstChoose1 = YES;
                break;
            }
        }
        NSIndexPath *selectIndex2 = [NSIndexPath indexPathForRow:m inSection:0];
        DiyCollectionCell *cell2 = (DiyCollectionCell *)[self.pingCollection cellForItemAtIndexPath:selectIndex2];
        cell2.bjLabel.backgroundColor = [UIColor greenColor];
    }
    //打样
    if (_tmpCloth.color) {
        for (NSInteger i = 0; i < self.yangDataArr.count; i ++) {
            if ([self.yangString isEqualToString:self.yangDataArr[i]]) {
                m = i;
                self.firstChoose2 = YES;
                break;
            }
        }
        NSIndexPath *selectIndex3 = [NSIndexPath indexPathForRow:m inSection:0];
        DiyCollectionCell *cell3 = (DiyCollectionCell *)[self.yangCollection cellForItemAtIndexPath:selectIndex3];
        cell3.bjLabel.backgroundColor = [UIColor greenColor];
    }
}
@end
