//
//  TwoViewController.m
//  ReactiveCocoa_01
//
//  Created by TsouMac2016 on 2018/11/20.
//  Copyright © 2018 TsouMac2016. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(100, 200, 100, 50);
    _btn.backgroundColor = [UIColor redColor];
    [_btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    // Do any additional setup after loading the view.
}

#pragma mark -handle btn
-(void)handleBtn:(UIButton *)btn{
    // 通知代理
    // 判断代理信号是否有值
    if (self.delegateSignal) {
        // 有值，才需要通知
        [self.delegateSignal sendNext:[UIColor blackColor]];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
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
