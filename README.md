# JJKeyValueObserver
对系统的KVO进行封装，更好更便捷的使用KVO。

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

这种方式不仅需要写的代码多，而且阅读体验差。因此 JJKeyValueObserver 诞生。

您只需要

```
[JJKeyValueObserver addObserveObject:self.labColor keyPath:@"color" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew changeBlock:^(NSDictionary *c) {
        self.colorView.backgroundColor = self.labColor.color;
    }];
```

即可完成KVO。不需要其他任何代码