//
//  KIZImageScrollView.h
//  KIZImagePlayer
//
//  Created by Eugene on 15/8/13.
//  Copyright (c) 2015年 kingizz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KIZImageScrollView;

@protocol KIZImageScrollViewDatasource <NSObject>

- (NSUInteger)numberOfImageInScrollView:(KIZImageScrollView *)scrollView;

- (void)scrollView:(KIZImageScrollView *)scrollView imageAtIndex:(NSUInteger)index forImageView:(UIImageView *)imageView;

@end

@protocol KIZImageScrollViewDelegate <NSObject>

@optional
- (void)scrollView:(KIZImageScrollView *)scrollView didTappedImageAtIndex:(NSUInteger)index;
- (void)scrollView:(KIZImageScrollView *)scrollView didDidScrollToPage:(NSUInteger)page;

@end

@interface KIZImageScrollView : UIScrollView

@property (nonatomic, weak) IBOutlet id<KIZImageScrollViewDatasource> kizScrollDataSource;
@property (nonatomic, weak) IBOutlet id<KIZImageScrollViewDelegate> kizScrollDelegate;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@property (nonatomic, assign) IBInspectable BOOL shouldAutoScroll;//是否自动轮播，默认YES
@property (nonatomic, assign) IBInspectable double autoScrollInterval;//自动轮播时间间隔，默认5s

/**
 *  当数据源改变时，刷新数据
 */
- (void)reloadData;

@end
