KIZImageScrollView
==================

![CocoaPods Version](https://img.shields.io/cocoapods/v/KIZImagePlayer.svg?style=flat)
[![License](https://img.shields.io/github/license/zziking/KIZImagePlayer.svg?style=flat)](https://github.com/zziking/KIZImagePlayer/blob/master/LICENSE)

图片自动无限循环轮播，支持手动滑动和自动轮播，支持设置轮播间隔时间，支持storyboard，支持直接设置图片和用SDwebImage设置网络图片，只有3个imageView，提高性能。

![imagescroll](http://7xjsf4.com1.z0.glb.clouddn.com/git_kizImageScrollview_1.gif)

### Installation

Available in [CocoaPods](http://cocoapods.org/?q=KIZImagePlayer)
```ruby
pod 'KIZImagePlayer'
```


###How to use

设置代理

```
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
