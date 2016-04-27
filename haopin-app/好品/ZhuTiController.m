//
//  ZhuTiController.m
//  haopin
//
//  Created by ww on 16/3/28.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ZhuTiController.h"
#import "ZhuTiDB.h"//截图
#import "TopicsDB.h"//主题
#import "ZhuTiModel.h"//主题model
#import <MobileCoreServices/MobileCoreServices.h>
#import "ImageTools.h"

#define kBordColor [[UIColor colorWithRed:84.0/255 green:207.0/255 blue:109.0/255 alpha:1.0]CGColor]
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface ZhuTiController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic)UILabel *changeLabel;//当前编辑的label
@property(nonatomic)UIImageView *changeZhuti;//当前编辑的主题图片
@property(nonatomic,copy)NSString *whatView;//判断是文字还是图片
@property (nonatomic) UIView *titleView;
@property (nonatomic) UITextView *titleTextView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIButton *titleBut;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UIView *mainDetailView;
@property (nonatomic) UIImageView *currentZTPicture;//当前主题图片
@property(nonatomic)BOOL editBool;//判断文字是不是修改的
@property(nonatomic)BOOL yesOrNo;//返回的时候判断，是不是修改过，修改过就弹出警告框
//@property (nonatomic, copy) NSString *currentData;
//@property (nonatomic, copy) NSString *currentYear;
@property (nonatomic,copy) NSString *STR;//当前的年份
@property (nonatomic) BOOL haveChanged;
@property (nonatomic) UIImageView *changeView;
@property (nonatomic) UIImage *changeImage;
@end

@implementation ZhuTiController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.title = @"主题";
    [self addBGView];
    [self creatData];
}
- (void)creatData {
    {
        NSMutableArray *quArr = [[TopicsDB sharedInstance]fetchKTByYear:self.currentYear andDate:self.currentData];
        for (NSInteger i = 0; i < quArr.count; i ++) {
            TopicsModel *model = quArr[i];
            if (model.detail == nil) {
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(model.orignX, model.orignY, model.frameWidth, model.frameHeight)];
                image.userInteractionEnabled = YES;
                image.contentMode = UIViewContentModeScaleAspectFit;
                image.image = model.image;
                image.UUTag = model.Tag;
                [self addGesture:image];
                [_mainDetailView addSubview:image];
            }else{
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(model.orignX, model.orignY, model.frameWidth, model.frameHeight)];
                label.userInteractionEnabled = YES;
                label.text = model.detail;
                label.textColor = [UIColor colorWithWhite:0 alpha:0.5];
                CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil].size;
                CGRect frame = label.frame;
                frame.size.height = textSize.height;
                label.layer.borderWidth = 1.0;
                label.backgroundColor = [UIColor whiteColor];
                label.layer.borderColor = [UIColor grayColor].CGColor;
                label.frame = frame;
                label.numberOfLines  = 0;
                label.UUTag = model.Tag;
                [self addLabelGesture:label];
                [_mainDetailView addSubview:label];
            }
        }
        
    }

}
-(void)addBGView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainDetailView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kWidth-200, kHeight)];
    _mainDetailView.backgroundColor = [UIColor whiteColor];
    _mainDetailView.userInteractionEnabled = YES;
    [self.view addSubview:_mainDetailView];
    _titleLabel.frame = CGRectMake(2, kHeight -285, kWidth -  200, 100);
    [_mainDetailView addSubview:_titleLabel];
    [self addImageWenZi];
    UIButton *deleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleButton.frame = CGRectMake(0, 0, 80, 44);
    [deleButton setImage:[[UIImage imageNamed:@"delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [deleButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleButton addTarget:self action:@selector(deletes:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithCustomView:deleButton];
    
    self.navigationItem.rightBarButtonItem = item3;
}
#pragma mark - 删除事件
- (void)deletes:(UIButton *)button {
    NSLog(@"ww");
    if ([self.whatView isEqualToString:@"文字"]) {
        [[TopicsDB sharedInstance]deleteByTag:self.changeLabel.UUTag];
        [self.changeLabel removeFromSuperview];
    }else if ([self.whatView isEqualToString:@"主图"]){
        [[TopicsDB sharedInstance]deleteByTag:self.changeZhuti.UUTag];
        [self.changeZhuti removeFromSuperview];
    }
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
    model.Tag = self.changeLabel.UUTag;
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
    model.Tag = self.changeZhuti.UUTag;
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
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.UUTag = [self currentTimer];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor whiteColor];
        self.changeLabel = label;
        label.text = _titleTextView.text;
        label.textColor = [UIColor colorWithWhite:0 alpha:0.4];
        CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil].size;
        CGRect frame = label.frame;
        frame.size.height = textSize.height;
        label.frame = frame;
        [self addLabelGesture:label];
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
    currentLable.layer.borderColor = [UIColor darkGrayColor].CGColor;
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
        UIImage *small = [[ImageTools shareTool]resizeImageToSize:CGSizeMake(150, 180) sizeOfImage:image];
        
        CGFloat resultWidth = arc4random()%100*3;
        UIImageView *zhuTiImage = [[UIImageView alloc] initWithFrame:CGRectMake(100+resultWidth, 10, 150, 150)];
        zhuTiImage.userInteractionEnabled = YES;
        zhuTiImage.contentMode = UIViewContentModeScaleAspectFit;
        zhuTiImage.image = small;
        zhuTiImage.UUTag = [self currentTimer];
        [self addGesture:zhuTiImage];
        self.changeZhuti = zhuTiImage;
        [[TopicsDB sharedInstance]addDetailModel:[self currentTopicTu]];
        [_mainDetailView addSubview:zhuTiImage];
        self.haveChanged = YES;
        self.yesOrNo = YES;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//给当前操作的视图添加手势
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
    current.layer.borderColor = [UIColor darkGrayColor].CGColor;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
