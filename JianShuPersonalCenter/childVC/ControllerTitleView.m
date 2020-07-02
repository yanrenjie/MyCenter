//
//  ControllerTitleView.m
//  JianShuPersonalCenter
//
//  Created by 颜仁浩 on 2020/6/30.
//  Copyright © 2020 Jackey. All rights reserved.
//

#import "ControllerTitleView.h"
#define DefaultFontSize  15
#define SelectedFontSize 18

@interface TitleCell ()

@property(nonatomic, strong)UILabel *label;

@end

@implementation TitleCell

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setTitleText:(NSString *)titleText {
    self.label.text = titleText;
    self.label.frame = self.bounds;
}

- (void)changeFontSize:(CGFloat)fontSize {
    self.label.font = [UIFont systemFontOfSize:fontSize];
    self.label.frame = self.bounds;
}

@end


@interface ControllerTitleView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)NSArray *titles;

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, assign)NSInteger seletedIndex;

@property(nonatomic, strong)TitleCell *seletedCell;

@end

@implementation ControllerTitleView

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TitleCell class] forCellWithReuseIdentifier:@"TitleCell"];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray seletedIndex:(NSInteger)seletedIndex {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titleArray;
        self.seletedIndex = seletedIndex;
        
        [self addSubview:self.collectionView];
        [self changeSeletedIndex:self.seletedIndex];
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TitleCell" forIndexPath:indexPath];
    [cell setTitleText:self.titles[indexPath.row]];
    [cell changeFontSize:self.seletedIndex == indexPath.item ? SelectedFontSize : DefaultFontSize];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self changeSeletedIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(controllerTitleView:didSelectedWithIndex:)]) {
        [self.delegate controllerTitleView:self didSelectedWithIndex:indexPath.item];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self titleSizeWithString:self.titles[indexPath.row] fontSize:indexPath.row == self.seletedIndex ? SelectedFontSize : DefaultFontSize];
}


- (CGSize)titleSizeWithString:(NSString *)string fontSize:(CGFloat)fontSize {
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}];
    CGSize newSize = CGSizeMake(size.width + 25, self.bounds.size.height);
    return newSize;
}


- (void)changeSeletedIndex:(NSInteger)index {
    NSIndexPath *beforeIndex = [NSIndexPath indexPathForRow:self.seletedIndex inSection:0];;
    if (!self.seletedCell) {
        self.seletedCell = (TitleCell *)[self.collectionView cellForItemAtIndexPath:beforeIndex];
    }
    [self.seletedCell changeFontSize:DefaultFontSize];
    self.seletedIndex = index;
    NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:self.seletedIndex inSection:0];
    
    self.seletedCell = (TitleCell *)[self.collectionView cellForItemAtIndexPath:currentIndex];
    [self.seletedCell changeFontSize:SelectedFontSize];

    [self.collectionView scrollToItemAtIndexPath:currentIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

@end
