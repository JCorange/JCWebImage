//
//  JCWebImageMannager.h
//  JCWebImage
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 JCOrange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^WebImageCompletionBlock)(UIImage *webImage);

@interface JCWebImageMannager : NSObject

+ (instancetype)sharedWebImageMannager;

// 出现重用是因为cell 的 imageView 有2张图片的 urlString ，所以要取消其中一个的操作
- (void)cancelOperationWithImageUrlString:(NSString *)urlString;

- (void)setWebImageWithUrlString:(NSString *)urlString completionHandle:(WebImageCompletionBlock)webImageBlock;

@end
