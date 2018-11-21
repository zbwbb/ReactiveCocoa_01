//
//  BaseViewController.m
//  ReactiveCocoa_01
//
//  Created by TsouMac2016 on 2018/11/20.
//  Copyright © 2018 TsouMac2016. All rights reserved.
//

#import "BaseViewController.h"
#import <ReactiveObjC.h>
#import "TwoViewController.h"

@interface BaseViewController ()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) RACCommand *command;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // RASubject delegate
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(100, 200, 100, 50);
    _btn.backgroundColor = [UIColor redColor];
    [_btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    // test
    [self testRACMulticastConnection];
    
    
}


#pragma mark-testRACSignal

-(void)testRACSignal{
    // 1. 创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"Entry moment 1");
        
        // 3. 发送信号
        [subscriber sendNext:@"This is Signal content"];
        
        NSLog(@"Entry moment 2");
        
        // 4. 信号发送完成之后，最好调用下面的完成方法。
        [subscriber sendCompleted];
        
        // 5. 调用了上述的完成方法以后，内部会自动调用[RACDisposable disposable]取消订阅信号，返回一个 RACDisposable 对象
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"Entry moment 3");
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    //2. 订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"Entry moment 4");
        NSLog(@"信号的内容：%@",x);
        
    }];
    
    //    // 可以将以上步骤合并如下：
    //    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //
    //        // 3. 发送信号
    //        [subscriber sendNext:@"This is Signal content"];
    //        [subscriber sendCompleted];
    //
    //        return [RACDisposable disposableWithBlock:^{
    //
    //        }];
    //
    //    }]subscribeNext:^(id  _Nullable x) {
    //
    //        NSLog(@"信号的内容：%@",x);
    //
    //    }];
}


#pragma mark- test Cold or Hot signal
-(void)testRACSignalColdOrHot{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"This is Signal content"];
        
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }];
    
    //2. 订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscriber 1  : %@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscriber 2  : %@",x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscriber 3  : %@",x);
    }];
    
    
    // RACSubject
    RACSubject *subject = [RACSubject subject];
    
    // Subscriber 1
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscriber 1  : %@",x);
    }];
    [subject sendNext:@"this is a message 1"];
    
    // Subscriber 2： 之前 Subscriber 1 发送的消息收不到 ，只能收到以后的消息
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscriber 2  : %@",x);
    }];
    [subject sendNext:@"this is a message 2"];
    
    // Subscriber 3：之前 Subscriber 1、Subscriber 2 发送的消息都收不到，只能收到以后的消息
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscriber 3  : %@",x);
    }];
    [subject sendNext:@"this is a message 3"];
    
    [subject sendCompleted];
    
    
}

#pragma mark-testRACReplaySubject

-(void)testRACReplaySubject{
    // RACSubject
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"the first subscriber got %@",x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"the second subscriber got %@",x);
    }];
    [subject sendNext:@"222"];
    [subject sendCompleted];
    
    // RACReplaySubject
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject sendNext:@"666"];
    [replaySubject sendNext:@"888"];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"the first subscriber got %@",x);
    }];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"the second subscriber got %@",x);
    }];
    
    
}

#pragma mark-testRACTuple

-(void)testRACTuple{
    // 1.遍历数组
    NSArray *numbers = @[@"A",@"B",@"C",@"D"];
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    
    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"dog",@"age":@2,@"address":@"一号大街"};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
    }];
    
    
}

#pragma mark-testRACCommand

-(void)testRACCommand{
    // 1.创建信号 (声明强引用对象)
    self.command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // input 参数
        NSLog(@"参数：%@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //
            [subscriber sendNext:@"获取的数据"];
            //
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"信号取消订阅");
            }];
        }];
        
    }];
    // 2.订阅RACCommand中的信号
//    [self.command.executionSignals subscribeNext:^(id x) {
//
//        [x subscribeNext:^(id x) {
//
//            NSLog(@"%@",x);
//        }];
//
//    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [self.command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[self.command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    // 4.执行命令 传递参数
    [self.command execute:@"参数1"];
    
}

#pragma mark -testRACMulticastConnection

-(void)testRACMulticastConnection{
    // 被多次订阅情形
    
    // 1.创建请求信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        return nil;
    }];
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"接收数据");
    }];
    // 2.订阅信号
    [signal subscribeNext:^(id x) {
        
        NSLog(@"接收数据");
        
    }];
    // 以上信号在订阅的时候就激活了，接下来想办法怎么阻止在订阅的时候激活
    
    
    //
    // RACMulticastConnection:解决重复请求问题
    // 1.创建信号
    RACSignal *connectionSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"connection  发送请求");
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    // 创建连接
    RACMulticastConnection *connection = [connectionSignal publish];
    // 订阅信号 ,这里订阅信号 也不能激活信号，只是将信号保存到数组中
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"connection  订阅者1");
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"connection  订阅者2");
    }];
    
    // 激活信号
    [connection connect];
    
    
    
}













#pragma mark -handle btn
-(void)handleBtn:(UIButton *)btn{
    // 创建第二个控制器
    TwoViewController *twoVc = [[TwoViewController alloc] init];
    
    // 设置代理信号
    twoVc.delegateSignal = [RACSubject subject];
    
    // 订阅代理信号
    __weak typeof(self)weakSelf = self;
    [twoVc.delegateSignal subscribeNext:^(id x) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.btn.backgroundColor = (UIColor *)x;
    }];
    
    // 跳转到第二个控制器
    [self.navigationController pushViewController:twoVc animated:YES];
    
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
