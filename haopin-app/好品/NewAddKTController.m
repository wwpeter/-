//
//  NewAddKTController.m
//  haopin
//
//  Created by 朱明科 on 16/3/10.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "NewAddKTController.h"
#import "DataBase.h"
#import "ClothPhoto.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ChooseController.h"
#import "NewKTDetail.h"//杆的数据
#import "NewKTDB.h"//上货周期的数据
#import "ZhuTiModel.h"//主题model
#import "ZhuTiDB.h"//截图
#import "TopicsDB.h"//主题
#define kBordColor [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor]
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface NewAddKTController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (nonatomic) BOOL yiJaiBOOL;
@property (nonatomic) UICollectionView *toolCollectioView;//下面的选项
@property (nonatomic) UICollectionView *ganCollectionView;//展示选的衣服所以得东
@property (nonatomic) NSMutableArray *toolArr;//工具栏的数据
@property (nonatomic) UIView *mainDetailView;//主要信息模板
@property (nonatomic) UITableView *tableMenuView;//滚动菜单栏
@property (nonatomic) UIView *goBackView;//选的上的 返回按钮
@property (nonatomic) CGRect viewFrame;//菜单栏的frame
@property (nonatomic,copy) NSString *didSelectType;//记录选中的品类
@property (nonatomic) UIView *detailHeadView;//返回按钮的视图
@property (nonatomic) UILabel *detailMidLable;//下面杆上的文字
@property (nonatomic) NSMutableArray *dataArray;//下面的主要信息和杆
@property (nonatomic) NSMutableArray *detailArray;//类型的主要信息
@property (nonatomic) NSMutableArray *ganArray;//展示选的衣服所以得东西
@property (nonatomic) NSUserDefaults *userDeft;//沙河目录
@property (nonatomic) UICollectionView *collectionMenuView;//选项菜单栏
@property (nonatomic) UIImageView *currentZTPicture;//当前主题图片
@property (nonatomic) UIView *ganView;//杆视图
@property (nonatomic) BOOL hidden;//是否隐藏
@property (nonatomic,copy) NSString *STR;//当前的年份
@property (nonatomic) UITextView *currentTextView;
@property (nonatomic) UIImageView *changeView;
@property (nonatomic) UIImage *changeImage;
@property (nonatomic) UIButton *addGanBtn;//增加杆数按钮
@property (nonatomic) NSInteger currentTag;//当前的tag,正反按钮使用
@property (nonatomic) BOOL zhengFan;
@property (nonatomic) BOOL baoCun;
@property (nonatomic) BOOL xuanZhouQi;
@property (nonatomic) ChooseController *chooseController;//选择上货周期子视图控制器
@property (nonatomic) BOOL selectDate;//选择了上货周期
@property (nonatomic) NSMutableArray *ganNumArr;//有多少杆
@property (nonatomic) BOOL turnToAddGan;//是否可以添加杆了
@property (nonatomic) NSMutableArray *ganDetailArr;//每个杆上的数据
@property (nonatomic) UIScrollView *resultScrollView;
@property(nonatomic)BOOL haveChanged;//已经编辑过，点击下个货杆要提示先保存
@property(nonatomic,copy)NSString *detailStr;//判断是杆货还是主题
@property(nonatomic,copy)NSString *timerTag;
@property (nonatomic) UIView *titleView;
@property (nonatomic) UITextView *titleTextView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIButton *titleBut;
@property (nonatomic) UIView *lineView;
@property(nonatomic)UILabel *changeLabel;//当前编辑的label
@property(nonatomic)UIImageView *changeZhuti;//当前编辑的主题图片
@property(nonatomic,copy)NSString *whatView;//判断是文字还是图片
@property(nonatomic)BOOL editBool;//判断文字是不是修改的
@property(nonatomic)BOOL xxx;//程序跑起来第一个cell选中
@property(nonatomic)BOOL yesOrNo;//返回的时候判断，是不是修改过，修改过就弹出警告框
@end

