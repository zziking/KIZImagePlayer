#KIZImageScrollView
图片自动无限循环轮播，支持直接设置图片和用SDwebImage设置网络图片，只有3个imageView，节省性能。

![imagescroll](http://7xjsf4.com1.z0.glb.clouddn.com/git_kizImageScrollview_1.gif)

###How to use

设置代理

```
self.dataSource = @[@"1", @"2", @"3", @"4"];
self.imageScrollView.kizScrollDataSource = self;
self.imageScrollView.kizScrollDelegate   = self;
```

实现代理方法

```
- (NSUInteger)numberOfImageInScrollView:(KIZImageScrollView *)scrollView{
    return self.dataSource.count;
}

- (void)scrollView:(KIZImageScrollView *)scrollView imageAtIndex:(NSUInteger)index forImageView:(UIImageView *)imageView{
    imageView.image = [UIImage imageNamed:self.dataSource[index]];
    //or use SDWebImage set web image
    //[imageView sd_setImageWithURL:url];
}

```