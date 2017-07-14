//
//  ViewController.m
//  EditImage-Demo
//
//  Created by 尊旅环球游 on 2017/7/12.
//  Copyright © 2017年 chk. All rights reserved.
//

#import "ViewController.h"
#import "TapImageView.h"
#import "ImageViewController.h"
#import "UIImage+Crop.h"

@interface ViewController () <TapImageViewDelegate>

@property (nonatomic,strong) TapImageView *icon;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.icon];
    
}


- (void)chk_imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    ImageViewController *vc = [[ImageViewController alloc] init];
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = image.size.height * (width/image.size.width);
    vc.image = [image resizeImageWithSize:CGSizeMake(width, height)];//对原图进行处理
    
    weak(self);
    vc.updateImage = ^(UIImage *newIcon) {
        strong(self);
        self.icon.image = newIcon;
    };
    
    [picker presentViewController:vc animated:YES completion:nil];
}



- (TapImageView *)icon {
    if (_icon == nil) {
        _icon = [[TapImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, 200, 200, 200)];
        _icon.layer.cornerRadius = 100.f;
        _icon.clipsToBounds = YES;
        _icon.delegate = self;
        _icon.image = [UIImage imageNamed:@"head-portrait-none"];
    }
    return _icon;
}


@end