@implementation NewAddKTController
-(ChooseController *)chooseController{
    if (_chooseController == nil) {
        _chooseController = [[ChooseController alloc]init];
        _chooseController.view.frame = CGRectMake(300, 100, self.view.frame.size.width-600, 500);
        __weak typeof(self)weakself = self;
        [_chooseController setSelectHandler:^(NSString *str,BOOL chosed) {
            weakself.currentData = [NSString stringWithString:str];
            weakself.yearAndDate = [NSString stringWithFormat:@"%@%@",weakself.currentYear,weakself.currentData];
            weakself.selectDate = chosed;
        }];
    }
    return _chooseController;
}
- (NSMutableArray *)detailArray {
    if (_detailArray == nil) {
        _detailArray = [NSMutableArray array];
    }
    return _detailArray;
}
- (NSMutableArray *)dataArray {
    if (_dataArray ==nil) {
        NSString *type = [NSString stringWithFormat:@"%@type",[_userDeft objectForKey:@"selectSTR"]];
        NSArray *array = [_userDeft objectForKey:type];
        _dataArray = [NSMutableArray arrayWithArray:array];
        [_dataArray addObject:[NSString stringWithFormat:@"衣架"]];
    }
    return _dataArray;
}
- (NSMutableArray *)ganArray {
    if (_ganArray == nil) {
        _ganArray = [NSMutableArray array];
    }
    return _ganArray;
}
-(NSMutableArray *)ganNumArr{
    if (_ganNumArr == nil) {
        _ganNumArr = [NSMutableArray array];
    }
    return _ganNumArr;
}
//衣服杆
- (UIView *)ganView {
    if (!_ganView) {
        _resultScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 400)];
        
        _ganView = [[UIView alloc] initWithFrame:CGRectMake(0, 300+12, self.view.frame.size.width+800, 400)];
        _ganView.backgroundColor = [UIColor whiteColor];
        _ganView.userInteractionEnabled = YES;
        _resultScrollView.contentSize = CGSizeMake(self.view.frame.size.width+800, 400);
        [_ganView addSubview:_resultScrollView];
        //scrollView.backgroundColor = [UIColor yellowColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, self.view.frame.size.width-150, 355)];
        imageView.image = [UIImage imageNamed:@"haoyang_liangyigan"];
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-130, 30, self.view.frame.size.width-150, 355)];
        imageView1.image = [UIImage imageNamed:@"haoyang_liangyigan.png"];
        [_resultScrollView addSubview:imageView];
        [_resultScrollView addSubview:imageView1];
        [self.view addSubview:_ganView];
    }
    return _ganView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.userDeft = [NSUserDefaults standardUserDefaults];
    //[self.view addSubview:self.ganView];
    // Do any additional setup after loading the view.
    self.detailStr = @"主题";
    self.currentYear = [_userDeft objectForKey:@"selectSTR"];
     self.zhengFan = YES;
    self.baoCun = YES;
    self.yiJaiBOOL = NO;
    self.navigationController.title = @"编辑KT板";
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:25],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self addButton];
    [self createData];//userDeft里取出杆数
    [self addBGView];//添加主题页面
    [self addTool];
    [self xuanZeZhuTi];
}
-(void)addBGView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainDetailView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth-200, kHeight-185)];
    _mainDetailView.backgroundColor = [UIColor whiteColor];
    _mainDetailView.userInteractionEnabled = YES;
    [self.view addSubview:_mainDetailView];
    _titleLabel.frame = CGRectMake(2, kHeight -285, kWidth -  200, 100);
    [_mainDetailView addSubview:_titleLabel];
    [self addImageWenZi];
}
//右面的文字和图片
- (void)addImageWenZi {
    //主题
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 160, 150, 150, 180)];
    //imageView.layer.borderWidth = 1.0;
    _imageView.layer.borderColor = [UIColor grayColor].CGColor;
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = [UIImage imageNamed:@"HY_title_iamge.png"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pTap:)];
    [_imageView addGestureRecognizer:tap];
    _titleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBut.frame = CGRectMake(self.view.frame.size.width - 160, 330, 150, 50);
    _titleBut.layer.cornerRadius = 8;
    [_titleBut setImage:[UIImage imageNamed:@"wenziww"] forState:UIControlStateNormal];
    [_titleBut addTarget:self action:@selector(addTitle:) forControlEvents:UIControlEventTouchUpInside];
    //titleBut.layer.borderWidth = 1;
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(kWidth-180, 0, 2, kHeight)];
    _lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [self.view addSubview:_lineView];
    
    [self.view addSubview:_titleBut];
    [self.view addSubview:_imageView];
}
//点击从相册添加主题图片
-(void)pTap:(UITapGestureRecognizer *)tap{
    self.currentZTPicture = (UIImageView *)tap.view;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *libaryAction = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }];
    UIAlertAction *cammerAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:libaryAction];
    [alertController addAction:cammerAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 文字增添
- (void)addTitle:(UIButton *)button {
    if (_titleView ==nil) {
        self.editBool = NO;
        [self addText];
    }
}
-(void)addText{
    _titleView.userInteractionEnabled = YES;
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(230, 50, 500, 400)];
    _titleView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_titleView];
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancle setTitle:@"关闭" forState:UIControlStateNormal];
    cancle.frame = CGRectMake(10, 5, 80, 50);
    [cancle setTintColor:[UIColor greenColor]];
    [cancle addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:cancle];
    
    UIButton *OkBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [OkBut setTitle:@"确定" forState:UIControlStateNormal];
    OkBut.frame = CGRectMake(400, 5, 80, 50);
    [OkBut setTintColor:[UIColor greenColor]];
    [OkBut addTarget:self action:@selector(OKBut:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:OkBut];
    
    _titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(2, 60, 496, 338)];
    _titleTextView.backgroundColor = [UIColor whiteColor];
    _titleTextView.font = [UIFont systemFontOfSize:17];
    [_titleView addSubview:_titleTextView];
}
-(TopicsModel *)currentTopicZi{
    TopicsModel *model = [[TopicsModel alloc]init];
    model.orignX = self.changeLabel.frame.origin.x;
    model.orignY = self.changeLabel.frame.origin.y;
    model.frameWidth = self.changeLabel.frame.size.width;
    model.frameHeight = self.changeLabel.frame.size.height;
    model.Tag = [NSString stringWithFormat:@"%ld",self.changeLabel.tag];
    model.image = nil;
    model.currentYear = self.currentYear;
    model.currentDate = self.currentData;
    model.detail = self.changeLabel.text;
    return model;
}
-(TopicsModel *)currentTopicTu{
    TopicsModel *model = [[TopicsModel alloc]init];
    model.orignX = self.changeZhuti.frame.origin.x;
    model.orignY = self.changeZhuti.frame.origin.y;
    model.frameWidth = self.changeZhuti.frame.size.width;
    model.frameHeight = self.changeZhuti.frame.size.height;
    model.Tag = [NSString stringWithFormat:@"%ld",self.changeZhuti.tag];
    model.image = self.changeZhuti.image;
    model.currentYear = self.currentYear;
    model.currentDate = self.currentData;
    model.detail = nil;
    return model;
}

