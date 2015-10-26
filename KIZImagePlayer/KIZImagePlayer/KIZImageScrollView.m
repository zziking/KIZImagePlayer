//
//  KIZImageScrollView.m
//  KIZImagePlayer
//
//  Created by Eugene on 15/8/13.
//  Copyright (c) 2015年 kingizz. All rights reserved.
//

#import "KIZImageScrollView.h"
#import "KIZTimerWeakTarget.h"

@interface KIZImageScrollView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIImageView *imageView1;
@property (nonatomic, weak) UIImageView *imageView2;
@property (nonatomic, weak) UIImageView *imageView3;
@property (nonatomic, assign) NSUInteger currentPage;//当前显示图片的index
@property (nonatomic, strong) NSTimer *autoScrollTimer;//自动轮播定时器
@property (nonatomic, assign) NSUInteger numberOfImage;//图片总数量

@end

@implementation KIZImageScrollView{
    BOOL _isInitLayoutSubviews;
}

#pragma mark- life cycle

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUpInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpInit];
    }
    return self;
}


- (void)setUpInit{
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    
    self.shouldAutoScroll   = YES;
    self.autoScrollInterval = 5.0;
    self.numberOfImage      = 1;

    //为了无限循环滚动，ScrollView中永远有3个imageView，显示的是第二个imageView的图片，其他两个imageView的图片用于过渡显示
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:self.bounds];
    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:self.bounds];
    UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:self.bounds];
    
    imgV1.contentMode = UIViewContentModeScaleAspectFill;
    imgV2.contentMode = UIViewContentModeScaleAspectFill;
    imgV3.contentMode = UIViewContentModeScaleAspectFill;
    imgV1.clipsToBounds = YES;
    imgV2.clipsToBounds = YES;
    imgV3.clipsToBounds = YES;
    
    [self addSubview:imgV1];
    [self addSubview:imgV2];
    [self addSubview:imgV3];
    
    self.imageView1 = imgV1;
    self.imageView2 = imgV2;
    self.imageView3 = imgV3;
    
    //添加手势事件
    self.imageView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    [self.imageView2 addGestureRecognizer:tapGesture];
    
    self.delegate = self;
    
}

- (void)didMoveToWindow{
    [super didMoveToWindow];
    
    if (self.shouldAutoScroll) {
        [self setUpAutoScrollTimer];
    }
    
}

- (void)layoutSubviews{
    if (!_isInitLayoutSubviews) {
        self.contentOffset = CGPointMake(self.bounds.size.width, 0);
        
        [self reloadImage];
        
        self.imageView1.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.imageView2.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
        self.imageView3.frame = CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height);
        self.contentSize =CGSizeMake(3 * self.bounds.size.width, self.bounds.size.height);
        
        _isInitLayoutSubviews = YES;
    }
    
    [super layoutSubviews];
    
}

- (void)dealloc{
    [self.autoScrollTimer invalidate];
}


#pragma mark- UIScrollViewDelegate
//用户开始用手势滑动时，停止自动轮播定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.autoScrollTimer invalidate];
}

//手势滑动结束时，开启自动轮播定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.shouldAutoScroll) {
        [self setUpAutoScrollTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //计算当前实际应该显示第几页的图片
    CGFloat offsetX = self.contentOffset.x;
    NSInteger page = offsetX / CGRectGetWidth(self.frame);
    if (page == 0) {
        //向左滑动
        self.currentPage = _currentPage == 0 ? (self.numberOfImage - 1) : _currentPage - 1;
    }else if (page == 2){
        //向右滑动
        self.currentPage = _currentPage == (self.numberOfImage - 1) ? 0 : _currentPage + 1;
    }
    
    [self reloadImage];
    
    //将content offset设为第二页的偏移量，即，展示的永远是scrollview中第二页的偏移位置的图片
    self.contentOffset = CGPointMake(self.bounds.size.width, 0);
    
}

#pragma mark- public method
/**
 *  刷新数据
 */
- (void)reloadData{
    NSUInteger count = [self.kizScrollDataSource numberOfImageInScrollView:self];
    self.numberOfImage = count;
    if (_currentPage > count - 1) {
        _currentPage = count - 1;
    }
    _pageControl.numberOfPages = self.numberOfImage;
}


#pragma mark- private method
/**
 *  刷新图片，居中的imageview显示当前页的image，其他两个imageView分别显示前一张和后一张image
 */
- (void)reloadImage{
    self.pageControl.currentPage = self.currentPage;
    
    if (!self.numberOfImage) {
        return;
    }
    
    [self.kizScrollDataSource scrollView:self imageAtIndex:_currentPage forImageView:_imageView2];
    [self.kizScrollDataSource scrollView:self imageAtIndex:_currentPage == (self.numberOfImage - 1) ? 0 : _currentPage + 1 forImageView:_imageView3];
    [self.kizScrollDataSource scrollView:self imageAtIndex:_currentPage == 0 ? (self.numberOfImage - 1) : _currentPage - 1 forImageView:_imageView1];
    
    if ([self.kizScrollDelegate respondsToSelector:@selector(scrollView:didDidScrollToPage:)]) {
        [self.kizScrollDelegate scrollView:self didDidScrollToPage:self.currentPage];
    }
}

/**
 *  开启自动轮播定时器
 */
- (void)setUpAutoScrollTimer{
    if (!_autoScrollTimer.isValid) {
        
        KIZTimerWeakTarget *target = [[KIZTimerWeakTarget alloc] initWithTarget:self selector:@selector(autoScrollTimerFired:)];
        _autoScrollTimer = [NSTimer timerWithTimeInterval:self.autoScrollInterval
                                                   target:target
                                                 selector:@selector(timerDidFire:)
                                                 userInfo:nil
                                                  repeats:YES
                            ];
        [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSRunLoopCommonModes];
    }
}

/**
 *  自动轮播定时器被触发
 *
 *  @param timer
 */
- (void)autoScrollTimerFired:(NSTimer *)timer{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.contentOffset = CGPointMake(2 * self.bounds.size.width, 0);
                     }
                     completion:^(BOOL finished) {
                         [self scrollViewDidEndDecelerating:self];
                     }];
}

#pragma mark- Actions & Events
/**
 *  图片被点击时
 *
 *  @param gesture
 */
- (void)imageViewTapped:(UITapGestureRecognizer *)gesture{
    if ([self.kizScrollDelegate respondsToSelector:@selector(scrollView:didTappedImageAtIndex:)]){
        [self.kizScrollDelegate scrollView:self didTappedImageAtIndex:self.currentPage];
    }
    NSLog(@"%s, index:%lu", __PRETTY_FUNCTION__, (unsigned long)_currentPage);
}

#pragma mark- getters & setters

- (void)setAutoScrollInterval:(NSTimeInterval)autoScrollInterval{
    _autoScrollInterval = autoScrollInterval > 1 ? autoScrollInterval : 1.0;
}


- (void)setKizScrollDataSource:(id<KIZImageScrollViewDatasource>)kizScrollDataSource{
    _kizScrollDataSource = kizScrollDataSource;
    [self reloadData];
}


@end
