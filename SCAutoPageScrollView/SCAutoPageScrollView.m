//
//  SCAutoPageScrollView.m
//  SinaFinance
//
//  Created by dengyanzhou on 15/11/19.
//  Copyright © 2015年 sina.com. All rights reserved.
//

#import "SCAutoPageScrollView.h"
#import "UIImageView+WebCache.h"
#define SCAUTOPAGE_WEIGHT 15

@interface SCAutoPageScrollView ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIPageControl *pageControl;

//存放imageView 防止数据刷新时 再alloc新的imageView 扰乱内存
@property(nonatomic,strong) NSMutableArray *imageViewArray;
@end

@implementation SCAutoPageScrollView

#pragma mark - 初始化方法
/**
 *  重写父类方法
 *
 *  @param frame rect
 *
 *  @return  id
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //创建UI
        [self createUI];
        self.scrollView.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

//从xib加载 初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        //创建UI
        [self createUI];
    }
    return self;
}
#pragma mark - 创建点击手势
- (void)creataTapGes
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
    [self addGestureRecognizer:tapGes];
}

//tap手势回调
- (void)imageViewClick:(UITapGestureRecognizer*)tapGes
{
    if ([_delegate respondsToSelector:@selector(scAutoPageScrollViewClickImageView:)]) {
        [_delegate performSelector:@selector(scAutoPageScrollViewClickImageView:) withObject:self];
    }
}

#pragma mark - 创建UI
- (void)createUI
{
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
}

/**
 *  创建 pageControl
 *
 *  @return pageControl
 */
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        //_pageControl 默认占 1/4 屏幕宽 居中显示
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) * 3 / 8, CGRectGetHeight(self.frame) - 20  , CGRectGetWidth(self.frame) / 4 , SCAUTOPAGE_WEIGHT)];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.240 green:1.000 blue:0.225 alpha:1.000];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageControl];
    }
    _pageControl.center =  CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - SCAUTOPAGE_WEIGHT / 2 -  5 );
    //数据源有可能更新了 所以 numPage 必须重新设置
    _pageControl.numberOfPages = _dataArray.count;
    return _pageControl;
}

/**
 *  创建scrollView
 *
 *  @return  scrollView
 */
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
    }
    return _scrollView;
}

#pragma mark - 设置数据源
//设置数据源 and UI 数据有可能更新 所以必须让imageView 从新加载图片
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    //当前的没有这么多imageView 创建
    if (self.imageViewArray.count < _dataArray.count) {
        
        int gap =  (int)(_dataArray.count - self.imageViewArray.count);
        for (int i = 0; i < gap;  i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_imageViewArray addObject:imageView];
        }
    }
    //多的话删除 释放内存
    if (self.imageViewArray.count > _dataArray.count) {
        
        int gap =  (int)(self.imageViewArray.count -  _dataArray.count);
        for (int i = 0; i < gap; i++) {
            UIImageView *imageView = [self.imageViewArray lastObject];
            [imageView removeFromSuperview];
            [self.imageViewArray removeLastObject];
        }
    }
    
    _scrollView.contentSize = CGSizeMake(_dataArray.count * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    
    //设置默认图片路径对应的key
    if (!self.imageUrlKey.length) {
        self.imageUrlKey = @"imageUrl";
    }
    //添加到scollView上
    for (int i = 0; i < _imageViewArray.count; i++) {
        UIImageView *imageView = _imageViewArray[i];
        //删除原有的图片
        imageView.image = nil;
        NSDictionary *dataDic = _dataArray[i];
        imageView.frame =  CGRectMake(i * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        
        if (!imageView.superview) {
            [_scrollView addSubview:imageView];
        }
        //请求图片
        NSString *urlString = dataDic[_imageUrlKey];
        //扔到环境请求
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
    }
    //默认显示第一页
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.pageControl.currentPage = 0;
    self.pageIndex = 0;
}

- (NSMutableArray *)imageViewArray
{
    if (!_imageViewArray) {
        _imageViewArray = [[NSMutableArray alloc] init];
    }
    return _imageViewArray;
}

#pragma mark - 设置开启关闭自动滑动
- (void)setIsOpenAutoScroll:(BOOL)isOpenAutoScroll
{
    _isOpenAutoScroll = isOpenAutoScroll;
    if (_isOpenAutoScroll) {
        
        if (self.time <= 0) {
            //默认4秒滑动一页
            self.time = 4;
        }
        [self performSelector:@selector(autoScroll) withObject:nil afterDelay:self.time];
    }
}

- (void)stopAutoScroll
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoScroll) object:nil];
}

- (void)autoScroll
{
    //切换
    if (_pageIndex == _dataArray.count - 1) {
        _pageIndex = 0;
    }else{
        _pageIndex = _pageIndex + 1;
    }
    if (_isAnimation) {
        if (_animationTime <= 0 || _animationTime >= _time) {
            _animationTime = _time / 2;
        }
        [UIView animateWithDuration:_animationTime animations:^{
            _scrollView.contentOffset = CGPointMake(_pageIndex * CGRectGetWidth(_scrollView.frame), 0);
        }];
    }else{
        _scrollView.contentOffset = CGPointMake(_pageIndex * CGRectGetWidth(_scrollView.frame), 0);
    }
    _pageControl.currentPage = _pageIndex;

    //递归
    [self performSelector:@selector(autoScroll) withObject:nil afterDelay:self.time];
}

#pragma mark - 需要点击图片回调功能吗
- (void)setIsTapFunction:(BOOL)isTapFunction
{
    _isTapFunction = isTapFunction;
    if (_isTapFunction) {
        [self creataTapGes];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    _pageControl.currentPage = _pageIndex;
}
@end
