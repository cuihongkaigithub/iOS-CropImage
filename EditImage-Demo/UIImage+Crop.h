//
//  UIImage+Crop.h
//  EditImage-Demo
//
//  Created by 尊旅环球游 on 2017/7/12.
//  Copyright © 2017年 chk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Crop)

/**
 缩放指定大小
 
 @param newSize 缩放后的尺寸
 @return UIImage
 */
- (UIImage *)resizeImageWithSize:(CGSize)newSize;

@end