#pragma mark - 文字视图的点击方法
- (void)cancle:(UIButton *)button {
    [_titleView removeFromSuperview];
    _titleView = nil;
    _titleTextView = nil;
}
- (void)OKBut:(UIButton *)button {
    self.yesOrNo = YES;
    if (self.editBool == YES) {
        self.changeLabel.text = _titleTextView.text;
        CGSize textSize = [self.changeLabel.text boundingRectWithSize:CGSizeMake(self.changeLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil].size;
        CGRect frame = self.changeLabel.frame;
        frame.size.height = textSize.height;
        self.changeLabel.frame = frame;
        [[TopicsDB sharedInstance]update:[self currentTopicZi]];
        
    }else{
        self.haveChanged = YES;
        CGFloat resultWidth = arc4random()%100*3;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10+resultWidth, 400, 200, 50)];
        label.userInteractionEnabled = YES;
        label.layer.borderWidth = 1.0;
        
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.tag = [[self currentTimer] longLongValue];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor redColor];
        self.changeLabel = label;
        label.text = _titleTextView.text;
        CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil].size;
        CGRect frame = label.frame;
        frame.size.height = textSize.height;
        label.frame = frame;
        [self addLabelGesture:label];
        label.textColor = [UIColor colorWithWhite:0 alpha:0.5];
        [[TopicsDB sharedInstance]addDetailModel:[self currentTopicZi]];
        [_mainDetailView addSubview:label];
        
    }
    [_titleView removeFromSuperview];
    _titleTextView.text = nil;
    _titleView = nil;
    _titleTextView = nil;
}
-(void)addLabelGesture:(UILabel *)lable{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(labelPan:)];
    [lable addGestureRecognizer:pan];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(labelPinch:)];
    [lable addGestureRecognizer:pinch];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTap:)];
    [lable addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(labelLongPress:)];
    [lable addGestureRecognizer:longPress];
}
-(void)labelPan:(UIPanGestureRecognizer *)pam{
    self.yesOrNo = YES;
    self.changeLabel.layer.borderColor = [UIColor grayColor].CGColor;
    UILabel *currentLabel = (UILabel *)pam.view;
    self.changeLabel = currentLabel;
    CGPoint point = [pam translationInView:self.mainDetailView];
    CGPoint center = currentLabel.center;
    center.x += point.x;
    center.y += point.y;
    if (center.x <= currentLabel.frame.size.width/2.0) {
        center.x = currentLabel.frame.size.width/2.0;
    }else if (center.x >= self.mainDetailView.frame.size.width - currentLabel.frame.size.width/2.0){
        center.x = self.mainDetailView.frame.size.width - currentLabel.frame.size.width/2.0;
    }
    if (center.y <= currentLabel.frame.size.height/2.0) {
        center.y = currentLabel.frame.size.height/2.0;
    }else if (center.y >= self.mainDetailView.frame.size.height - currentLabel.frame.size.height/2.0){
        center.y = self.mainDetailView.frame.size.height - currentLabel.frame.size.height/2.0;
    }
    currentLabel.center = center;
    // 不让它累加
    [pam setTranslation:CGPointZero inView:self.mainDetailView];
    if (pam.state == UIGestureRecognizerStateEnded) {
        [[TopicsDB sharedInstance] update:[self currentTopicZi]];
    }
}
-(void)labelPinch:(UIPinchGestureRecognizer *)pich{
    self.yesOrNo = YES;
    self.changeLabel.layer.borderColor = [UIColor grayColor].CGColor;
    UILabel *currentLable = (UILabel *)pich.view;
    self.changeLabel = currentLable;
    currentLable.transform = CGAffineTransformScale(currentLable.transform, pich.scale, pich.scale);
    pich.scale = 1.0;
    if (pich.state == UIGestureRecognizerStateEnded) {
        [[TopicsDB sharedInstance]update:[self currentTopicZi]];
    }
}
-(void)labelTap:(UITapGestureRecognizer *)tap{
    self.changeLabel.layer.borderColor = [UIColor grayColor].CGColor;
    UILabel *currentLable = (UILabel *)tap.view;
    self.changeLabel = currentLable;
    currentLable.layer.borderWidth = 1.0;
    currentLable.layer.borderColor = [UIColor blueColor].CGColor;
    self.whatView = @"文字";
}

-(void)labelLongPress:(UILongPressGestureRecognizer *)longPress{
    self.editBool = YES;
    if (_titleView == nil) {
        [self addText];
    }
    self.changeLabel.layer.borderColor = [UIColor grayColor].CGColor;
    UILabel *currentLable = (UILabel *)longPress.view;
    self.changeLabel = currentLable;
    self.titleTextView.text = currentLable.text;
}
#pragma mark - textView delegate
-(void)textViewDidEndEditing:(UITextView *)textView{
    self.STR = textView.text;
    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil].size;
    CGRect frame = textView.frame;
    frame.size.height = textSize.height;
    textView.frame = frame;
    textView.backgroundColor = nil;
}
- (void)xuanZeZhuTi {
    //子视图控制器
    if (!self.isEdit) {
        if (self.childViewControllers.count == 0) {
            [self addChildViewController:self.chooseController];
            [self.view addSubview:_chooseController.view];
            self.turnToAddGan = YES;
            
            NSString *year = [_userDeft objectForKey:@"selectSTR"];
            NSString *string = [NSString stringWithFormat:@"%@%@",year,self.currentData];
            self.yearAndDate = string;

        }
    }
    else {
        NSMutableArray *quArr = [[TopicsDB sharedInstance]fetchKTByYear:self.currentYear andDate:self.currentData];
        for (NSInteger i = 0; i < quArr.count; i ++) {
            TopicsModel *model = quArr[i];
            if (model.detail == nil) {
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(model.orignX, model.orignY, model.frameWidth, model.frameHeight)];
                image.userInteractionEnabled = YES;
                image.contentMode = UIViewContentModeScaleAspectFit;
                image.image = model.image;
                image.tag = [model.Tag longLongValue];
                [self addGesture:image];
                [_mainDetailView addSubview:image];
            }else{
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(model.orignX, model.orignY, model.frameWidth, model.frameHeight)];
                label.userInteractionEnabled = YES;
                label.text = model.detail;
                CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil].size;
                CGRect frame = label.frame;
                frame.size.height = textSize.height;
                label.layer.borderWidth = 1.0;
                label.backgroundColor = [UIColor whiteColor];
                label.layer.borderColor = [UIColor grayColor].CGColor;
                label.frame = frame;
                label.numberOfLines  = 0;
                label.tag = [model.Tag longLongValue];
                [self addLabelGesture:label];
                [_mainDetailView addSubview:label];
            }
        }
        
        self.turnToAddGan = YES;
    }
}


