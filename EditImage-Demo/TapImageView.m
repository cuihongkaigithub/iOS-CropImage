//
//  TapImageView.m
//  ZLGlobalTravel
//
//  Created by 尊旅环球游 on 2017/6/16.
//  Copyright © 2017年 尊旅环球游. All rights reserved.
//

#import "TapImageView.h"
#import <AVFoundation/AVFoundation.h>

@interface TapImageView () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIViewController *vc;

@end

@implementation TapImageView


- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [self addTapGestureRecognizer];
}

- (void)addTapGestureRecognizer {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *openPhotoLibrary = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPickerImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alert addAction:openPhotoLibrary];
    
    UIAlertAction *openCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPickerImage:UIImagePickerControllerSourceTypeCamera];
    }];
    [alert addAction:openCamera];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [self.vc presentViewController:alert animated:YES completion:nil];
}

- (void)showPickerImage:(UIImagePickerControllerSourceType)type {
    
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied) {
        NSString *str = type == UIImagePickerControllerSourceTypePhotoLibrary ? @"相册" : @"相机";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"应用%@权限受限\n请在设置中启用",str] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self.vc presentViewController:alert animated:YES completion:nil];
    } else {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
//        pickerImage.allowsEditing = YES;
        pickerImage.delegate = self;
        pickerImage.sourceType = type;
        [self.vc presentViewController:pickerImage animated:YES completion:nil];
    }
}

- (UIViewController *)vc {
    if (_vc == nil) {
        _vc = [self getViewController];
    }
    return _vc;
}
- (UIViewController *)getViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

#pragma mark ----------------UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (self.delegate) {
        [self.delegate chk_imagePickerController:picker didFinishPickingMediaWithInfo:info];
        return;
    }
    UIImage *newImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.image = newImage;
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}




@end
