//
//  ChangeColorController.m
//  haopin
//
//  Created by 朱明科 on 16/3/29.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "ChangeColorController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kColor  [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1.0]
@interface ChangeColorController ()
@property(nonatomic)UISlider *sXSlider;
@property(nonatomic)UISlider *bHDSlider;
@property(nonatomic)UISlider *lDSlider;
@property(nonatomic)UISlider *hbsSlider;
@property(nonatomic)UISwitch *hbsSwitch;
@property(nonatomic)CIFilter *sXFilter;
@property(nonatomic)CIFilter *bHDFilter;
@property(nonatomic)CIFilter *lDFilter;
@property(nonatomic)CIFilter *hbsFilter;
@property(nonatomic)CIFilter *heibsFilter;
@property(nonatomic)CIContext *context;
@property(nonatomic)CIImage *ciImage;
@property(nonatomic)UIImage *tmpImage;
@end

@implementation ChangeColorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.kImageView.userInteractionEnabled = NO;
    [self createButton];
    [self initUI];
    [self initFilter];
}
-(void)createButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [backButton setTitleColor:kColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item1;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(0, 0, 44, 44);
    [doneButton setTitle:@"保存" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [doneButton setTitleColor:kColor forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = item2;
}
-(void)back:(UIButton *)button{
    if (self.isAddColor) {
    }else{
        if (self.doneHandler) {
            UIImageView *ysImageViwe = [[UIImageView alloc]init];
            ysImageViwe.frame = self.kImageView.frame;
            ysImageViwe.image = self.ysImage;
            self.doneHandler(ysImageViwe);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)done:(UIButton *)button{
    if (self.doneHandler) {
        self.doneHandler(self.kImageView);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth-320, kHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:250.0/255 green:250.0/255 blue:251.0/255 alpha:1.0];
    [self.view addSubview:bgView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-320, 0, 1, kHeight)];
    lineView.backgroundColor = bgView.backgroundColor;
    [self.view addSubview:lineView];
    
    self.kImageView.frame = CGRectMake(150, 100, 400, kHeight-270);
    [self.view addSubview:_kImageView];
    
    UILabel *jcLable = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-320, 25, 320, 30)];
    jcLable.text = @"基础";
    jcLable.font = [UIFont systemFontOfSize:16];
    jcLable.textAlignment = NSTextAlignmentCenter;
    jcLable.textColor = kColor;
    //[self.view addSubview:jcLable];
    
    UILabel *sxLable = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-310, 25, 60, 30)];
    sxLable.text = @"色相:";
    sxLable.font = [UIFont systemFontOfSize:14];
    sxLable.textAlignment = NSTextAlignmentLeft;
    sxLable.textColor = kColor;
    [self.view addSubview:sxLable];
#pragma mark -色相滑动条
    self.sXSlider = [[UISlider alloc]initWithFrame:CGRectMake(kWidth-310, 65, 300, 20)];
    _sXSlider.minimumValue = -3.14;
    _sXSlider.maximumValue = 3.14;
    _sXSlider.value = 0;
    [_sXSlider addTarget:self action:@selector(sXSliderAction:) forControlEvents:UIControlEventValueChanged];
    [_sXSlider addTarget:self action:@selector(endChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sXSlider];
    
    UILabel *bhdLable = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-310, 105, 60, 30)];
    bhdLable.text = @"饱和度:";
    bhdLable.font = [UIFont systemFontOfSize:14];
    bhdLable.textAlignment = NSTextAlignmentLeft;
    bhdLable.textColor = kColor;
    [self.view addSubview:bhdLable];
#pragma mark -饱和度滑动条
    self.bHDSlider = [[UISlider alloc]initWithFrame:CGRectMake(kWidth-310, 145, 300, 20)];
    _bHDSlider.minimumValue = 0.25;
    _bHDSlider.maximumValue = 4;
    _bHDSlider.value = 0;
    [_bHDSlider addTarget:self action:@selector(bHDSliderAction:) forControlEvents:UIControlEventValueChanged];
    [_bHDSlider addTarget:self action:@selector(endChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bHDSlider];
    
    UILabel *ldLable = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-310, 185, 60, 30)];
    ldLable.text = @"明度:";
    ldLable.font = [UIFont systemFontOfSize:14];
    ldLable.textAlignment = NSTextAlignmentLeft;
    ldLable.textColor = kColor;
    [self.view addSubview:ldLable];
#pragma mark - 亮度滑动条
    self.lDSlider = [[UISlider alloc]initWithFrame:CGRectMake(kWidth-310, 225, 300, 20)];
    _lDSlider.minimumValue = -10.0;
    _lDSlider.maximumValue = 10.0;
    _lDSlider.value = 0.0;
    [_lDSlider addTarget:self action:@selector(lDSliderAction:) forControlEvents:UIControlEventValueChanged];
    [_lDSlider addTarget:self action:@selector(endChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lDSlider];
    
    UILabel *heibsLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-310, 265, 100, 30)];
    heibsLabel.text = @"黑白色:";
    heibsLabel.font = [UIFont systemFontOfSize:14];
    heibsLabel.textAlignment = NSTextAlignmentLeft;
    heibsLabel.textColor = kColor;
    [self.view addSubview:heibsLabel];
#pragma mark - 黑白色滑块儿
    self.hbsSlider = [[UISlider alloc]initWithFrame:CGRectMake(kWidth-310, 305, 300, 20)];
    _hbsSlider.minimumValue = 0;
    _hbsSlider.maximumValue = 1;
    _hbsSlider.value = 0;
    [_hbsSlider addTarget:self action:@selector(hbsSliderAction:) forControlEvents:UIControlEventValueChanged];
    [_hbsSlider addTarget:self action:@selector(endChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hbsSlider];

    UILabel *hbsLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-310, 345, 100, 30)];
    hbsLabel.text = @"互补色:";
    hbsLabel.font = [UIFont systemFontOfSize:14];
    hbsLabel.textAlignment = NSTextAlignmentLeft;
    hbsLabel.textColor = kColor;
    [self.view addSubview:hbsLabel];
