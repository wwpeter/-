//
//  AddClothController.m
//  好品
//
//  Created by 朱明科 on 15/12/18.
//  Copyright © 2015年 zhumingke. All rights reserved.
//

#import "AddClothController.h"
#import "TypeTableController.h"
#import "DesignorControllerViewController.h"
#import "ClothPhoto.h"
#import "DataBase.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageTools.h"
#import "TOCropViewController.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
@interface AddClothController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraFrontView;//正面背景
@property (weak, nonatomic) IBOutlet UIImageView *cameraSideView;//侧面背景

@property (weak, nonatomic) IBOutlet UIButton *showTypeButton;//显示品类
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *designText;//设计师

@property(nonatomic,copy)NSString *typeString;//品类
@property(nonatomic,copy)NSString *designorString;//设计师
@property(nonatomic)NSUserDefaults *userDeft;
@property(nonatomic,copy)NSString *fOrPStr;//判断是正面还是侧面
@property(nonatomic)NSInteger keyBoardHeight;//键盘高度
@property(nonatomic)BOOL isChange;
@property(nonatomic)BOOL isCammer;
@end

@implementation AddClothController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.userDeft = [NSUserDefaults standardUserDefaults];
    [self createUI];
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    [self addGesture];

}
-(void)addGesture{
    _frontImageView.contentMode = UIViewContentModeScaleAspectFit;
    _profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    _frontImageView.layer.borderWidth = _profileImageView.layer.borderWidth = 1.0;
    _frontImageView.layer.borderColor = _profileImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    UILongPressGestureRecognizer *longPressOfFront = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress1:)];
//    longPressOfFront.minimumPressDuration = 0.3;
//    [_frontImageView addGestureRecognizer:longPressOfFront];
//    UILongPressGestureRecognizer *longPressOfProfile = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress2:)];
//    longPressOfProfile.minimumPressDuration = 0.3;
//    [_profileImageView addGestureRecognizer:longPressOfProfile];
}
/**
-(void)longpress1:(UILongPressGestureRecognizer *)longpress{
    if (_frontImageView.image) {
        [self showAlertController];
        self.fOrPStr = @"isFront";
    }
}
-(void)longpress2:(UILongPressGestureRecognizer *)longpress{
    if (_profileImageView.image) {
        [self showAlertController];
        self.fOrPStr = @"isProfile";
    }
}
 */
-(void)createUI{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kWidth, 49)];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.userInteractionEnabled = YES;
    [self.view addSubview:titleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(15, 15, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"trturn02"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
    
    [self.showTypeButton addTarget:self action:@selector(bodsButton:) forControlEvents:UIControlEventTouchUpInside];//类型
    [self.typeBtn addTarget:self action:@selector(bodsButton:) forControlEvents:UIControlEventTouchUpInside];//biaoti类型
}
-(void)backView{
    if (self.isChange == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你确定放弃修改？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//保存按钮
- (IBAction)addButton:(id)sender {
    if (self.typeString == nil | self.frontImageView.image == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请检查信息是否完整！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已保存！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [[DataBase shareInstance]insertCloth:[self currentCloth]];
        if (self.handler) {
            self.handler(@"YES");
        }
        [self presentViewController:alert animated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:alert repeats:NO];
    }
}
- (IBAction)designBtn:(id)sender {
    DesignorControllerViewController *designController = [[DesignorControllerViewController alloc]init];
    [designController setHaveSelectRowHandler:^(NSString *str) {
        self.designorString = str;
        self.designText.text = str;
        self.isChange = YES;
    }];
    [self presentViewController:designController animated:YES completion:nil];
}

-(void)timer:(NSTimer *)timer{
    UIAlertController *alert = timer.userInfo;
    [alert dismissViewControllerAnimated:YES completion:nil];
    [timer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(ClothPhoto *)currentCloth{
    ClothPhoto *cloth = [[ClothPhoto alloc]init];
    cloth.ind = [self currentTimer];
    cloth.year = [_userDeft objectForKey:@"selectSTR"];
    cloth.type = self.typeString;
    cloth.image = self.frontImageView.image;
    cloth.backImage = self.profileImageView.image;
    cloth.designor = self.designorString;
    return cloth;
}
//类型选项
- (IBAction)bodsButton:(id)sender {
    TypeTableController *typeTabController = [[TypeTableController alloc]init];
    [typeTabController setHaveSelectRowHandler:^(NSString *str) {
        self.typeString = str;
        [self.showTypeButton setTitle:str forState:UIControlStateNormal];
        //
        self.isChange = YES;
    }];
    [self presentViewController:typeTabController animated:YES completion:nil];
}
-(NSString *)currentTimer{
    //获取当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    return [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld",(long)year,(long)month,(long)day,(long)hour,(long)minute,(long)second];
}
//
//
//点击正面
//手势
- (IBAction)tapFront:(UITapGestureRecognizer *)tap{
    self.fOrPStr = @"isFront";
//    if (self.frontImageView.image) {
//        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:self.frontImageView.image];
//        cropController.delegate = self;
//        [self presentViewController:cropController animated:YES completion:nil];
//    }else{
//        [self showAlertController];
//    }
    [self showAlertController];
}
//
//
//点击侧面
//手势
- (IBAction)tapProfile:(UITapGestureRecognizer *)tap{
    self.fOrPStr = @"isProfile";
//    if (self.profileImageView.image) {
//        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:self.profileImageView.image];
//        cropController.delegate = self;
//        [self presentViewController:cropController animated:YES completion:nil];
//    }else{
//        [self showAlertController];
//    }
    [self showAlertController];
}
-(void)showAlertController{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"资源选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *libaryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }];
    UIAlertAction *cammerAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loadImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.fOrPStr = nil;
    }];
    [alertController addAction:libaryAction];
    [alertController addAction:cammerAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//图片来源
//相册或则相机
- (void)loadImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = sourceType;
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - 剪切 代理 -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    if ([self.fOrPStr isEqualToString:@"isFront"]) {
        self.frontImageView.image = image;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        CGRect viewFrame = [self.view convertRect:self.frontImageView.frame toView:self.navigationController.view];
        [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:viewFrame completion:^{
            self.frontImageView.image = image;
        }];
    }else{
        self.profileImageView.image = image;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        CGRect viewFrame = [self.view convertRect:self.profileImageView.frame toView:self.navigationController.view];
        [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:viewFrame completion:^{
            self.profileImageView.image = image;
        }];
    }
}
#pragma mark - <UIImagePickerControllerDelegate>
//点击Cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.fOrPStr = nil;
}
//点击Use image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //UIImage *small = [[ImageTools shareTool]imageCompressForWidth:image targetWidth:image.size.width/10];
    UIImage *small = [[ImageTools shareTool]thumbnailWithImageWithoutScale:image size:CGSizeMake(400, 400)];
    if ([self.fOrPStr isEqualToString:@"isFront"]) {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:small];
        cropController.delegate = self;
        [picker presentViewController:cropController animated:YES completion:nil];
        self.frontImageView.image = small;
        self.cameraFrontView.image = nil;
        
    }else{
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:small];
        cropController.delegate = self;
        [picker presentViewController:cropController animated:YES completion:nil];
        self.profileImageView.image = small;
        self.cameraSideView.image = nil;
    }
    self.isChange = YES;
    //[picker dismissViewControllerAnimated:YES completion:nil];
}
@end
