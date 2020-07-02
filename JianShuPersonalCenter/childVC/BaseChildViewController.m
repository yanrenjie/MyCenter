//
//  BaseChildViewController.m
//  JianShuPersonalCenter
//
//  Created by 颜仁浩 on 2020/7/1.
//  Copyright © 2020 Jackey. All rights reserved.
//

#import "BaseChildViewController.h"
#import "DetailViewController.h"

@interface BaseChildViewController ()<UIGestureRecognizerDelegate, UIScrollViewDelegate>
// 因为具体的子控制器会继承自这个控制器，然后里面会设置UITableView属性，当监听滚动的时候，用这个scrollView指针指向tableView
@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, assign)BOOL canScroll;

@property(nonatomic, strong)NSNumber *selectedPageIndex;

@end

@implementation BaseChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.zoneName);
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    // 监听子控制器视图到达顶部的通知
    [notificationCenter addObserver:self selector:@selector(receiveNotification:) name:ARRIVETOPNOTIFICATION object:nil];
    // 监听子控制器离开顶部的通知
    [notificationCenter addObserver:self selector:@selector(receiveNotification:) name:LEAVETOPNOTIFICATION object:nil];
    // 切换子控制器的通知
    [notificationCenter addObserver:self selector:@selector(receiveNotification:) name:CHANGECHILDCONTROLLERINDEXNOTIFICATION object:nil];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LEAVETOPNOTIFICATION object:nil userInfo:@{@"canScroll" : @1}];
    }
    self.scrollView = scrollView;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if (self.selectedPageIndex.integerValue == 0) {
        return YES;
    }
    return NO;
}


- (void)receiveNotification:(NSNotification *)notification {
    NSString *name = notification.name;
    NSDictionary *userInfo = notification.userInfo;
    if ([name isEqualToString:ARRIVETOPNOTIFICATION]) {
        NSNumber *flagScroll = userInfo[@"canScroll"];
        if (flagScroll.integerValue == 1) {
            self.canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = YES;
        } else {
            self.canScroll = NO;
        }
    } else if ([name isEqualToString:LEAVETOPNOTIFICATION]) {
        self.canScroll = NO;
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.showsVerticalScrollIndicator = NO;
    } else if ([name isEqualToString:CHANGECHILDCONTROLLERINDEXNOTIFICATION]) {
        self.selectedPageIndex = userInfo[@"selectedPageIndex"];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
