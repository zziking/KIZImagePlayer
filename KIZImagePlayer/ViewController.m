//
//  ViewController.m
//  KIZImagePlayer
//
//  Created by Eugene on 15/8/13.
//  Copyright (c) 2015年 kingizz. All rights reserved.
//

#import "ViewController.h"
#import "KIZImageScrollView.h"

@interface ViewController ()<KIZImageScrollViewDatasource, KIZImageScrollViewDelegate>

@property (weak, nonatomic) IBOutlet KIZImageScrollView *imageScrollView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[@"1", @"2", @"3"];
    self.imageScrollView.kizScrollDataSource = self;
    self.imageScrollView.kizScrollDelegate   = self;
    
    [self performSelector:@selector(fetchData) withObject:nil afterDelay:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
- (NSUInteger)numberOfImageInScrollView:(KIZImageScrollView *)scrollView{
    return self.dataSource.count;
}

- (void)scrollView:(KIZImageScrollView *)scrollView imageAtIndex:(NSUInteger)index forImageView:(UIImageView *)imageView{
    imageView.image = [UIImage imageNamed:self.dataSource[index]];
    
}

- (void)scrollView:(KIZImageScrollView *)scrollView didTappedImageAtIndex:(NSUInteger)index{
    
}

- (void)fetchData{
    self.dataSource = @[@"1", @"2", @"3", @"4"];
    [self.imageScrollView reloadData];
}
@end
