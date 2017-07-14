//
//  ImageViewController.m
//  EditImage-Demo
//
//  Created by 尊旅环球游 on 2017/7/12.
//  Copyright © 2017年 chk. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    
    UIView *viewMask = [[UIView alloc] initWithFrame:self.view.bounds];
    viewMask.backgroundColor = [UIColor blackColor];
    viewMask.alpha = 0.4;
    [self.view addSubview:viewMask];
    viewMask.userInteractionEnabled = NO;
    
    //镂空圆形
    UIBezierPath *mainPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, SCREEN_HEIGHT / 2 - SCREEN_WIDTH / 2, SCREEN_WIDTH, SCREEN_WIDTH) cornerRadius:SCREEN_WIDTH / 2];
    [mainPath appendPath:[path bezierPathByReversingPath]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = mainPath.CGPath;
    viewMask.layer.mask = shapeLayer;
    
    [self addButton];
}

- (void)addButton {
    for (int i = 0; i < 2; i++) {
        CGRect frame = CGRectMake(0 + i * (SCREEN_WIDTH - 50), SCREEN_HEIGHT - 60, 50, 60);
        NSString *title = i == 0 ? @"取消" : @"确定";
        UIButton *btn = [self createButton:frame title:title tag:i];
        [self.view addSubview:btn];
    }
}


- (UIButton *)createButton:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnAction:(UIButton *)btn {
    if (btn.tag == 0) {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIImage *image = [self cropImage];
        if (self.updateImage) {
            self.updateImage(image);
        }
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)setImage:(UIImage *)image {
    _image = image;
    
    [self addImage:image];
}

- (void)addImage:(UIImage *)image {
    
    CGFloat scale = image.size.height / image.size.width;
    CGFloat height = SCREEN_WIDTH * scale;
    CGFloat y = (height - SCREEN_WIDTH) / 2.f;
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = CGRectMake(0,  0, SCREEN_WIDTH, height);
    self.imageView.userInteractionEnabled = YES;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
    self.scrollView.contentOffset = CGPointMake(0, y);
    [self.scrollView addSubview:self.imageView];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH) / 2.f, SCREEN_WIDTH, SCREEN_WIDTH)];
        _scrollView.delegate = self;
        _scrollView.bouncesZoom = YES;
        _scrollView.zoomScale = 1;
        _scrollView.maximumZoomScale = 3;
        _scrollView.minimumZoomScale = 1;
        _scrollView.layer.masksToBounds = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


- (UIImage *)cropImage {
    
    CGPoint offset = _scrollView.contentOffset;

    CGFloat zoom = _imageView.frame.size.width/self.image.size.width;
  
    zoom = zoom / [UIScreen mainScreen].scale;
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;
    if (_imageView.frame.size.height < _scrollView.frame.size.height) {
        offset = CGPointMake(offset.x + (width - _imageView.frame.size.height)/2.0, 0);
        width = height = _imageView.frame.size.height;
    }
    
    CGRect rec = CGRectMake(offset.x/zoom, offset.y/zoom,width/zoom,height/zoom);
    CGImageRef imageRef =CGImageCreateWithImageInRect([self.image CGImage],rec);
    UIImage * image = [[UIImage alloc]initWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return image;
}


@end