-(void)loadImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = sourceType;
        controller.delegate = self;
        controller.allowsEditing = NO;
        //controller.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
#pragma mark - 相机
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType  = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGFloat resultWidth = arc4random()%100*3;
        UIImageView *zhuTiImage = [[UIImageView alloc] initWithFrame:CGRectMake(100+resultWidth, 10, 150, 150)];
        zhuTiImage.userInteractionEnabled = YES;
        zhuTiImage.contentMode = UIViewContentModeScaleAspectFit;
        zhuTiImage.image = image;
        zhuTiImage.tag = [[self currentTimer] longLongValue];
        [self addGesture:zhuTiImage];
        self.changeZhuti = zhuTiImage;
        [[TopicsDB sharedInstance]addDetailModel:[self currentTopicTu]];
        [_mainDetailView addSubview:zhuTiImage];
        self.haveChanged = YES;
        self.yesOrNo = YES;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

}
-(void)addGesture:(UIImageView *)picture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zzTap:)];
    [picture addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(zzPan:)];
    [picture addGestureRecognizer:pan];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zzPinch:)];
    [picture addGestureRecognizer:pinch];
}
-(void)zzTap:(UITapGestureRecognizer *)tap{
    self.changeZhuti.layer.borderWidth = 0;
    UIImageView *current = (UIImageView *)tap.view;
    self.changeZhuti = current;
    current.layer.borderWidth = 1.0;
    current.layer.borderColor = [UIColor greenColor].CGColor;
    self.whatView = @"主图";
    [self.mainDetailView bringSubviewToFront:self.changeZhuti];
}
-(void)zzPan:(UIPanGestureRecognizer *)pan{
    self.yesOrNo = YES;
    self.changeZhuti.layer.borderWidth = 0;
    UIImageView *currentView = (UIImageView *)pan.view;
    self.changeZhuti = currentView;
    CGPoint point = [pan translationInView:self.mainDetailView];
    CGPoint center = currentView.center;
    center.x += point.x;
    center.y += point.y;
    if (center.x <= currentView.frame.size.width/2.0) {
        center.x = currentView.frame.size.width/2.0;
    }else if (center.x >= self.mainDetailView.frame.size.width - currentView.frame.size.width/2.0){
        center.x = self.mainDetailView.frame.size.width - currentView.frame.size.width/2.0;
    }
    if (center.y <= currentView.frame.size.height/2.0) {
        center.y = currentView.frame.size.height/2.0;
    }else if (center.y >= self.mainDetailView.frame.size.height - currentView.frame.size.height/2.0){
        center.y = self.mainDetailView.frame.size.height - currentView.frame.size.height/2.0;
    }
    currentView.center = center;
    // 不让它累加
    [pan setTranslation:CGPointZero inView:self.mainDetailView];
    if (pan.state == UIGestureRecognizerStateEnded) {
        [[TopicsDB sharedInstance]update:[self currentTopicTu]];
    }
}
-(void)zzPinch:(UIPinchGestureRecognizer *)pinch{
    self.yesOrNo = YES;
    self.changeZhuti.layer.borderWidth = 0;
    UIImageView *currentView = (UIImageView *)pinch.view;
    self.changeZhuti = currentView;
    currentView.transform = CGAffineTransformScale(currentView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [[TopicsDB sharedInstance]update:[self currentTopicTu]];
    }
}
-(void)createData{
    if (self.yearAndDate == nil) {
        self.toolArr = [NSMutableArray arrayWithObject:@"主题"];
    }else{
        NSArray *arr = [_userDeft objectForKey:self.yearAndDate];
        self.toolArr = [NSMutableArray arrayWithArray:arr];
        [_toolArr insertObject:@"主题" atIndex:0];
        self.ganNumArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:self.yearAndDate]];
        self.ganArray = [[NewKTDB sharedInstance]fetchKTBySession:self.currentYear andDate:self.currentData];
    }
}
-(void)addButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 45, 44);
    [backButton setImage:[[UIImage imageNamed:@"return01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(0, 0, 45, 44);
    [doneButton setImage:[[UIImage imageNamed:@"storage01"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
    
    UIButton *deleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleButton.frame = CGRectMake(0, 0, 45, 44);
    [deleButton setImage:[[UIImage imageNamed:@"delete001"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [deleButton addTarget:self action:@selector(deletes:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:deleButton];
    
    self.navigationItem.leftBarButtonItems = @[item1,item2,item3];
    
    UIButton *goodsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    goodsButton.frame = CGRectMake(0, 0, 45, 44);
    
    [goodsButton setImage:[[UIImage imageNamed:@"classification"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [goodsButton setImage:[[UIImage imageNamed:@"classification"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateSelected];
    goodsButton.tintColor = [UIColor clearColor];
    goodsButton.showsTouchWhenHighlighted = NO;
    [goodsButton addTarget:self action:@selector(goods:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc]initWithCustomView:goodsButton];
    
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    timeButton.frame = CGRectMake(0, 0, 45, 44);
    [timeButton setImage:[[UIImage imageNamed:@"choice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    timeButton.tintColor = [UIColor clearColor];
    timeButton.showsTouchWhenHighlighted = NO;
    [timeButton addTarget:self action:@selector(times:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item5 = [[UIBarButtonItem alloc]initWithCustomView:timeButton];
    
    self.navigationItem.rightBarButtonItems = @[item4,item5];
}
//返回
-(void)back:(UIButton *)button{
    if (self.yesOrNo == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先保存！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:alert repeats:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.barTintColor = nil;
    }
    
}
//保存
-(void)done:(UIButton *)button{
    self.baoCun = YES;
    if (self.detailStr) {
        ZhuTiModel *model = [[ZhuTiDB sharedInstance]fetchKTByYear:self.currentYear andDate:self.currentData andDetail:self.detailStr];
        [[ZhuTiDB sharedInstance]deleteByTag:model.tag];
        [[ZhuTiDB sharedInstance]addDetailModel:[self jietu]];
        self.haveChanged = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已保存！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:alert repeats:NO];
    }
    self.yesOrNo = NO;
}
-(void)timer:(NSTimer *)timer{
    UIAlertController *alert = timer.userInfo;
    [self dismissViewControllerAnimated:alert completion:nil];
    [timer invalidate];
}
-(ZhuTiModel *)jietu {
    ZhuTiModel *model = [[ZhuTiModel alloc]init];
    if ([self.detailStr isEqualToString:@"主题"]) {
        UIGraphicsBeginImageContext(self.mainDetailView.bounds.size);
        [_mainDetailView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewBeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        model.image = viewBeImage;
    } else {
        UIImage *jietu = [self captureScrollView:_resultScrollView];
         model.image = jietu;
    }
    model.year = self.currentYear;
    model.date = self.currentData;
    model.detail = self.detailStr;
    model.tag = self.timerTag;
    return model;
}
//截图ScrollView
- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}
//删除
-(void)deletes:(UIButton *)button{
    if ([self.whatView isEqualToString:@"文字"]) {
        NSString *tag = [NSString stringWithFormat:@"%ld",(long)self.changeLabel.tag];
        [[TopicsDB sharedInstance]deleteByTag:tag];
        [self.changeLabel removeFromSuperview];
    }else if ([self.whatView isEqualToString:@"主图"]){
        NSString *tag = [NSString stringWithFormat:@"%ld",(long)self.changeZhuti.tag];
        [[TopicsDB sharedInstance]deleteByTag:tag];
        [self.changeZhuti removeFromSuperview];
    }
    NSString *tag = [NSString stringWithFormat:@"%ld",(long)self.changeView.tag];
    [[NewKTDetail sharedInstance]deleteByTag:tag];
    [self.changeView removeFromSuperview];

}
#pragma mark -菜单

//货品    
-(void)goods:(UIButton *)button{
    [self addTableMenuView];
    self.tableMenuView.hidden = NO;
    self.goBackView.hidden = NO;
}
//上货周期
-(void)times:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.addGanBtn.hidden = YES;
        self.toolCollectioView.hidden = YES;
        self.hidden =YES;
    } else {
        self.toolCollectioView.hidden = NO;
        self.addGanBtn.hidden =NO;
        [self.view bringSubviewToFront:self.addGanBtn];
        [self.view bringSubviewToFront:self.toolCollectioView];
        self.hidden =NO;
    }
}
//底部工具栏
-(void)addTool{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(150, 100);
    layOut.minimumInteritemSpacing = 10;
    layOut.minimumLineSpacing = 10;
    layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.toolCollectioView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kHeight-184, kWidth-120, 120) collectionViewLayout:layOut];
    _toolCollectioView.backgroundColor = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    _toolCollectioView.delegate = self;
    _toolCollectioView.dataSource = self;
    _addGanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _addGanBtn.frame = CGRectMake(kWidth-120, kHeight-184, 120, 120);
    [_addGanBtn setBackgroundImage:[UIImage imageNamed:@"addKT"] forState:UIControlStateNormal];
    [_addGanBtn addTarget:self action:@selector(addHuoGan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addGanBtn];
    self.hidden = NO;
    //[_toolCollectioView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_toolCollectioView];
    
}

#pragma mark - 添加货杆
//添加货杆
-(void)addHuoGan:(UIButton *)button{
    if (self.turnToAddGan) {
        //[self createGanNumArr];
        if (YES) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入货杆编号" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSString *name = [alertController.textFields[0] text];//货杆的名字
                [self.toolArr addObject:name];
                [self addGanArr:name];//确定的时候就保存到userDeft
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.toolCollectioView reloadData];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }]];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"货杆数";
            }];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
//            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请保存杆上的内容" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }]];
//            [self presentViewController:controller animated:YES completion:nil];
        }
    }
    
}
-(void)createGanNumArr{
    self.ganNumArr = nil;
    self.ganNumArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:self.yearAndDate]];
}
-(void)addGanArr:(NSString *)name{
    self.ganNumArr = nil;
    self.ganNumArr = [NSMutableArray arrayWithArray:[_userDeft objectForKey:self.yearAndDate]];
    [self.ganNumArr addObject:name];
    NSArray *array = [NSArray arrayWithArray:self.ganNumArr];
    [_userDeft setObject:array forKey:self.yearAndDate];
    [_userDeft synchronize];
}
#pragma mark - collectionview dele
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.toolCollectioView) {
         return self.toolArr.count;
    }
    else if (collectionView == self.collectionMenuView) {
        return self.detailArray.count;
   }
    else if (collectionView == self.ganCollectionView){
        return self.ganArray.count;
        
    }
    else {
    return 0;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.ganCollectionView) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ganCellID" forIndexPath:indexPath];
          //  GanModel *model = self.ganArray[indexPath.row];
        UIImageView *imageView = [[UIImageView alloc] init];
        NewKTModel *model = self.ganArray[indexPath.row];
        imageView.image = model.image;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0]CGColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.backgroundView = imageView;
        
        UIImageView *markView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        markView.image = [UIImage imageNamed:@"xiaosanjiao.png"];
        [cell.backgroundView addSubview:markView];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, 20, 20)];
        numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row/2+1];
        numLabel.font = [UIFont systemFontOfSize:12];
        numLabel.textColor = [UIColor darkGrayColor];
       
        [cell.backgroundView addSubview:numLabel];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
        [cell addGestureRecognizer:longPress];
        return cell;
    }
    if (collectionView == self.toolCollectioView) {
        NSString *cellID = [NSString stringWithFormat:@"cellID%ld",indexPath.row];
        [_toolCollectioView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:cellID,indexPath.row]];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 100)];
        imageView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
        label.text = self.toolArr[indexPath.row];
        label.backgroundColor = [UIColor colorWithRed:135.0/256 green:135.0/256 blue:135.0/256 alpha:1.0];
        label.textColor = [UIColor whiteColor];
        [imageView addSubview:label];
        cell.backgroundView = imageView;
        return cell;
 
    }
    if (collectionView == self.collectionMenuView) {
        if (self.yiJaiBOOL) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
            cell.layer.borderWidth = 1.0;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = self.detailArray[indexPath.row];
            cell.backgroundView = imageView;
            return cell;
        } else {
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
    }
    return nil;
}
//正面按钮
-(void)fontClick:(UIButton *)button{
    self.currentTag = button.tag;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:button.tag-3333 inSection:0];
    [self.collectionMenuView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}
