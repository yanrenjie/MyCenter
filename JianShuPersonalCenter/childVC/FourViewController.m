//
//  FourViewController.m
//  JianShuPersonalCenter
//
//  Created by 颜仁浩 on 2020/6/30.
//  Copyright © 2020 Jackey. All rights reserved.
//

#import "FourViewController.h"

@interface FourViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  ----  %ld  ----  %ld", self.zoneName, indexPath.section, indexPath.row];
    return cell;
}

@end
