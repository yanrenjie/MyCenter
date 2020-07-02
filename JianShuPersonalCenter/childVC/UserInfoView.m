//
//  UserInfoView.m
//  JianShuPersonalCenter
//
//  Created by 颜仁浩 on 2020/6/30.
//  Copyright © 2020 Jackey. All rights reserved.
//

#import "UserInfoView.h"

@interface UserInfoView ()
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *QRCodeImageView;

@end

@implementation UserInfoView

+ (instancetype)userInfoView {
    return [[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editBtn.layer.masksToBounds = YES;
    self.editBtn.layer.borderWidth = 1;
    self.editBtn.layer.borderColor = UIColor.greenColor.CGColor;
    self.editBtn.layer.cornerRadius = 20;
    
    self.QRCodeImageView.layer.borderWidth = 1;
    self.QRCodeImageView.layer.borderColor = UIColor.orangeColor.CGColor;
    self.QRCodeImageView.layer.masksToBounds = YES;
    self.QRCodeImageView.layer.cornerRadius = 20;
    
    [self.QRCodeImageView setTintColor:UIColor.orangeColor];
}

@end