//侧面按钮
-(void)profileClick:(UIButton *)button{
    self.currentTag = button.tag;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:button.tag-4444 inSection:0];
    [self.collectionMenuView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}
#pragma mark - 效果图
- (void)createResult {
    
}
#pragma mark -结果效果的
- (void)panResult:(UIPanGestureRecognizer *)pan1 {
    self.yesOrNo = YES;
    self.haveChanged = YES;
    self.changeView.layer.borderWidth = 0;
    UIImageView *currentView = (UIImageView *)pan1.view;
    self.changeView = currentView;
    CGPoint point = [pan1 translationInView:self.ganView];
    CGPoint center = currentView.center;
    center.x += point.x;
    center.y += point.y;
    
    if (center.x <= currentView.frame.size.width/2.0) {
        center.x = currentView.frame.size.width/2.0;
    }else if (center.x >= self.ganView.frame.size.width - currentView.frame.size.width/2.0){
        center.x = self.ganView.frame.size.width - currentView.frame.size.width/2.0;
    }
    if (center.y <= currentView.frame.size.height/2.0) {
        center.y = currentView.frame.size.height/2.0;
    }else if (center.y >= self.ganView.frame.size.height - currentView.frame.size.height/2.0){
        center.y = self.ganView.frame.size.height - currentView.frame.size.height/2.0;
    }
    currentView.center = center;
   //  不让它累加
    [pan1 setTranslation:CGPointZero inView:_ganView];
    if (pan1.state == UIGestureRecognizerStateEnded) {
        [[NewKTDetail sharedInstance]update:[self currentGanHuo]];
    }
}
#pragma mark -放大缩小
- (void)tmpPin:(UIPinchGestureRecognizer *)pinch {
    self.yesOrNo = YES;
    self.haveChanged = YES;
    self.changeView.layer.borderWidth = 0;
    UIImageView *iamgeView = (UIImageView *)pinch.view;
    self.changeView = iamgeView;
    iamgeView.transform = CGAffineTransformScale(iamgeView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1.0;
    if (pinch.state == UIGestureRecognizerStateEnded) {
        [[NewKTDetail sharedInstance]update:[self currentGanHuo]];
    }
}
#pragma mark - 点击成为第一响应者
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    self.haveChanged = YES;
    self.changeView.layer.borderWidth = 0;
    UIImageView *currentView = (UIImageView *)tap.view;
    self.changeView = currentView;
    currentView.layer.borderWidth = 2.0;
    currentView.layer.borderColor = kBordColor;
    [_resultScrollView bringSubviewToFront:currentView];
}
-(void)addTmpViewGesture:(UIImageView *)tmp{
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(tmpPin:)];
    [tmp addGestureRecognizer:pin];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panResult:)];
    [tmp addGestureRecognizer:panGesture];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];//点击成为第一响应者
    [tmp addGestureRecognizer:tap];
}
-(NewKTDetailModel *)currentGanHuo{
    NewKTDetailModel *model = [[NewKTDetailModel alloc]init];
    model.orignX = self.changeView.frame.origin.x;
    model.orignY = self.changeView.frame.origin.y;
    model.frameWidth = self.changeView.frame.size.width;
    model.frameHeight = self.changeView.frame.size.height;
    model.image = self.changeView.image;
    model.Tag = [NSString stringWithFormat:@"%ld",self.changeView.tag];
    model.currentYear = [_userDeft objectForKey:@"selectSTR"];
    model.currentDate = self.currentData;
    model.currentGan = self.currentGan;
    return model;
}
#pragma mark - 点击事件增加到衣架里面
- (void)addtoYiJia {

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.ganCollectionView) {
        self.haveChanged = YES;
        self.baoCun = NO;
        CGFloat resultWidth = arc4random()%100*3;
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.resultScrollView.contentOffset.x+resultWidth, 50, 100, 120)];
        self.changeView = tmpImageView;
        tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
        NewKTModel *model = self.ganArray[indexPath.row];
        tmpImageView.image = model.image;
        [_resultScrollView addSubview:tmpImageView];
        tmpImageView.userInteractionEnabled = YES;
        tmpImageView.tag = [[self currentTimer] longLongValue];
        [self addTmpViewGesture:tmpImageView];
        [[NewKTDetail sharedInstance]addDetailModel:[self currentGanHuo]];
    }
    if (collectionView ==self.collectionMenuView) {
        if (self.ganCollectionView) {
            if (self.yiJaiBOOL) {
                self.haveChanged = YES;
                self.baoCun = NO;
                CGFloat resultWidth = arc4random()%100*3;
                UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.resultScrollView.contentOffset.x+resultWidth, 50, 20, 100)];
                tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
                self.changeView = tmpImageView;
                tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
                
                tmpImageView.image = self.detailArray[indexPath.row];
                [_resultScrollView addSubview:tmpImageView];
                tmpImageView.userInteractionEnabled = YES;
                tmpImageView.tag = [[self currentTimer] longLongValue];
                [self addTmpViewGesture:tmpImageView];
                [[NewKTDetail sharedInstance]addDetailModel:[self currentGanHuo]];

            } else {
                self.baoCun = NO;
                if ( indexPath.row == (self.currentTag-4444)) {
                    ClothPhoto *cloth = self.detailArray[indexPath.row];
                    self.changeImage = cloth.backImage;
                    self.haveChanged = YES;
                    self.baoCun = NO;
                    CGFloat resultWidth = arc4random()%100*3;
                    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.resultScrollView.contentOffset.x+resultWidth, 50, 100, 120)];
                     tmpImageView.image = self.changeImage;
                    tmpImageView.contentMode = UIViewContentModeScaleAspectFit;
