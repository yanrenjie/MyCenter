//
//  SegmentView.h
//  JianShuPersonalCenter
//
//  Created by 颜仁浩 on 2020/7/1.
//  Copyright © 2020 Jackey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SegmentView : UIView

- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs titles:(NSArray *)titles selectedIndex:(NSInteger)selectedIndex;


- (void)setSelectedIndex:(NSInteger)selectedIndex;

@end

NS_ASSUME_NONNULL_END
