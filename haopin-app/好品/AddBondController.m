//
//  AddBondController.m
//  好品
//
//  Created by 朱明科 on 15/12/28.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "AddBondController.h"
#import "DataBase.h"
#import "DataManager.h"
#import "Bond.h"
#import "ClothPhoto.h"
#import <QuartzCore/QuartzCore.h>
#import "ContentController.h"
#import "BGContentController.h"
#import "PhotoTweaksViewController.h"
#import "BQDetailDB.h"
#import "MenuPopController.h"
#import "ColorController.h"
#import "ImageTools.h"
#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
#define kBordColor [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor]

@interface AddBondController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoTweaksViewControllerDelegate>

@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UIView *rootsView;
@property(nonatomic)UIImageView *bgImageView;
@property(nonatomic)UITableView *tableMenuView;
@property(nonatomic)UICollectionView *collectionMenuView;
@property(nonatomic)CGRect viewFrame;
@property(nonatomic)NSMutableArray *dataArray;
@property(nonatomic)NSMutableArray *detailArray;
@property(nonatomic,copy)NSString *didSelectType;//选中的品类
@property(nonatomic)UIImageView *sampImageView;//单个衣服
@property(nonatomic,copy)NSString *selectViewTag;//点击选中的视图，用来删除的
@property(nonatomic)UIImageView *changeView;
@property(nonatomic,copy)NSString *nameString;//组合的名字
@property(nonatomic,copy)NSString *bodString;//选择的波段
@property(nonatomic)NSInteger currentTag;//当前的tag,正反按钮使用
@property(nonatomic)UIView *goBackView;
@property(nonatomic)UIView *detailHeadView;
@property(nonatomic)UILabel *detailMidLable;
@property(nonatomic)NSMutableArray *tmpArr;
@end

@implementation AddBondController
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.edit == NO) {
        self.currentBqDetail = [self currentTimer];
    }
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self createType];
    [self addRootsView];
    [self addMenu];
    [self addTableMenuView];
}
-(void)addMenu{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 69)];
    titleView.backgroundColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0];
    titleView.userInteractionEnabled = YES;
    [self.view addSubview:titleView];
    //标题
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kWidth-200)/2.0, 30, 200, 30)];
    label.text = @"编辑板墙";
    label.font = [UIFont systemFontOfSize:25];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:label];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(10, 30, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return01"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(bondBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
    
    //保存按钮
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(55, 30, 25, 25);
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"storage01"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(bondDoneClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:doneBtn];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteBtn.frame = CGRectMake(100, 30, 25, 25);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(bondDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    //[titleView addSubview:deleteBtn];
    
    //菜单
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    menuBtn.frame = CGRectMake(kWidth-45, 30, 25, 25);
    menuBtn.tintColor = [UIColor clearColor];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"classification"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(bondMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:menuBtn];
    
    //背景
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bgBtn.frame = CGRectMake(kWidth-90, 30, 25, 25);
    [bgBtn setBackgroundImage:[UIImage imageNamed:@"background"] forState:UIControlStateNormal];
    [bgBtn addTarget:self action:@selector(bondBgClick:) forControlEvents:UIControlEventTouchUpInside];
    bgBtn.tintColor = [UIColor clearColor];
    [titleView addSubview:bgBtn];
}

//根View
-(void)addRootsView{
    self.rootsView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kWidth, kHeight)];
    _rootsView.backgroundColor = [UIColor whiteColor];
    _rootsView.userInteractionEnabled = YES;
    
    [self.view addSubview:_rootsView];
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _bgImageView.userInteractionEnabled = YES;
    if (self.edit == YES) {
        NSMutableArray *mArr = [[BQDetailDB sharedInstance]fetchByVVID:self.currentBqDetail];
        self.tmpArr = mArr;
        for (NSInteger i = 0; i < mArr.count; i ++) {
            BQDetailModel *model = mArr[i];
            UIImageView *currentView = [[UIImageView alloc]initWithFrame:CGRectMake(model.orignX, model.orignY, model.frameWidth, model.frameHeight)];
            currentView.contentMode = UIViewContentModeScaleAspectFit;
            currentView.backgroundColor = [UIColor clearColor];
            currentView.userInteractionEnabled = YES;
            currentView.image = model.image;
            currentView.UUTag = model.detailTag;
            [self addGesture:currentView];
            [_bgImageView addSubview:currentView];
            _bgImageView.image = model.bgImage;
        }
    }
    [self.rootsView addSubview:_bgImageView];
}
//添加菜单栏
-(void)addTableMenuView{
    self.goBackView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-200, 0, 200, 69)];
    _goBackView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    _goBackView.hidden = YES;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(10, 30, 50, 30);
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor colorWithRed:253.0/255 green:137.0/255 blue:24.0/255 alpha:1.0] forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [back addTarget:self action:@selector(gogo) forControlEvents:UIControlEventTouchUpInside];
    [_goBackView addSubview:back];
    [self.view addSubview:_goBackView];
    
    self.viewFrame = CGRectMake(kWidth-200, 69, 200, kHeight-75);
    self.tableMenuView = [[UITableView alloc]initWithFrame:_viewFrame style:UITableViewStylePlain];
    _tableMenuView.hidden = YES;
    _tableMenuView.delegate = self;
    _tableMenuView.dataSource = self;
    _tableMenuView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    _tableMenuView.separatorColor = [UIColor lightGrayColor];
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor clearColor];
    _tableMenuView.tableFooterView = footView;
    [self.view addSubview:_tableMenuView];
}
-(void)gogo{
    self.goBackView.hidden = YES;
    self.tableMenuView.hidden = YES;
}
//保存
-(void)bondDoneClick{
    NSLog(@"-------%@",self.presentingViewController);
    NSLog(@"%@",self);
    self.changeView.layer.borderWidth = 0;
    if (self.bgImageView.subviews.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你还没有挑选衣服" message:@"快去添加吧" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (self.edit == YES) {
            [[DataManager sharedInstance]update:[self currentBond]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入板墙名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSString *name = [alertController.textFields[0] text];
                self.title = name;
                self.nameString = name;
                [[DataManager sharedInstance]addBond:[self currentBond]];
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }]];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"板墙名";
            }];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}
