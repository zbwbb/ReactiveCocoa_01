//
//  TwoViewController.h
//  ReactiveCocoa_01
//
//  Created by TsouMac2016 on 2018/11/20.
//  Copyright © 2018 TsouMac2016. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwoViewController : UIViewController

@property (nonatomic, strong) RACSubject *delegateSignal;

@end

NS_ASSUME_NONNULL_END
