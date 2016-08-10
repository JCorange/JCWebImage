//
//  NSString+SandBoxPath.m
//  JCWebImage
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 JCOrange. All rights reserved.
//

#import "NSString+SandBoxPath.h"

@implementation NSString (SandBoxPath)

- (NSString *)sandBoxPath {
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    cachePath = [cachePath stringByAppendingPathComponent:self.lastPathComponent];
    
    return cachePath;
}

@end
