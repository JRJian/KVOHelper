//
//  JJKeyValueObserver.h
//  Lab Color Space Explorer
//
//  Created by Jian on 2017/6/14.
//  Copyright © 2017年 objc.io. All rights reserved.
//
//  不是线程安全。
//  不推荐把 KVO 和多线程混起来使用
#import <Foundation/Foundation.h>

@interface JJKeyValueObserver : NSObject

/**
 添加键值监听，不需要手动 removeObserver。在对象object释放的时候，JJKeyValueObserver会自动remove object的监听

 @param object 监听的对象
 @param keyPath 监听的属性路径
 @param options 请查看系统NSKeyValueObservingOptions枚举
 @param changeBlock 发生变化，通知的回调代码块
 @return JJKeyValueObserver 对象
 */
+ (NSObject *)addObserveObject:(id)object keyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options changeBlock:(void(^)(NSDictionary *))changeBlock;

@end
