//
//  AccountSetViewController.m
//  QYTS
//
//  Created by lxd on 2017/9/1.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "AccountSetViewController.h"
#import "EditInfoCellModel.h"
#import "AccountSetCell.h"
#import "AccountSetPhoneViewController.h"
#import "AccountSetChangePDViewController.h"

#define TitleArray @[@"手机号：", @"密码："]

@interface AccountSetViewController ()
@property (nonatomic, strong) NSMutableArray *infoModelArray;
@end

@implementation AccountSetViewController
- (NSMutableArray *)infoModelArray {
    if (!_infoModelArray) {
        _infoModelArray = @[].mutableCopy;
    }
    return _infoModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"账号设置" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    [self showNavgationBarBottomLine];
    
    [self p_initData];
    
    [self p_createTableView];
}

- (void)p_initData {
    int currentUserType = [[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLoginUserType] intValue];
    [TitleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        EditInfoCellModel *infoCellModel = [[EditInfoCellModel alloc] init];
        infoCellModel.title = title;
        if (currentUserType == LoginUserTypeNormal) {
            TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
            if (0 == idx) {
                infoCellModel.content = userInfo.phone;
            } else {
                infoCellModel.content = userInfo.password;
            }
        } else if (currentUserType == LoginUserTypeBCBC) {
            TSUserInfoModelBCBC *userInfo = [TSToolsMethod fetchUserInfoModelBCBC];
            if (0 == idx) {
                infoCellModel.content = userInfo.loginName;
            } else {
                infoCellModel.content = userInfo.password;
            }
        }
        
        DDLog(@"infoCellModel.content is:%@", infoCellModel.content);
        [self.infoModelArray addObject:infoCellModel];
    }];
}

- (void)p_createTableView {
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 70, self.view.width, SCREEN_HEIGHT - 70);
    self.tableView.rowHeight = H(60);
}

#pragma mark - UITableView delegate ************************************************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountSetCell *cell = [AccountSetCell cellWithTableView:tableView];
    cell.infoCellModel = self.infoModelArray[indexPath.row];
    if (0 == indexPath.row) {
        cell.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
    } else {
        cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }
    if (indexPath.row == self.infoModelArray.count - 1) {
        cell.bottomLine.hidden = YES;
    } else {
        cell.bottomLine.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditInfoCellModel *infoCellModel = self.infoModelArray[0];
    if (0 == indexPath.row) {
        AccountSetPhoneViewController *setPhoneVC = [[AccountSetPhoneViewController alloc] initWithBlock:^{
            TSUserInfoModelNormal *userInfo = [TSToolsMethod fetchUserInfoModelNormal];
            infoCellModel.content = userInfo.phone;
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:setPhoneVC animated:YES];
    } else if (1 == indexPath.row) {
        AccountSetChangePDViewController *changePDVC = [[AccountSetChangePDViewController alloc] init];
        changePDVC.phone = infoCellModel.content;
        [self.navigationController pushViewController:changePDVC animated:YES];
    }
}
@end
