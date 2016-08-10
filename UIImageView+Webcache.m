//
//  UIImageView+Webcache.m
//  JCWebImage
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 JCOrange. All rights reserved.
//

#import "UIImageView+Webcache.h"
#import "JCWebImageMannager.h"

#import <objc/runtime.h>

@implementation UIImageView (Webcache)

- (void)jc_downLoadWebImageWithUrlString:(NSString *)urlString placeHolderImage:(UIImage *)placeHolderimage {
    
    self.image = placeHolderimage;
    
    JCWebImageMannager *webImageMannager = [JCWebImageMannager sharedWebImageMannager];
    
    if (![self.oldUrlString isEqualToString:urlString]) {
        
        [webImageMannager cancelOperationWithImageUrlString:self.oldUrlString];
    }
    
    // 2.给 imageView 绑定一个 图片的 urlString ，用于判断是否要显示的是同一张图片
    self.oldUrlString = urlString;
    
    // 3.让管理者去网络下载图片
    [webImageMannager setWebImageWithUrlString:urlString completionHandle:^(UIImage *webImage) {
        
        // 将从网络下载好的图片赋值给要设置的图片
        self.image = webImage;
        
    }];
}

const void *oldUrlStringKey = @"oldUrlStringKey";


// 为 分类添加运行时属性
- (void)setOldUrlString:(NSString *)oldUrlString {
    
    /*
     参数1: 为那个类添加属性
     参数2: 给属性设置 value 值时需要的 key，当获取这个属性时也是通过这个 key 获取
     参数3: 给属性赋的值
     参数4: 添加属性的策略  如 copy/retain.......
     
     */
    
    objc_setAssociatedObject(self, oldUrlStringKey, oldUrlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)oldUrlString {
    
    return objc_getAssociatedObject(self, oldUrlStringKey);
}

@end
