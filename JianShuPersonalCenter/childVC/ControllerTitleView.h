//
//  ControllerTitleView.h
//  JianShuPersonalCenter
//
//  Created by 颜仁浩 on 2020/6/30.
//  Copyright © 2020 Jackey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ControllerTitleView;

@protocol ControllerTitleViewDelegate <NSObject>

- (void)controllerTitleView:(ControllerTitleView *)titleView didSelectedWithIndex:(NSInteger)index;

@end

@interface ControllerTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray seletedIndex:(NSInteger)seletedIndex;

- (void)changeSeletedIndex:(NSInteger)index;

@property(nonatomic, weak)id<ControllerTitleViewDelegate> delegate;

@end


@interface TitleCell : UICollectionViewCell

- (void)setTitleText:(NSString *)titleText;

- (void)changeFontSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
