//
//  JCWebImageDownLoadOperation.m
//  JCWebImage
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 JCOrange. All rights reserved.
//

#import "JCWebImageDownLoadOperation.h"
#import "NSString+SandBoxPath.h"

@implementation JCWebImageDownLoadOperation

+ (instancetype)downLoadWebImageWithUrlString:(NSString *)urlStrig webImageCompletionHandle:(CompletionBlock)webImageHandle {
    
    JCWebImageDownLoadOperation *downLoadOp = [[JCWebImageDownLoadOperation alloc] init];
    
    downLoadOp.downLoadImageStr = urlStrig;
    
    downLoadOp.block = webImageHandle;
    
    return downLoadOp;
}

- (void)main {
    
    @autoreleasepool {
        
        NSURL *downLoadImageUrl = [NSURL URLWithString:self.downLoadImageStr];
        
        // 出现重用是因为imageView 有2 张图片 的 urlString ，所以取消其中一个 urlString 对应的操作
        // 当收到取消时，取消操作
        if (self.isCancelled) return;
        
        NSData *downLoadImageData = [NSData dataWithContentsOfURL:downLoadImageUrl];
        
        if (self.isCancelled) return;
        
        if (downLoadImageData) {
            
            // 将下载好的图片的 二进制数据 保存到沙盒
            [downLoadImageData  writeToFile:[_downLoadImageStr  sandBoxPath] atomically:YES];

        }
        
        if (self.isCancelled) return;
        
        self.finishImage = [UIImage imageWithData:downLoadImageData];
        
        if (self.isCancelled) return;
        
        // 图片下载完成之后回到主线程展示 UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.isCancelled) return;
            
            if (self.block && self.finishImage) {
                
                self.block(self);
            }
        });
    }
}

@end
