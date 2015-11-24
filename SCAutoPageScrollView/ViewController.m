//
//  ViewController.m
//  SCAutoPageScrollView
//
//  Created by dengyanzhou on 15/11/24.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<SCAutoPageScrollViewDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.pageScrollView = [[SCAutoPageScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.pageScrollView];
    self.pageScrollView.delegate = self;
    self.pageScrollView.animationTime = 1;
    self.pageScrollView.isAnimation = YES;
    self.pageScrollView.time = 5;
    self.pageScrollView.isOpenAutoScroll = YES;
    
    NSArray *imageArray = @[
                            @{@"imageUrl":@"https://www.baidu.com/img/bd_logo1.png"},
                            @{@"imageUrl":@"http://a.hiphotos.baidu.com/news/q%3D100/sign=8c4838167dcb0a4683228f395b61f63e/30adcbef76094b362c14c101a5cc7cd98c109d5c.jpg"},
                            @{@"imageUrl":@"http://a.hiphotos.baidu.com/news/q%3D100/sign=e88f96f52bf5e0fee8188d016c6134e5/4610b912c8fcc3cedb6d50df9445d688d53f20a8.jpg"}
                            ];
    
    self.pageScrollView.dataArray = imageArray;

    // Do any additional setup after loading the view from its nib.
}

- (void)scAutoPageScrollViewClickImageView:(SCAutoPageScrollView *)pageScrollView
{




}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