//返回
-(void)bondBackClick:(UIButton *)button{
    if (self.bgImageView.subviews.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        ContentController *contentController = [[ContentController alloc]init];
        [contentController setDidSelectHandler:^(NSString *string) {
            NSString *backStrs = string;
            if ([backStrs isEqualToString:@"保存"]) {
                [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                if (self.edit == YES) {
                    [[DataManager sharedInstance]update:[self currentBond]];
                    if (self.backRefreshHandler) {
                        self.backRefreshHandler();
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入板墙名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSString *name = [alertController.textFields[0] text];
                        self.title = name;
                        self.nameString = name;
                        [[DataManager sharedInstance]addBond:[self currentBond]];
                        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }]];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = @"板墙名";
                    }];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }else{
                [[BQDetailDB sharedInstance]deleteByVVID:self.currentBqDetail];
                for (NSInteger m = 0; m < self.tmpArr.count; m ++) {
                    [[BQDetailDB sharedInstance]addDetailModel:self.tmpArr[m]];
                }
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        contentController.modalPresentationStyle = UIModalPresentationPopover;
        contentController.preferredContentSize = CGSizeMake(100, 100);
        UIPopoverPresentationController *popController = contentController.popoverPresentationController;
        popController.sourceView = button;
        popController.sourceRect = button.bounds;
        popController.delegate = self;
        popController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        [self presentViewController:contentController animated:NO completion:nil];
    }
}
//删除
-(void)bondDeleteClick{
    [[BQDetailDB sharedInstance] deleteByDetailTag:self.changeView.UUTag];
    [self.changeView removeFromSuperview];
    NSLog(@"子视图数量:%lu",(long)self.bgImageView.subviews.count);
}
//背景
-(void)bondBgClick:(UIButton *)button{
    BGContentController *bgContent = [[BGContentController alloc]init];
    [bgContent setDidSelectHandler:^(NSString *string) {
        NSString *backStrs = string;
        if ([backStrs isEqualToString:@"图库"]) {
            [self loadImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }else{
            [self loadImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
    }];
    bgContent.modalPresentationStyle = UIModalPresentationPopover;
    bgContent.preferredContentSize = CGSizeMake(100, 100);
    UIPopoverPresentationController *popController = bgContent.popoverPresentationController;
    popController.sourceView = button;
    popController.sourceRect = button.bounds;
    popController.delegate = self;
    popController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    [self presentViewController:bgContent animated:NO completion:nil];
}
- (void)loadImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = sourceType;
        controller.allowsEditing = NO;
        controller.delegate = self;
        [self.presentedViewController presentViewController:controller animated:YES completion:nil];
    }
}
#pragma mark - 截图
-(Bond *)currentBond{
    UIGraphicsBeginImageContext(self.rootsView.bounds.size);
    [_rootsView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewBeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSTimeInterval time=[timeSp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    Bond *bond = [[Bond alloc]init];
    if (self.edit == NO) {
        bond.bondName = self.nameString;
    }else{
        bond.bondName = self.currentBqName;
    }
    bond.bondTime = currentDateStr;
    bond.bondDetail = self.currentBqDetail;
    //bond.bondDetail = [NSString stringWithFormat:@"%ld",self.changeView.tag];
    bond.bondBod = self.bodString;
    bond.bondImage = viewBeImage;
    bond.bondYear = [_userDeft objectForKey:@"selectSTR"];
    return bond;
}
-(NSString *)currentTimer{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSMutableString *str1 = [NSMutableString stringWithString:date];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == ':' || c == '.') {
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", str1];
    return timeLocal;
}
-(void)createType{
    NSString *type = [NSString stringWithFormat:@"%@type",[_userDeft objectForKey:@"selectSTR"]];
    NSArray *array = [_userDeft objectForKey:type];
    self.dataArray = [NSMutableArray arrayWithArray:array];
}

//菜单事件
-(void)bondMenuClick:(UIButton *)button{
    self.tableMenuView.hidden = NO;
    self.goBackView.hidden = NO;
}
#pragma mark - tableview data
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"jt"] forState:UIControlStateNormal];
    cell.accessoryView = button;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.didSelectType = self.dataArray[indexPath.row];
    [self createDetailData];
    [self addCollectionDetail];
    self.currentTag = 0;
}
//详细数据
-(void)createDetailData{
    NSString *yearString = [_userDeft objectForKey:@"selectSTR"];
    self.detailArray = [[DataBase shareInstance]fetchBySession:yearString andType:_didSelectType];
}
//创建collection
-(void)addCollectionDetail{
    self.detailHeadView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-200, 0, 200, 69)];
    _detailHeadView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(10, 35, 25, 25);
    [back setBackgroundImage:[UIImage imageNamed:@"return01"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(tgo) forControlEvents:UIControlEventTouchUpInside];
    [_detailHeadView addSubview:back];
    self.detailMidLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 100, 40)];
    _detailMidLable.text = self.didSelectType;
    _detailMidLable.textColor = [UIColor whiteColor];
    _detailMidLable.textAlignment = NSTextAlignmentCenter;
    _detailMidLable.font = [UIFont systemFontOfSize:25];
    [_detailHeadView addSubview:_detailMidLable];
    [self.view addSubview:_detailHeadView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(180, 180);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.collectionMenuView = [[UICollectionView alloc]initWithFrame:_viewFrame collectionViewLayout:layout];
    _collectionMenuView.delegate = self;
    _collectionMenuView.dataSource = self;
    _collectionMenuView.showsVerticalScrollIndicator = NO;
    _collectionMenuView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    //注册cell
    [_collectionMenuView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionMenuView];
}
-(void)tgo{
    self.detailHeadView.hidden = YES;
    self.collectionMenuView.hidden = YES;
}
#pragma mark - collectionview data 
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.detailArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
    ClothPhoto *cloth = self.detailArray[indexPath.row];
    //cell上的按钮
    UIButton *frontButton = [UIButton buttonWithType:UIButtonTypeSystem];
    frontButton.frame = CGRectMake(0, 140, 90, 40);
    [frontButton setTitle:@"正面" forState:UIControlStateNormal];
    frontButton.tag = 3333+indexPath.row;
    [frontButton setTitleColor:[UIColor colorWithRed:72.0/255 green:200.0/255 blue:90.0/255 alpha:1.0] forState:UIControlStateNormal];
    frontButton.backgroundColor = [UIColor colorWithRed:251.0/255 green:251.0/255 blue:251.0/255 alpha:1.0];
    [frontButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [frontButton addTarget:self action:@selector(fontClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeSystem];
    profileButton.frame = CGRectMake(90, 140, 90, 40);
    [profileButton setTitle:@"侧面" forState:UIControlStateNormal];
    profileButton.tag = 4444+indexPath.row;
    profileButton.backgroundColor = [UIColor colorWithRed:251.0/255 green:251.0/255 blue:251.0/255 alpha:1.0];
    [profileButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    if (cloth.backImage == nil) {
        [profileButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }else{
        [profileButton setTitleColor:[UIColor colorWithRed:72.0/255 green:200.0/255 blue:90.0/255 alpha:1.0] forState:UIControlStateNormal];
        [profileButton addTarget:self action:@selector(profileClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell addSubview:frontButton];
    [cell addSubview:profileButton];
    
    UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    photoView.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == (self.currentTag-4444)) {
        photoView.image = cloth.backImage;
    }else{
        photoView.image = cloth.image;
    }
    cell.backgroundView = photoView;
    
    return cell;
}
//正面按钮
-(void)fontClick:(UIButton *)button{
    NSLog(@"点击了正面");
    NSLog(@"正面按钮：%ld",(long)button.tag);
    self.currentTag = button.tag;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:button.tag-3333 inSection:0];
    [self.collectionMenuView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}
//侧面按钮
-(void)profileClick:(UIButton *)button{
    NSLog(@"点击了侧面");
    NSLog(@"侧挂按钮：%ld",(long)button.tag);
    self.currentTag = button.tag;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:button.tag-4444 inSection:0];
    [self.collectionMenuView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}
//选中一个cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ClothPhoto *cloth = self.detailArray[indexPath.row];
    //点击一件衣服，就新建一个uiimageview
    NSInteger number = arc4random() % 6;
    UIImageView *currentView = [[UIImageView alloc]init];
//    if (indexPath.row == (self.currentTag-4444)) {
//        currentView.frame = CGRectMake(50+number*10, 50+number*10, 50, 240);
//    }else{
//        currentView.frame = CGRectMake(50+number*10, 50+number*10, 200, 240);
//    }
    currentView.backgroundColor = [UIColor clearColor];
    currentView.contentMode = UIViewContentModeScaleAspectFit;
    currentView.userInteractionEnabled = YES;
    currentView.UUTag = [self currentTimer];
    self.changeView = currentView;
    //
    [self.bgImageView addSubview:currentView];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *currentCellView = (UIImageView *)cell.backgroundView;
    currentView.image = currentCellView.image;
    if (currentView.image == cloth.image) {
        currentView.frame = CGRectMake(50+number*10, 50+number*10, 200, 240);
    }else{
        currentView.frame = CGRectMake(50+number*10, 50+number*10, 50, 240);
    }
    [self addGesture:currentView];
    [[BQDetailDB sharedInstance]addDetailModel:[self currentBQ]];
    NSLog(@"子视图数量：%lu",(long)self.bgImageView.subviews.count);
}
-(BQDetailModel *)currentBQ{
    BQDetailModel *detailModel = [[BQDetailModel alloc]init];
    detailModel.orignX = self.changeView.frame.origin.x;
    detailModel.orignY = self.changeView.frame.origin.y;
    detailModel.frameWidth = self.changeView.frame.size.width;
    detailModel.frameHeight = self.changeView.frame.size.height;
    detailModel.image = self.changeView.image;
    detailModel.detailTag = self.changeView.UUTag;
    detailModel.detailYear = [_userDeft objectForKey:@"selectSTR"];
    detailModel.bgImage = self.bgImageView.image;
    detailModel.vvID = self.currentBqDetail;
    return detailModel;
}
-(void)addGesture:(UIImageView *)imageView{
    //拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [imageView addGestureRecognizer:pan];
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [imageView addGestureRecognizer:tap];
    //捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
    [imageView addGestureRecognizer:pinch];
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.1;
    //[imageView addGestureRecognizer:longPress];
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    [imageView addGestureRecognizer:rotation];
}
-(void)tapGesture:(UITapGestureRecognizer *)tap{
    self.changeView.layer.borderWidth = 0;
    UIImageView *currentView = (UIImageView *)tap.view;
    CGRect currentRect = currentView.frame;
    self.changeView = currentView;
    currentView.layer.borderWidth = 2.0;
    currentView.layer.borderColor = kBordColor;
    [self.bgImageView bringSubviewToFront:currentView];
    
#pragma mark - 弹出POP控制器
    //弹出POP
    MenuPopController *menuPOPController = [[MenuPopController alloc]init];
    menuPOPController.dataArray = [NSArray arrayWithObjects:@"删除",@"换色", nil];
    [menuPOPController setSelectHandler:^(NSString *string) {
        if ([string isEqualToString:@"删除"]) {
            
            [[BQDetailDB sharedInstance]deleteByDetailTag:self.changeView.UUTag];
            [self.changeView removeFromSuperview];
        }else if([string isEqualToString:@"换色"]){
#pragma mark - 跳转到换色界面
            ColorController *changeColorController = [[ColorController alloc]init];
            self.changeView.layer.borderWidth = 0;
            changeColorController.kImageView = self.changeView;
            changeColorController.ysImage = self.changeView.image;
            __weak typeof(self) weakSelf = self;
            [changeColorController setDoneHandler:^(UIImageView *imageView) {
                UIImageView *blockImageV = imageView;
                blockImageV.contentMode = UIViewContentModeScaleAspectFit;
                blockImageV.userInteractionEnabled = YES;
                blockImageV.UUTag = self.selectViewTag;
                [self addGesture:blockImageV];
                blockImageV.frame = currentRect;
                [weakSelf.rootsView addSubview:blockImageV];
                weakSelf.changeView = blockImageV;
                blockImageV.layer.borderWidth = 2.0;
                blockImageV.layer.borderColor = kBordColor;
                [weakSelf.rootsView bringSubviewToFront:blockImageV];
                [[BQDetailDB sharedInstance]update:[weakSelf currentBQ]];
            }];
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:changeColorController animated:YES completion:nil];
        }
    }];
    menuPOPController.modalPresentationStyle = UIModalPresentationPopover;
    menuPOPController.preferredContentSize = CGSizeMake(120, 40);
    UIPopoverPresentationController *popController = menuPOPController.popoverPresentationController;
    popController.sourceView = tap.view;
    popController.sourceRect = tap.view.bounds;
    popController.delegate = self;
    popController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    [self presentViewController:menuPOPController animated:YES completion:nil];
}
//移动。。
-(void)panGesture:(UIPanGestureRecognizer *)pan{
    UIImageView *currentView = (UIImageView *)pan.view;
    //
    self.changeView = currentView;
    //
    CGPoint point = [pan translationInView:self.bgImageView];
    CGPoint center = currentView.center;
    center.x += point.x;
    center.y += point.y;
    currentView.center = center;
    // 不让它累加
    [pan setTranslation:CGPointZero inView:self.bgImageView];
    if (pan.state == UIGestureRecognizerStateEnded) {
        [[BQDetailDB sharedInstance]update:[self currentBQ]];
    }
}
//收缩。。
-(void)pinchGesture:(UIPinchGestureRecognizer *)pinch{
    UIImageView *currentView = (UIImageView *)pinch.view;
    //
    self.changeView = currentView;
    //
    currentView.transform = CGAffineTransformScale(currentView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [[BQDetailDB sharedInstance]update:[self currentBQ]];
    }
}
//长按
-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    UIImageView *currentTapView = (UIImageView *)longPress.view;
    //self.selectViewTag = currentTapView.tag;
    //
    self.changeView = currentTapView;
    //
    currentTapView.layer.borderWidth = 2.0;
    currentTapView.layer.borderColor = kBordColor;
    [self.bgImageView bringSubviewToFront:currentTapView];
}
-(void)rotation:(UIRotationGestureRecognizer *)rotation{
    UIImageView *currentView = (UIImageView *)rotation.view;
    self.changeView = currentView;
    currentView.transform = CGAffineTransformRotate(currentView.transform, rotation.rotation);
    rotation.rotation = 0;
    if (rotation.state == UIGestureRecognizerStateEnded) {
        [[BQDetailDB sharedInstance]update:[self currentBQ]];
    }
}
#pragma mark - gesture
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.changeView.layer.borderWidth = 0;
}
#pragma mark - imagePickerController
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *small = [[ImageTools shareTool]thumbnailWithImageWithoutScale:image size:CGSizeMake(400, 400)];
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:small];
    [photoTweaksViewController setSaveImageHandler:^(UIImage *image) {
        //_bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bgImageView.image = image;
    }];
    photoTweaksViewController.delegate = self;
    photoTweaksViewController.autoSaveToLibray = YES;
    [picker pushViewController:photoTweaksViewController animated:YES];
}
- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}
//-(void)viewWillDisappear:(BOOL)animated{
//    NSNotification *notification = [NSNotification notificationWithName:@"Dismiss" object:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
//}
@end
