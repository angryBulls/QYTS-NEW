//
//  PersonalCenterViewController.m
//  QYTS
//
//  Created by lxd on 2017/8/29.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterCell.h"
#import "PersonalHeaderView.h"
#import "EditPersonalViewController.h"
#import "AccountSetViewController.h"
#import "PersonalViewModel.h"
#import "PersonalInfoModel.h"
#import "MyGameMainViewController.h"
#import "CreatedTeamViewController.h"

#define DataArray @[@[@"my_game_icon", @"我的比赛"], @[@"created_teams_icon", @"创建过的球队"], @[@"account_setup_icon", @"账号设置"], @[@"service_phone_icon", @"客服电话：400-631-3677"]]

@interface PersonalCenterViewController () <PersonalHeaderViewDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) PersonalInfoModel *personalInfoModel;
@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    
    [self p_createTableView];
    [self createRightBarButtonWithImageName:@"edit_personal_info_icon"];
    
    [self p_getSsoUserDetail];
}

- (void)rightBarBtnClick {
    EditPersonalViewController *editVC = [[EditPersonalViewController alloc] initWithSaveSuccessBlock:^{
        [self p_getSsoUserDetail];
    }];
    editVC.personalInfoModel = self.personalInfoModel;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)p_getSsoUserDetail {
    [SVProgressHUD show];
    NSMutableDictionary *paramsDict = @{}.mutableCopy;
    PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
    [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"getSsoUserDetail returnValue is:%@", returnValue);
        self.personalInfoModel = returnValue;
        [self p_getUserMatchCount];
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [personalViewModel getSsoUserDetail];
}

- (void)p_getUserMatchCount {
    NSMutableDictionary *paramsDict = @{}.mutableCopy;
    PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
    [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
        [SVProgressHUD dismiss];
        DDLog(@"getUserMatchCount returnValue is:%@", returnValue);
        if ([returnValue[@"entity"] count]) {
            self.personalInfoModel.finishCount = [NSString stringWithFormat:@"%@", returnValue[@"entity"][@"finishCount"]];
            self.personalInfoModel.newcount = [NSString stringWithFormat:@"%@", returnValue[@"entity"][@"newCount"]];
        }
        PersonalHeaderView *headerView = (PersonalHeaderView *)self.tableView.tableHeaderView;
        headerView.personalInfoModel = self.personalInfoModel;
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
        [SVProgressHUD dismiss];
    }];
    [personalViewModel getUserMatchCount];
}

- (void)p_createTableView {
    self.dataArray = DataArray;
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, self.view.width, SCREEN_HEIGHT);
    self.tableView.rowHeight = H(60);
    [self.view sendSubviewToBack:self.tableView];
    
    PersonalHeaderView *headerView = [[PersonalHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(330))];
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - UITableView delegate ************************************************************************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalCenterCell *cell = [PersonalCenterCell cellWithTableView:tableView];
    cell.contentArray = self.dataArray[indexPath.row];
    if (0 == indexPath.row) {
        cell.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
    } else if (indexPath.row == self.dataArray.count - 1) {
        cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    } else {
        cell.rectCornerStyle = UIRectCornerAllCorners;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        MyGameMainViewController *myGameMainVC = [[MyGameMainViewController alloc] init];
        [self.navigationController pushViewController:myGameMainVC animated:YES];
    }
    
    if (1 == indexPath.row) {
        CreatedTeamViewController *createdTeamVC = [[CreatedTeamViewController alloc] init];
        [self.navigationController pushViewController:createdTeamVC animated:YES];
    }
    
    if (2 == indexPath.row) {
        AccountSetViewController *accountSetVC = [[AccountSetViewController alloc] init];
        [self.navigationController pushViewController:accountSetVC animated:YES];
    }
    
    if (3 == indexPath.row) {
        NSMutableString *numbStr = [[NSMutableString alloc]initWithFormat:@"telprompt://%@",ServiceTelephone];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:numbStr]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    // 偏移的y值
    if(yOffset < 0) {
        CGFloat totalOffset = (SCREEN_HEIGHT - 64) * 0.53 + ABS(yOffset);
        CGFloat f = totalOffset / ((SCREEN_HEIGHT - 64) * 0.53);
        //拉伸后的图片的frame应该是同比例缩放。
        PersonalHeaderView *headerView = (PersonalHeaderView *)self.tableView.tableHeaderView;
        headerView.bgImageView.frame =  CGRectMake(- (self.view.width * f - self.view.width) / 2, yOffset, self.view.width * f, totalOffset);
    }
}

#pragma mark - PersonalHeaderViewDelegate ******************************************************************
- (void)gameStatusSelect:(int)statusType {
    MyGameMainDefaultVC defaultVC = MyGameMainDefaultVCGameOver;
    if (1 == statusType) {
        defaultVC = MyGameMainDefaultVCUnCheck;
    }
    MyGameMainViewController *myGameMainVC = [[MyGameMainViewController alloc] init];
    myGameMainVC.defaultVC = defaultVC;
    [self.navigationController pushViewController:myGameMainVC animated:YES];
}
@end
