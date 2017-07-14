//
//  TapImageView.h
//  ZLGlobalTravel
//
//  Created by 尊旅环球游 on 2017/6/16.
//  Copyright © 2017年 尊旅环球游. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapImageViewDelegate <NSObject>

- (void)chk_imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;

@end

@interface TapImageView : UIImageView

@property (nonatomic,weak) id <TapImageViewDelegate> delegate;

@end
