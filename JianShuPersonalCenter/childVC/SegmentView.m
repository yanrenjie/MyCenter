//
//  SegmentView.m
//  JianShuPersonalCenter
//
//  Created by 颜仁浩 on 2020/7/1.
//  Copyright © 2020 Jackey. All rights reserved.
//

#import "SegmentView.h"
#import "ControllerTitleView.h"

@interface SegmentView ()<UIScrollViewDelegate, ControllerTitleViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong)ControllerTitleView *titleView;
@property(nonatomic, strong)UICollectionView *contentScrollView;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, strong)NSArray *childVCArray;

@end

@implementation SegmentView

- (UICollectionView *)contentScrollView {
    if (!_contentScrollView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(screenW, screenH - titleH);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        
        _contentScrollView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, titleH, screenW, screenH - titleH) collectionViewLayout:layout];
        _contentScrollView.delegate = self;
        _contentScrollView.dataSource = self;
        _contentScrollView.backgroundColor = UIColor.whiteColor;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        [_contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _contentScrollView;
}

- (instancetype)initWithFrame:(CGRect)frame parentVC:(UIViewController *)parentVC childVCs:(NSArray *)childVCs titles:(NSArray *)titles selectedIndex:(NSInteger)selectedIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.childVCArray = childVCs;
        self.index = selectedIndex;
        self.titleView = [[ControllerTitleView alloc] initWithFrame:CGRectMake(0, 0, screenW, titleH) titleArray:titles seletedIndex:selectedIndex];
        self.titleView.backgroundColor = UIColor.redColor;
        self.titleView.delegate = self;
        [self addSubview:self.titleView];
        
        [self addSubview:self.contentScrollView];
        [self.contentScrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleH, screenW, screenH - titleH)];
//        self.contentScrollView.contentSize = CGSizeMake(screenW * childVCs.count, 0);
//        self.contentScrollView.delegate = self;
//        self.contentScrollView.showsVerticalScrollIndicator = NO;
//        self.contentScrollView.showsHorizontalScrollIndicator = NO;
//        self.contentScrollView.pagingEnabled = YES;
//        self.contentScrollView.bounces = NO;
//        [self addSubview:self.contentScrollView];

        [childVCs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController *tempVC = (UIViewController *)obj;
//            [self.contentScrollView addSubview:tempVC.view];
//            tempVC.view.frame = CGRectMake(screenW * idx, 0, screenW, screenH);
            [parentVC addChildViewController:tempVC];
        }];
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.index = selectedIndex;
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGECHILDCONTROLLERINDEXNOTIFICATION object:nil userInfo:@{@"selectedPageIndex" : @(selectedIndex)}];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINVIEWSCROLLABLENOTIFICATION object:nil userInfo:@{@"canScroll" : @0}];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINVIEWSCROLLABLENOTIFICATION object:nil userInfo:@{@"canScroll" : @1}];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = self.contentScrollView.contentOffset.x / screenW;
    [self.titleView changeSeletedIndex:currentIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGECHILDCONTROLLERINDEXNOTIFICATION object:nil userInfo:@{@"selectedPageIndex" : @(currentIndex)}];
}


- (void)controllerTitleView:(ControllerTitleView *)titleView didSelectedWithIndex:(NSInteger)index {
    self.index = index;
    [self.contentScrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGECHILDCONTROLLERINDEXNOTIFICATION object:nil userInfo:@{@"selectedPageIndex" : @(index)}];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVCArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    for (UIView *tempV in cell.contentView.subviews) {
        [tempV removeFromSuperview];
    }
    UIViewController *vc = self.childVCArray[indexPath.row];
    [cell.contentView addSubview:vc.view];
    vc.view.frame = cell.contentView.bounds;
    return cell;
}


@end
