//
//  BaseChildViewController.h
//  JianShuPersonalCenter
//
//  Created by 颜仁浩 on 2020/7/1.
//  Copyright © 2020 Jackey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseChildViewController : UIViewController<UITableViewDelegate>

@property(nonatomic, strong)NSString *zoneName;

@end

NS_ASSUME_NONNULL_END
