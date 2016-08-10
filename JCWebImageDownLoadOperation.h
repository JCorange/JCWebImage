//
//  JCWebImageDownLoadOperation.h
//  JCWebImage
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 JCOrange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JCWebImageDownLoadOperation;

typedef void(^CompletionBlock)(JCWebImageDownLoadOperation *op);

@interface JCWebImageDownLoadOperation : NSOperation

// 下载好的图片
@property (nonatomic,strong) UIImage  *finishImage;

// 图片下载地址
@property (nonatomic,copy) NSString  *downLoadImageStr;


@property (nonatomic,copy) CompletionBlock block;

/**
 *	@brief 自定义操作的实例化方法
 *	@param CompletionBlock	操作完成之后的回调
 *	@return 自定义图片下载操作
 */
+ (instancetype)downLoadWebImageWithUrlString:(NSString *)urlStrig webImageCompletionHandle:(CompletionBlock)webImageHandle;

@end
