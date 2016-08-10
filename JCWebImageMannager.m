//
//  JCWebImageMannager.m
//  JCWebImage
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 JCOrange. All rights reserved.
//

#import "JCWebImageMannager.h"
#import "NSString+SandBoxPath.h"
#import "JCWebImageDownLoadOperation.h"

@interface JCWebImageMannager ()

// 图片缓存
@property (nonatomic,strong) NSMutableDictionary  *imagesCache;

// 操作缓存
@property (nonatomic,strong) NSMutableDictionary  *operationsCache;


// 操作队列
@property (nonatomic,strong) NSOperationQueue  *operationQueue;

@end

@implementation JCWebImageMannager

+ (instancetype)sharedWebImageMannager {
    
    static id _instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (void)cancelOperationWithImageUrlString:(NSString *)urlString {
    
    // 1.通过 图片的 oldUrlString 创建操作
    JCWebImageDownLoadOperation *op = self.operationsCache[urlString];
    
    // 2.当程序第一次运行时，imageView 的 oldUrlString 是 nil，此时没有对应的操作，所以 直接 return
    if (!op) return;
    
    // 3.取消 oldUrlString 对应的操作
    [op cancel];
    
    // 4.既然取消了 oldUrlString 对应的操作，就应该把这个操作从操作缓存池中删除了
    [self.operationsCache removeObjectsForKeys:urlString];
}


- (void)setWebImageWithUrlString:(NSString *)urlString completionHandle:(WebImageCompletionBlock)webImageBlock {
    
    
    // 从内存缓存中获取图片
    UIImage *memoryImage = [self.imagesCache objectForKey:urlString];
    
    if (memoryImage) {
        
        if (webImageBlock) {
            
            webImageBlock(memoryImage);
        }
        
        return;
    }
    
    
    // 从沙河缓存中获取图片
    UIImage *sandBoxImage = [UIImage imageWithContentsOfFile:[urlString sandBoxPath]];
    
    if (sandBoxImage) {
        
        if (webImageBlock) {
            
            webImageBlock(sandBoxImage);
        }
        
        return;
    }
    
    JCWebImageDownLoadOperation *downLoadOp = [self.operationsCache objectForKey:urlString];
    
    if (downLoadOp) return;
    
    JCWebImageDownLoadOperation *downLoadNewOp = [JCWebImageDownLoadOperation downLoadWebImageWithUrlString:urlString webImageCompletionHandle:^(JCWebImageDownLoadOperation *op) {
        
        if (op.isCancelled) return;
        
        if (webImageBlock) {
            
            webImageBlock(op.finishImage);
        }
        
        // 把下载好的图片添加到图片缓存中
        [self.imagesCache setObject:op.finishImage forKey:urlString];
        
        // 没次下载好图片以后，把该图片对应 的下载操作删除
        [self.operationsCache removeObjectForKey:urlString];
        
    }];
    
    // 将操作添加到操作缓存中
    [self.operationsCache setObject:downLoadNewOp forKey:urlString];
    
    // 将操作添加到 非主队列中
    [self.operationQueue addOperation:downLoadNewOp];
    
}

- (NSOperationQueue *)operationQueue {
    
    if (!_operationQueue) {
        
        _operationQueue = [[NSOperationQueue alloc] init];
        
        // 设置操作队列的最大并发数
        [_operationQueue setMaxConcurrentOperationCount:6];
    }
    
    return _operationQueue;
}

- (NSMutableDictionary *)operationsCache {
    
    if (!_operationsCache) {
        
        _operationsCache = [NSMutableDictionary dictionary];
    }
    
    return _operationsCache;
}

- (NSMutableDictionary *)imagesCache {
    
    if (!_imagesCache) {
        
        _imagesCache = [NSMutableDictionary dictionary];
    
    }
    
    return _imagesCache;
}



@end