//                    NewKTModel *model = self.ganArray[indexPath.row];
//                    tmpImageView.image = model.image;
                    [_resultScrollView addSubview:tmpImageView];
                    tmpImageView.userInteractionEnabled = YES;
                    tmpImageView.tag = [[self currentTimer] longLongValue];
                    [self addTmpViewGesture:tmpImageView];
                    [[NewKTDetail sharedInstance]addDetailModel:[self currentGanHuo]];
                } else {
                    ClothPhoto *cloth = self.detailArray[indexPath.row];
                    self.changeImage = cloth.image;
                    [[NewKTDB sharedInstance]addDetailModel:[self newKTModel]];
                    [self.ganArray addObject:[self newKTModel]];
                    [self.ganCollectionView reloadData];
                 
                }
               
            }
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请点击加号增加杆数" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    if (collectionView == self.toolCollectioView) {
        if (self.xxx == YES) {
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UICollectionViewCell *cell = [self.toolCollectioView cellForItemAtIndexPath:selectedIndexPath];
            cell.layer.borderWidth = 0.0;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
            label.text = self.toolArr[0];
            label.backgroundColor = [UIColor colorWithRed:135.0/255 green:135.0/255 blue:135.0/255 alpha:1.0];
            label.textColor = [UIColor whiteColor];
            [cell addSubview:label];
            self.xxx = NO;
        }
        if (self.haveChanged == YES) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先保存" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            cell.layer.borderWidth = 2.0;
            cell.layer.borderColor = [[UIColor colorWithRed:225.0/255 green:41.0/255 blue:21.0/255 alpha:1.0]CGColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
            label.text = self.toolArr[indexPath.row];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:225.0/255 green:41.0/255 blue:21.0/255 alpha:1.0];
            [cell addSubview:label];
            if (indexPath.row == 0) {
                self.mainDetailView.hidden = NO;
                [self.ganCollectionView removeFromSuperview];
                self.ganCollectionView = nil;
                self.ganView.hidden = YES;
                self.detailStr = @"主题";
                self.timerTag = [self currentTimer];
                [self addImageWenZi];
            }else{
                [_titleBut removeFromSuperview];
                _titleBut = nil;
                [_imageView removeFromSuperview];
                _imageView = nil;
                [_lineView removeFromSuperview];
                _lineView = nil;
                [self.ganCollectionView removeFromSuperview];
                self.ganCollectionView = nil;
                self.currentGan = self.ganNumArr[indexPath.row-1];//当前选择的是第几杆
                self.detailStr = self.currentGan;
                self.timerTag = [self currentTimer];
                [self gogo];
                [self tgo];
                self.detailArray = nil;
                self.mainDetailView.hidden = YES;
                [self createGanCollection];
                [self.view addSubview:self.ganView];
                if (self.isEdit == YES) {
                    NSString *strs = [_userDeft objectForKey:self.yearAndDate][indexPath.row-1];
                    self.ganDetailArr = nil;
                    [self.ganView removeFromSuperview];
                    self.ganView = nil;
                    [self.view addSubview:self.ganView];
                    self.ganDetailArr = [[NewKTDetail sharedInstance]fetchKTByYear:self.currentYear andDate:self.currentData andGan:strs];
                    NSInteger num = self.ganDetailArr.count;
                    for (NSInteger i = 0; i < num; i ++) {
                        NewKTDetailModel *model = self.ganDetailArr[i];
                        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(model.orignX, model.orignY, model.frameWidth, model.frameHeight)];
                        imageV.contentMode = UIViewContentModeScaleAspectFit;
                        imageV.userInteractionEnabled = YES;
                        imageV.image = model.image;
                        imageV.tag = [model.Tag longLongValue];
                        [self addTmpViewGesture:imageV];
                        [_resultScrollView addSubview:imageV];
                    }
                }
                self.ganView.hidden = NO;
            }
            [self.view bringSubviewToFront:self.addGanBtn];
            [self.view bringSubviewToFront:self.toolCollectioView];
        }
        
    }
        
}
#pragma mark - 货品数据
-(NewKTModel *)newKTModel{
    NewKTModel *model = [[NewKTModel alloc]init];
    model.image = self.changeImage;
    model.currentYear = self.currentYear;
    model.currentDate = self.currentData;
    return model;
}
#pragma mark - 取时间tag值
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
    NSString *newstr = [NSString stringWithString:str1];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", newstr];
    return timeLocal;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.toolCollectioView) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderWidth = 0.0;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
        label.text = self.toolArr[indexPath.row];
        label.backgroundColor = [UIColor colorWithRed:135.0/255 green:135.0/255 blue:135.0/255 alpha:1.0];
        label.textColor = [UIColor whiteColor];
        [cell addSubview:label];
    }
}
#pragma mark - 菜单单栏
//添加菜单栏
-(void)addTableMenuView{
    self.goBackView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-200, 0, 200, 50)];
    _goBackView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    _goBackView.hidden = YES;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(10, 10, 50, 30);
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor colorWithRed:253.0/255 green:137.0/255 blue:24.0/255 alpha:1.0] forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [back addTarget:self action:@selector(gogo) forControlEvents:UIControlEventTouchUpInside];
    [_goBackView addSubview:back];
    [self.view addSubview:_goBackView];
    
    self.viewFrame = CGRectMake(kWidth-200, 45, 200, kHeight);
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
    self.currentTag = 0;
}
-(void)gogo{
    self.goBackView.hidden = YES;
    self.tableMenuView.hidden = YES;
}

