//
//  JJKeyValueObserver.m
//  Lab Color Space Explorer
//
//  Created by Jian on 2017/6/14.
//  Copyright © 2017年 objc.io. All rights reserved.
//

#import "JJKeyValueObserver.h"
#include <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>

#pragma mark -
#pragma mark - JJDeallocExecutor start
const void *JJDeallocExecutorsKey = &JJDeallocExecutorsKey;

typedef void (^JJDeallocExecutorBlock)(void);
@interface JJDeallocExecutor : NSObject
@property (nonatomic, copy) JJDeallocExecutorBlock deallocExecutorBlock;
- (id)initWithBlock:(JJDeallocExecutorBlock)block;
@end
@implementation JJDeallocExecutor
- (id)initWithBlock:(JJDeallocExecutorBlock)deallocExecutorBlock {
    self = [super init];
    if (self) {
        _deallocExecutorBlock = [deallocExecutorBlock copy];
    }
    return self;
}
- (void)dealloc {
    !_deallocExecutorBlock?:_deallocExecutorBlock();
}
@end
#pragma mark - JJDeallocExecutor end

#pragma mark -
#pragma mark - JJObserveObject start
@interface JJObserveObject : NSObject
@property (nonatomic, weak) id observedObject;
@property (nonatomic, copy) NSString* keyPath;
@property (nonatomic, copy) void(^changeBlock)(NSDictionary *);
@end
@implementation JJObserveObject
@end

@interface JJKeyValueObserver()
@property (nonatomic, strong) NSMutableSet *observeObjects;
@end

@implementation JJKeyValueObserver

+ (JJKeyValueObserver *)observer {
    static dispatch_once_t onceToken;
    static JJKeyValueObserver *_instance;
    dispatch_once(&onceToken, ^{
        _instance = [[JJKeyValueObserver alloc] init];
    });
    return _instance;
}

+ (NSObject *)addObserveObject:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeBlock:(void (^)(NSDictionary *))changeBlock {
    
    JJObserveObject *observeObject = [JJObserveObject new];
    observeObject.observedObject = object;
    observeObject.keyPath = keyPath;
    observeObject.changeBlock = changeBlock;
    [[JJKeyValueObserver observer].observeObjects addObject:observeObject];
    
    // 被监听的对象释放后，需要移除对应的监听
    // 这里注意：在 JJDeallocExecutor 的参数 block 中不能使用 weak 修饰符修饰的 self，因为 weak 变量在 dealloc 中会被自定置为 nil。应该使用 __unsafe_unretained 修饰符。
    __weak NSMutableSet *observeObjects = [JJKeyValueObserver observer].observeObjects;
    __weak typeof([JJKeyValueObserver observer]) weakObserver = [JJKeyValueObserver observer];
    __unsafe_unretained typeof(object) weakObject = object;
    __weak typeof(observeObject)oo = observeObject;
    JJDeallocExecutor *executor = [[JJDeallocExecutor alloc] initWithBlock:^{
        [weakObject removeObserver:weakObserver forKeyPath:keyPath];
        [observeObjects removeObject:oo];
    }];
    // 注意这里的key需要不同的值，防止之前添加的observeObject被释放
    NSString *deallocExecutorsKey = [NSString stringWithFormat:@"%ld", [observeObject hash]];
    objc_setAssociatedObject(object, (__bridge const void *)(deallocExecutorsKey), executor, OBJC_ASSOCIATION_RETAIN);
    
    // 监听
    [object addObserver:[self observer] forKeyPath:keyPath options:options context:(__bridge void *)(observeObject)];
    
    return [self observer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSEnumerator *enumerator = [self.observeObjects objectEnumerator];
    JJObserveObject *observeObject = [enumerator nextObject];
    while (observeObject && context != (__bridge void *)(observeObject)) {
        observeObject = [enumerator nextObject];
    }
    !observeObject.changeBlock?:observeObject.changeBlock(change);
}

- (NSMutableSet *)observeObjects {
    if (!_observeObjects) {
        _observeObjects = [NSMutableSet set];
    }
    return _observeObjects;
}

@end
#pragma mark - JJObserveObject end
