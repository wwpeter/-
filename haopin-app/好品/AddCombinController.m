//
//  AddCombinController.m
//  好品
//
//  Created by 朱明科 on 15/12/23.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "AddCombinController.h"
#import "DBManager.h"
#import "DataBase.h"
#import "ClothPhoto.h"
#import <QuartzCore/QuartzCore.h>
#import "PopContentController.h"//pop控制器
#import "CBDetailDB.h"
#import "MenuPopController.h"
#import "ColorController.h"

#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
#define kBordColor [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor]

@interface AddCombinController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate>
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic)UIView *rootsView;//根视图，存放所有的组合
@property(nonatomic)UITableView *tableMenuView;//滚动菜单栏
@property(nonatomic)UICollectionView *collectionMenuView;//选项菜单栏
@property(nonatomic)CGRect viewFrame;//菜单栏的frame
@property(nonatomic)NSMutableArray *dataArray;//选项数据
@property(nonatomic)NSMutableArray *detailArray;//详细数据
@property(nonatomic,copy)NSString *didSelectType;//选中的品类
@property(nonatomic)UIImageView *sampImageView;//单个衣服
@property(nonatomic)NSInteger headNum;//记录选中的是第几行品类
@property(nonatomic,copy)NSString *selectViewTag;//点击选中的视图，用来删除的
@property(nonatomic)UIImageView *changeView;
@property(nonatomic,copy)NSString *nameString;//组合的名字
@property(nonatomic)BOOL isPreserve;//记录是不是已经保存过了
@property(nonatomic)UIView *goBackView;
@property(nonatomic)UIView *detailHeadView;
@property(nonatomic)UILabel *detailMidLable;
@property(nonatomic)NSMutableArray *tmpArr;
@end

@implementation AddCombinController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"编辑组合";
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.edit == NO) {
        self.currentCombinDetail = [self currentTimer];
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
    label.text = @"编辑组合";
    label.font = [UIFont systemFontOfSize:25];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:label];
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(10, 30, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return01"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cmbBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
    
    //保存按钮
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(55, 30, 25, 25);
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"storage01"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(cmbDoneClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:doneBtn];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteBtn.frame = CGRectMake(100, 30, 25, 25);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(cmbDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    //[titleView addSubview:deleteBtn];
    
    //菜单
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    menuBtn.frame = CGRectMake(kWidth-90, 30, 25, 25);
    menuBtn.tintColor = [UIColor clearColor];
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"classification"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(cmbMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:menuBtn];
    
    //修改
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bgBtn.frame = CGRectMake(kWidth-45, 30, 25, 25);
    [bgBtn setBackgroundImage:[UIImage imageNamed:@"77"] forState:UIControlStateNormal];
    [bgBtn addTarget:self action:@selector(cmbeditClick:) forControlEvents:UIControlEventTouchUpInside];
    bgBtn.tintColor = [UIColor clearColor];
    [titleView addSubview:bgBtn];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//根View
-(void)addRootsView{
    self.rootsView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kWidth, kHeight)];
    _rootsView.backgroundColor = [UIColor whiteColor];
    _rootsView.userInteractionEnabled = YES;
    if (self.edit == YES) {
        NSMutableArray *mArr = [[CBDetailDB sharedInstance]fetchByVVID:self.currentCombinDetail];
        self.tmpArr = mArr;
        for (NSInteger i = 0; i < mArr.count; i ++) {
            CBDetailModel *model = mArr[i];
            UIImageView *currentView = [[UIImageView alloc]initWithFrame:CGRectMake(model.orignX, model.orignY, model.frameWidth, model.frameHeight)];
            currentView.contentMode = UIViewContentModeScaleAspectFit;
            currentView.backgroundColor = [UIColor clearColor];
            currentView.userInteractionEnabled = YES;
            currentView.image = model.image;
            currentView.UUTag = model.detailTag ;
            [self addGesture:currentView];
            [_rootsView addSubview:currentView];
            
        }
    }
    [self.view addSubview:_rootsView];
}
-(void)createType{
    NSString *type = [NSString stringWithFormat:@"%@type",[_userDeft objectForKey:@"selectSTR"]];
    NSArray *array = [_userDeft objectForKey:type];
    self.dataArray = [NSMutableArray arrayWithArray:array];
}
//返回事件
-(void)cmbBackClick:(UIButton *)item{
    if (self.rootsView.subviews.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        PopContentController *contentController = [[PopContentController alloc]init];
        [contentController setDidSelectHandler:^(NSString *string) {
            NSString *backStrs = string;
            if ([backStrs isEqualToString:@"保存"]) {
                [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
                if (self.edit == YES) {
                    [[DBManager sharedInstance]update:[self currentCombin]];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    if (self.editCombinHandler) {
                        self.editCombinHandler();
                    }
                }else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入组合名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSString *name = [alertController.textFields[0] text];
                        self.title = name;
                        self.nameString = name;
                        [[DBManager sharedInstance]addCombin:[self currentCombin]];
                        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                        
                    }]];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }]];
                    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = @"组合名";
                    }];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }else{
                [[CBDetailDB sharedInstance]deleteByVVID:self.currentCombinDetail];
                for (NSInteger m = 0; m < self.tmpArr.count; m ++) {
                    [[CBDetailDB sharedInstance]addDetailModel:self.tmpArr[m]];
                }
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        contentController.modalPresentationStyle = UIModalPresentationPopover;
        contentController.preferredContentSize = CGSizeMake(100, 100);
        UIPopoverPresentationController *popController = contentController.popoverPresentationController;
        popController.sourceView = item;
        popController.sourceRect = item.bounds;
        popController.delegate = self;
        popController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        [self presentViewController:contentController animated:NO completion:nil];
    }
}
//保存事件
-(void)cmbDoneClick{
    self.changeView.layer.borderWidth = 0;
    if (self.rootsView.subviews.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你还没有挑选衣服" message:@"快去添加吧" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if (self.edit == YES) {
            [[DBManager sharedInstance]update:[self currentCombin]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入组合名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSString *name = [alertController.textFields[0] text];
                self.title = name;
                self.nameString = name;
                [[DBManager sharedInstance]addCombin:[self currentCombin]];
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }]];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"组合名";
            }];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}
