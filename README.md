Key-value coding (KVC) 和 key-value observing (KVO) 是两种能让我们驾驭 Objective-C 动态特性并简化代码的机制。

## KVO & KVC精讲

[请看这边文章，是国外的大神写的](https://www.objccn.io/issue-7-3/)

系统的KVO：

```
[self.labColor addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
```

```
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	// do something...
}
```

最后还需要移除监听

```
- (void)dealloc {
    [self.labColor removeObserver:self forKeyPath:@"color"];
}
```

这种方式不仅需要写的代码多，而且阅读体验差。因此 [JJKeyValueObserver](https://github.com/JRJian/KVOHelper) 诞生。

您只需要

```
[JJKeyValueObserver addObserveObject:self.labColor keyPath:@"color" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew changeBlock:^(NSDictionary *c) {
        self.colorView.backgroundColor = self.labColor.color;
    }];
```

即可完成KVO。不需要其他任何代码。

[源码请戳这里](https://github.com/JRJian/KVOHelper)