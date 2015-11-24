//
//  SCAutoPageScrollView.h
//  SinaFinance
//
//  Created by dengyanzhou on 15/11/19.
//  Copyright © 2015年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCAutoPageScrollView;
@protocol SCAutoPageScrollViewDelegate <NSObject>
//
@optional
- (void)scAutoPageScrollViewClickImageView:(SCAutoPageScrollView*)pageScrollView;
@end

/**
 *  每个view上面的轮播图
 */
IB_DESIGNABLE //支持xib配置属性
@interface SCAutoPageScrollView : UIView<NSCoding>

@property(nonatomic,weak) id<SCAutoPageScrollViewDelegate > delegate;
//内置滑动视图
@property(nonatomic,strong) UIScrollView *scrollView;
//存放每一页的数据
@property(nonatomic,strong) NSArray *dataArray;
//当前滑动到那一页 默认显示第一页
@property(nonatomic,assign) int pageIndex;

//是否开启自动滑动  默认不开启
@property (nonatomic,assign) IBInspectable BOOL  isOpenAutoScroll;
//多少秒自动滑动一页 默认4秒
@property (nonatomic,assign) IBInspectable CGFloat time;
//自动滑动是否需要动画 默认不需要
@property (nonatomic,assign) IBInspectable BOOL isAnimation;
//动画时间 默认为 time 的1/2
@property (nonatomic,assign) IBInspectable CGFloat animationTime;
//数据源中的图片地址对应key 默认是imageUrl
@property (nonatomic,copy  ) IBInspectable NSString  *imageUrlKey;
//需要点击照片回调功能吗 默认no 如果设置的话 点击图片会回调代理方法
@property (nonatomic,assign) IBInspectable BOOL isTapFunction;

//关闭自动滑动
- (void)stopAutoScroll;

@end
