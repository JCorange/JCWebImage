//
//  UIImageView+Webcache.h
//  JCWebImage
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 JCOrange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Webcache)

// 图片原来的下载地址(因为出现重用是有2个图片URL指向同一个 imageView，所以要给 imageView 绑定这个属性)
@property (nonatomic,copy) NSString  *oldUrlString;

/**
 *	@brief 对外下载网络图片的接口方法
 *	@param urlString	网络图片的 URL
 *	@param placeHolderimage	占位图片，没有可以传 nil
 */
- (void)jc_downLoadWebImageWithUrlString:(NSString *)urlString placeHolderImage:(UIImage *)placeHolderimage;

@end