-(Combin *)currentCombin{
    UIGraphicsBeginImageContext(self.rootsView.bounds.size);
    [_rootsView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewBeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //将viewBeImage保存起来
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSTimeInterval time=[timeSp doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    Combin *combin = [[Combin alloc]init];
    if (self.curentCombinName != nil) {
        combin.combinName = self.curentCombinName;
    }else{
        combin.combinName = self.nameString;
    }
    combin.combinTime = currentDateStr;
    combin.combinDetail = self.currentCombinDetail;
    //combin.combinDetail = [NSString stringWithFormat:@"%ld",self.changeView.tag];
    combin.combinImage = viewBeImage;
    combin.combinYear = [_userDeft objectForKey:@"selectSTR"];
    return combin;
}
-(NSString *)currentTimer{
    //return [NSString stringWithFormat:@"%f", [[NSDate  date] timeIntervalSince1970]*1000];
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
//删除事件
-(void)cmbDeleteClick{
    [[CBDetailDB sharedInstance] deleteByDetailTag:self.changeView.UUTag];
    [self.changeView removeFromSuperview];
}
//菜单事件
-(void)cmbMenuClick:(UIButton *)button{
    self.tableMenuView.hidden = NO;
    self.goBackView.hidden = NO;
}
//修改事件
-(void)cmbeditClick:(UIButton *)button{

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
    
    self.viewFrame = CGRectMake(kWidth-200, 69, 200, kHeight);
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
#pragma mark - table dele
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setBackgroundImage:[UIImage imageNamed:@"jt"] forState:UIControlStateNormal];
    cell.accessoryView = button;
    return cell;
}
//点击类型就返回相应地数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.didSelectType = self.dataArray[indexPath.row];
    [self createDetailData];
    [self addCollectionDetail];
}

//详细的数据
-(void)createDetailData{
    NSString *yearString = [_userDeft objectForKey:@"selectSTR"];
    self.detailArray = [[DataBase shareInstance]fetchBySession:yearString andType:_didSelectType];
}
//添加详细品类
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
    
    CGRect rect = self.viewFrame;
    rect.size.height = _viewFrame.size.height - 75;
    self.collectionMenuView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
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
#pragma mark - collectionview dele
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.detailArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0;
    cell.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
    ClothPhoto *cloth = self.detailArray[indexPath.row];
    UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    photoView.backgroundColor = [UIColor whiteColor];
    photoView.image = cloth.image;
    cell.backgroundView = photoView;
    return cell;
}
//选中一个cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ClothPhoto *cloth = self.detailArray[indexPath.row];
    //点击一件衣服，就新建一个uiimageview
    NSInteger number = arc4random() % 6;
    UIImageView *currentView = [[UIImageView alloc]initWithFrame:CGRectMake(50+number*10, 50+number*10, 200, 240)];
    currentView.contentMode = UIViewContentModeScaleAspectFit;
    currentView.backgroundColor = [UIColor clearColor];
    currentView.userInteractionEnabled = YES;
    currentView.UUTag = [self currentTimer];
    NSLog(@"%ld",currentView.tag);
    self.changeView = currentView;
    [self.rootsView addSubview:currentView];
    currentView.image = cloth.image;
    [self addGesture:currentView];//添加手势
    [[CBDetailDB sharedInstance]addDetailModel:[self currentCB]];
    NSLog(@"子视图数量：%lu",(unsigned long)self.rootsView.subviews.count);
}
-(CBDetailModel *)currentCB{
    CBDetailModel *detailModel = [[CBDetailModel alloc]init];
    detailModel.orignX = self.changeView.frame.origin.x;
    detailModel.orignY = self.changeView.frame.origin.y;
    detailModel.frameWidth = self.changeView.frame.size.width;
    detailModel.frameHeight = self.changeView.frame.size.height;
    detailModel.image = self.changeView.image;
    detailModel.detailTag = self.changeView.UUTag;
    detailModel.detailYear = [_userDeft objectForKey:@"selectSTR"];
    detailModel.vvID = self.currentCombinDetail;
    return detailModel;
}
-(void)addGesture:(UIImageView *)imageView{
    //拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [imageView addGestureRecognizer:pan];
    //捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [imageView addGestureRecognizer:pinch];
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.1;
    //[imageView addGestureRecognizer:longPress];
    //单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
    //旋转手势
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    [imageView addGestureRecognizer:rotation];
}
-(void)tap:(UITapGestureRecognizer *)tap{
    UIImageView *currentView = (UIImageView *)tap.view;
    CGRect currentRect = currentView.frame;
    self.changeView = currentView;
    self.selectViewTag = currentView.UUTag;
    currentView.layer.borderWidth = 2.0;
    currentView.layer.borderColor = kBordColor;
    [self.rootsView bringSubviewToFront:currentView];
    
#pragma mark - 弹出POP控制器
    //弹出POP
    MenuPopController *menuPOPController = [[MenuPopController alloc]init];
    menuPOPController.dataArray = [NSArray arrayWithObjects:@"删除",@"换色", nil];
    [menuPOPController setSelectHandler:^(NSString *string) {
        if ([string isEqualToString:@"删除"]) {
            [[CBDetailDB sharedInstance]deleteByDetailTag:self.changeView.UUTag];
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
                [[CBDetailDB sharedInstance]update:[weakSelf currentCB]];
            }];
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            NSLog(@"%@",self.presentedViewController);
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
-(void)pan:(UIPanGestureRecognizer *)pan{
    UIImageView *currentView = (UIImageView *)pan.view;
    self.changeView = currentView;
    CGPoint point = [pan translationInView:self.rootsView];
    CGPoint center = currentView.center;
    center.x += point.x;
    center.y += point.y;
    currentView.center = center;
    // 不让它累加
    [pan setTranslation:CGPointZero inView:self.rootsView];
    if (pan.state == UIGestureRecognizerStateEnded) {
        [[CBDetailDB sharedInstance]update:[self currentCB]];
    }
}
-(void)pinch:(UIPinchGestureRecognizer *)pinch{
    UIImageView *currentView = (UIImageView *)pinch.view;
    self.changeView = currentView;
    currentView.transform = CGAffineTransformScale(currentView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [[CBDetailDB sharedInstance]update:[self currentCB]];
    }
}
-(void)longPress:(UILongPressGestureRecognizer *)longPress{
    UIImageView *currenTapView = (UIImageView *)longPress.view;
    self.changeView = currenTapView;
    self.selectViewTag = currenTapView.UUTag;
    currenTapView.layer.borderWidth = 2.0;
    currenTapView.layer.borderColor = kBordColor;
    [self.rootsView bringSubviewToFront:currenTapView];
}
-(void)rotation:(UIRotationGestureRecognizer *)rotation{
    UIImageView *currentView = (UIImageView *)rotation.view;
    self.changeView = currentView;
    currentView.transform = CGAffineTransformRotate(currentView.transform, rotation.rotation);
    rotation.rotation = 0;
    if (rotation.state == UIGestureRecognizerStateEnded) {
        [[CBDetailDB sharedInstance]update:[self currentCB]];
    }
}
#pragma mark - gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    UIImageView *currentView = (UIImageView *)[self.view viewWithTag:self.selectViewTag];
//    currentView.layer.borderWidth = 0.0;
//    self.selectViewTag = 99;
    self.changeView.layer.borderWidth = 0;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    NSNotification *notification = [NSNotification notificationWithName:@"backDismiss" object:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
//}
@end