#pragma mark -tableView 的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    self.yesOrNo = YES;
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"衣架"]) {
        self.detailArray = nil;
        UIImage *image = [UIImage imageNamed:@"kujia.png"];
        UIImage *image1 = [UIImage imageNamed:@"yijia1.png"];
        //UIImage *ceGuaImage = [UIImage imageNamed:@"cegua1.png"];
        [self.detailArray addObject:image];
        [self.detailArray addObject:image1];
        //[self.detailArray addObject:ceGuaImage];
        self.yiJaiBOOL = YES;
    } else {
        self.yiJaiBOOL = NO;
    }
    self.didSelectType = self.dataArray[indexPath.row];
    [self createDetailData];
    [self addCollectionDetail];

   
}

//详细的数据
-(void)createDetailData{
    NSString *yearString = [_userDeft objectForKey:@"selectSTR"];
    if (!self.yiJaiBOOL) {
        self.detailArray = [[DataBase shareInstance]fetchBySession:yearString andType:_didSelectType];
    }
    
}
//添加详细品类
-(void)addCollectionDetail{
    self.detailHeadView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-200, 0, 200, 35)];
    _detailHeadView.backgroundColor = [UIColor colorWithRed:83.0/255 green:83.0/255 blue:83.0/255 alpha:1.0];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(10, 10, 25, 25);
    [back setBackgroundImage:[UIImage imageNamed:@"return01"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(tgo) forControlEvents:UIControlEventTouchUpInside];
    [_detailHeadView addSubview:back];
    self.detailMidLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 40)];
    _detailMidLable.text = self.didSelectType;
    _detailMidLable.textColor = [UIColor whiteColor];
    _detailMidLable.textAlignment = NSTextAlignmentCenter;
    _detailMidLable.font = [UIFont systemFontOfSize:20];
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
#pragma mark - 杆的collection
- (void)createGanCollection {
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
    layOut.itemSize = CGSizeMake(120, 150);
    layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layOut.minimumInteritemSpacing = 0;
    layOut.minimumLineSpacing = 0;
    layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.ganCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 300.1) collectionViewLayout:layOut];
    _ganCollectionView.backgroundColor = [UIColor whiteColor];
    _ganCollectionView.delegate = self;
    _ganCollectionView.dataSource = self;
    [_ganCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ganCellID"];
    [self.view addSubview:_ganCollectionView];
}

