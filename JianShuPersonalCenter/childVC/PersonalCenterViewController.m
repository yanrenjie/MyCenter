//
//  PersonalCenterViewController.m
//  JianShuPersonalCenter
//
//  Created by 颜仁浩 on 2020/7/1.
//  Copyright © 2020 Jackey. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "MainTableView.h"
#import "SegmentView.h"
#import "UserInfoView.h"

@interface PersonalCenterViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property(nonatomic, strong)MainTableView *mainTableView;

@property(nonatomic, strong)UIView *contentView;

@property(nonatomic, strong)UIImageView *bgImageView;

@property(nonatomic, strong)UserInfoView *userInfoView;

@property(nonatomic, strong)SegmentView *segmentView;

@property(nonatomic, assign)BOOL canScroll;

@property(nonatomic, assign)BOOL mainTableViewMoveable;

@property(nonatomic, assign)BOOL childTableViewMoveable;

@property(nonatomic, strong)UILabel *personalTitleLabel;

@end

@implementation PersonalCenterViewController

- (MainTableView *)mainTableView {
    if (!_mainTableView) {
        self.canScroll = YES;
        self.mainTableViewMoveable = NO;
        _mainTableView = [[MainTableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.contentInset = UIEdgeInsetsMake(PersonalCenterHeaderH, 0, 0, 0);
    }
    return _mainTableView;
}

- (SegmentView *)segmentView {
    if (!_segmentView) {
        NSArray *vcTitleArray = @[@"OneViewController", @"TwoViewController", @"ThreeViewController", @"FourViewController", @"OneViewController", @"TwoViewController", @"ThreeViewController", @"FourViewController", @"OneViewController", @"TwoViewController", @"ThreeViewController", @"FourViewController", @"OneViewController"];
        NSArray *titleArray = @[@"黑龙江", @"湖北", @"广东", @"乌鲁木齐", @"内蒙古", @"呼和浩特", @"北京", @"天津", @"上海", @"湖南", @"福建", @"呼伦贝尔大草原", @"香港"];
        NSMutableArray *vcArray = [NSMutableArray array];
        for (int i = 0; i < vcTitleArray.count; i++) {
            NSString *name = vcTitleArray[i];
            Class class = NSClassFromString(name);
            UIViewController *tempVC = [class new];
            [tempVC setValue:titleArray[i] forKey:@"zoneName"];
            [vcArray addObject:tempVC];
        }
        _segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH - navH) parentVC:self childVCs:vcArray titles:titleArray selectedIndex:4];
    }
    return _segmentView;
}

- (UILabel *)personalTitleLabel {
    if (!_personalTitleLabel) {
        _personalTitleLabel = [[UILabel alloc] init];
        _personalTitleLabel.textAlignment = NSTextAlignmentCenter;
        _personalTitleLabel.text = @"Jackey的个人中心";
        _personalTitleLabel.font = [UIFont boldSystemFontOfSize:22];
    }
    return _personalTitleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.personalTitleLabel;
    [UIScrollView.appearance setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    
    [self.navigationController.navigationBar setShadowImage:UIImage.new];
    [self.navigationController.navigationBar setBackgroundImage:UIImage.new forBarMetrics:UIBarMetricsDefault];
    [self setupView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(receiveNotification:) name:LEAVETOPNOTIFICATION object:nil];
    [center addObserver:self selector:@selector(receiveNotification:) name:MAINVIEWSCROLLABLENOTIFICATION object:nil];
}

- (void)setupView {
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 400)];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenW, 200)];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    bgImageView.image = [UIImage imageNamed:@"feifei.jpeg"];
    self.bgImageView = bgImageView;

    UserInfoView *userInfoView = [UserInfoView userInfoView];
    userInfoView.frame = CGRectMake(0, 170, screenW, 230);
    self.userInfoView = userInfoView;
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView addSubview:self.contentView];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.userInfoView];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.segmentView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return screenH - navH;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainTableView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat tabOffsetY = [self.mainTableView rectForSection:0].origin.y - navH;
        CGFloat alpha = 0;
        if (-offsetY <= navH) {
            alpha = 1;
        } else if ((-offsetY > navH) && -offsetY < PersonalCenterHeaderH) {
            alpha = (PersonalCenterHeaderH + offsetY) / (PersonalCenterHeaderH - navH);
        } else {
            alpha = 0;
        }
        
        UIColor *color = [UIColor.orangeColor colorWithAlphaComponent:alpha];
        UIImage *image = [self imageWithColor:color];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.personalTitleLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:alpha];
        
        //
        if (offsetY >= tabOffsetY) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            self.mainTableViewMoveable = YES;
        } else {
            self.mainTableViewMoveable = NO;
        }
        
        self.childTableViewMoveable = !self.mainTableViewMoveable;
        if (self.childTableViewMoveable) {
            if (!self.canScroll) {
                self.mainTableView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:ARRIVETOPNOTIFICATION object:nil userInfo:@{@"canScroll" : @1}];
            self.canScroll = NO;
        }
        
        if (offsetY <= -PersonalCenterHeaderH) {
            // 头部整体UI更新
            CGRect f = self.contentView.frame;
            f.origin.y = offsetY;
            f.size.height = -offsetY;
            f.origin.x = (offsetY * screenW / PersonalCenterHeaderH + screenW) / 2;
            f.size.width = -offsetY * screenW / PersonalCenterHeaderH;
            self.contentView.frame = f;
            
            // 更新背景图UI
            CGRect imageRect = self.bgImageView.frame;
            imageRect.size.height = self.contentView.frame.size.height - 200;
            imageRect.size.width = self.contentView.frame.size.width;
            imageRect.origin.x = 0;
            self.bgImageView.frame = imageRect;
            
            // 更新个人信息部分的UI
            CGRect userInfoRect = self.userInfoView.frame;
            userInfoRect.size.width = screenW;
            userInfoRect.size.height = 230;
            userInfoRect.origin.x = (self.contentView.frame.size.width - screenW) * 0.5;
            userInfoRect.origin.y = self.contentView.frame.size.height - 230;
            self.userInfoView.frame = userInfoRect;
        }
    }
}


- (void)receiveNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *flag = userInfo[@"canScroll"];
    if ([notification.name isEqualToString:LEAVETOPNOTIFICATION]) {
        if (flag.integerValue == 1) {
            self.canScroll = YES;
        }
    } else if ([notification.name isEqualToString:MAINVIEWSCROLLABLENOTIFICATION]) {
        if (flag.integerValue == 1) {
            self.mainTableView.scrollEnabled = YES;
        } else if (flag.integerValue == 0) {
            self.mainTableView.scrollEnabled = NO;
        }
    }
}


- (UIImage *)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    
    // 拉取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 使用color填充上下文
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    // 渲染上下文
    CGContextFillRect(context, rect);
    
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