#pragma mark - 互补色开关
    self.hbsSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(kWidth-210, 345, 50, 50)];
    [_hbsSwitch addTarget:self action:@selector(hbsSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_hbsSwitch];
    
    UIButton *ytButtton = [UIButton buttonWithType:UIButtonTypeSystem];
    ytButtton.frame = CGRectMake(kWidth-260, 410, 200, 50);
    ytButtton.backgroundColor = [UIColor colorWithRed:244.0/255 green:240.0/255 blue:240.0/255 alpha:1.0];
    [ytButtton setTitle:@"还原" forState:UIControlStateNormal];
    [ytButtton setTitleColor:kColor forState:UIControlStateNormal];
    [ytButtton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [ytButtton addTarget:self action:@selector(huanyuan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ytButtton];
}
-(void)initFilter{
    self.context = [CIContext contextWithOptions:nil];
    UIImage *image = self.kImageView.image;
    NSData *data = UIImagePNGRepresentation(image);
    self.ciImage = [CIImage imageWithData:data];
    
    self.sXFilter = [CIFilter filterWithName:@"CIHueAdjust"];//色相
    self.bHDFilter = [CIFilter filterWithName:@"CIGammaAdjust"];//饱和度
    self.lDFilter = [CIFilter filterWithName:@"CIExposureAdjust"];//亮度
    self.hbsFilter = [CIFilter filterWithName:@"CIColorInvert"];//互补色
    self.heibsFilter = [CIFilter filterWithName:@"CIColorMonochrome"];//黑白度
}
//色相
-(void)sXSliderAction:(UISlider *)slider{
//    _bHDSlider.value = 0;
//    _lDSlider.value = 0.0;
//    _hbsSlider.value = 0;
    float slideValue = slider.value;
    // 设置过滤器参数
    [_sXFilter setValue:_ciImage forKey:@"inputImage"];
    [_sXFilter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputAngle"];
    
    // 得到过滤后的图片
    CIImage *outputImage = [_sXFilter outputImage];
    // 转换图片
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    self.tmpImage = newImg;
    // 显示图片
    [_kImageView setImage:newImg];
    // 释放C对象
    CGImageRelease(cgimg);
}
//亮度
-(void)lDSliderAction:(UISlider *)slider{
//    _sXSlider.value = 0;
//    _bHDSlider.value = 0;
//    _hbsSlider.value = 0;
    float slideValue = slider.value;
    
    // 设置过滤器参数
    [_lDFilter setValue:_ciImage forKey:kCIInputImageKey];
    [_lDFilter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputEV"];
    
    // 得到过滤后的图片
    CIImage *outputImage = [_lDFilter outputImage];
    // 转换图片
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    self.tmpImage = newImg;
    // 显示图片
    [_kImageView setImage:newImg];
    // 释放C对象
    CGImageRelease(cgimg);
}
//饱和度
-(void)bHDSliderAction:(UISlider *)slider{
    
//    _sXSlider.value = 0;
//    _lDSlider.value = 0.0;
//    _hbsSlider.value = 0;
    float slideValue = slider.value;
    // 设置过滤器参数
    [_bHDFilter setValue:_ciImage forKey:@"inputImage"];
    [_bHDFilter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputPower"];
    
    // 得到过滤后的图片
    CIImage *outputImage = [_bHDFilter outputImage];
    // 转换图片
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    self.tmpImage = newImg;
    // 显示图片
    [_kImageView setImage:newImg];
    // 释放C对象
    CGImageRelease(cgimg);
}
//互补色
-(void)hbsSwitchAction:(UISwitch *)switchs{
    if (switchs.on == YES) {
//        _sXSlider.value = 0;
//        _bHDSlider.value = 0;
//        _lDSlider.value = 0.0;
//        _hbsSlider.value = 0;
        // 设置过滤器参数
        [_hbsFilter setValue:_ciImage forKey:@"inputImage"];
       
        // 得到过滤后的图片
        CIImage *outputImage = [_hbsFilter outputImage];
        // 转换图片
        CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        self.tmpImage = newImg;
        // 显示图片
        [_kImageView setImage:newImg];
        // 释放C对象
        CGImageRelease(cgimg);
    }else{
        self.kImageView.image = self.ysImage;
    }
}
//黑白色
-(void)hbsSliderAction:(UISlider *)slider{
//    _sXSlider.value = 0;
//    _bHDSlider.value = 0;
//    _lDSlider.value = 0.0;
    float slideValue = slider.value;
    // 设置过滤器参数
    [_heibsFilter setValue:_ciImage forKey:@"inputImage"];
    [_heibsFilter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputIntensity"];
    
    // 得到过滤后的图片
    CIImage *outputImage = [_heibsFilter outputImage];
    // 转换图片
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    self.tmpImage = newImg;
    // 显示图片
    [_kImageView setImage:newImg];
    // 释放C对象
    CGImageRelease(cgimg);
}
-(void)endChange{
    self.context = [CIContext contextWithOptions:nil];
    UIImage *image = self.tmpImage;
    NSData *data = UIImagePNGRepresentation(image);
    self.ciImage = [CIImage imageWithData:data];
}
//还原
-(void)huanyuan:(UIButton *)button{
    self.kImageView.image = self.ysImage;
    _sXSlider.value = 0;
    _bHDSlider.value = 0;
    _lDSlider.value = 0.0;
    _hbsSlider.value = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