#pragma mark - collection类型的返回按钮
-(void)tgo{
    self.detailHeadView.hidden = YES;
    self.collectionMenuView.hidden = YES;
}
#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.changeView.layer.borderWidth = 0;
    self.changeLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.changeZhuti.layer.borderWidth = 0;
}
#pragma mark - 状态栏
-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
-(void)viewDidDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark -拖动手势
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (collectionView == self.ganCollectionView) {
        return YES;
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.ganCollectionView) {
        return YES;
    }
    return NO;
}
- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.ganCollectionView];
    NSLog(@"%f %f",location.x,location.y);
    NSIndexPath *indexPath = [self.ganCollectionView indexPathForItemAtPoint:location];
    
    NSLog(@"%@",indexPath);
    static UIView *snapshot = nil;//把长按的cell加载到snapshot上
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if(indexPath){
                sourceIndexPath = indexPath;
                UICollectionViewCell *cell = [self.ganCollectionView cellForItemAtIndexPath:indexPath];
                snapshot = [self customSnapshothotFromeView:cell];//快照
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.ganCollectionView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05,1.05);
                    snapshot.alpha = 0.98;
                    cell.hidden = YES;//长按是把当前的cell影藏掉
                }completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint center = snapshot.center;
            center.y = location.y;
            center.x = location.x;
            snapshot.center = center;
            if(indexPath && ![indexPath isEqual:sourceIndexPath]){
             
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            [self.ganArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:indexPath.row ];
           // NSLog(@"%ld",indexPath.row);
            UICollectionViewCell *cell = [self.ganCollectionView cellForItemAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            //            [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
            sourceIndexPath =indexPath;
        }
        default:
        {
            UICollectionViewCell *cell =[self.ganCollectionView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
            }completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                cell.hidden = NO;
                snapshot = nil;
            }];
            [self.ganCollectionView reloadData];
            sourceIndexPath = nil;
        }
            break;
    }
}
- (UIView *)customSnapshothotFromeView:(UIView *)inputView{
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}
-(void)viewDidAppear:(BOOL)animated{
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewCell *cell = [self.toolCollectioView cellForItemAtIndexPath:selectedIndexPath];
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [[UIColor colorWithRed:225.0/255 green:41.0/255 blue:21.0/255 alpha:1.0]CGColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    label.text = self.toolArr[0];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:225.0/255 green:41.0/255 blue:21.0/255 alpha:1.0];
    [cell addSubview:label];
    self.xxx = YES;//默认选中的是第一个cell
}

@end
