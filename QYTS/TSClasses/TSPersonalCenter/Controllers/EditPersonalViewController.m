//
//  EditPersonalViewController.m
//  QYTS
//
//  Created by lxd on 2017/8/31.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "EditPersonalViewController.h"
#import "EditInfoCellModel.h"
#import "EditInfoCell1.h"
#import "EditInfoCell2.h"
#import "EditInfoDatePickerCell.h"
#import "EditInfoSignatureCell.h"
#import "CustomPickerView.h"
#import "BLAreaPickerView.h"
#import "PersonalInfoModel.h"
#import "PersonalViewModel.h"
#import "LocationManagerTool.h"

#define TitleArray @[@[@"昵称：", @"个性签名："], @[@"姓名：", @"性别：", @"生日：", @"身高：", @"体重：", @"所在地："]]
#define SexSelectArray @[@"男", @"女"]

@interface EditPersonalViewController () <BLPickerViewDelegate>
@property (nonatomic, strong) NSMutableArray *infoModelArray;
@property (nonatomic, copy) SavePersonalInfoSuccessBlock savePersonalInfoSuccessBlock;
@property (nonatomic, strong) LocationManagerTool *locationTool;
@end

@implementation EditPersonalViewController
- (instancetype)initWithSaveSuccessBlock:(SavePersonalInfoSuccessBlock)savePersonalInfoSuccessBlock {
    if (self = [super init]) {
        _savePersonalInfoSuccessBlock = savePersonalInfoSuccessBlock;
    }
    return self;
}

- (NSMutableArray *)infoModelArray {
    if (!_infoModelArray) {
        _infoModelArray = @[].mutableCopy;
    }
    return _infoModelArray;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.locationTool) {
        [self.locationTool stopUpdatLocation];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCustomNavBarTitle:@"个人中心" backBtnHidden:NO backBtnIconName:nil navigationBarColor:[UIColor clearColor] titleColor:[UIColor whiteColor] borderColor:[UIColor clearColor] borderWidth:0];
    [self showNavgationBarBottomLine];
    
    [self p_initData];
    
    [self p_createTableView];
    
    if (0 == self.personalInfoModel.city.length) {
        [self p_startUpdatingLocation];
    }
}

- (void)p_startUpdatingLocation {
    LocationManagerTool *locationTool = [[LocationManagerTool alloc] initWithLocationSuccess:^(NSDictionary *locationDict) {
        EditInfoCellModel *infoCellModel = self.infoModelArray[1][5];
        infoCellModel.content = [NSString stringWithFormat:@"%@%@", locationDict[@"city"], locationDict[@"subLocality"]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self p_updateViewFrameWithIndexPath:indexPath];
    } locationFailedBlock:^{
        
    }];
    [locationTool startUpdatLocation];
    self.locationTool = locationTool;
}

- (void)p_initData {
    [TitleArray enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger idx1, BOOL * _Nonnull stop) {
        NSMutableArray *sectionArray = @[].mutableCopy;
        [subArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx2, BOOL * _Nonnull stop) {
            EditInfoCellModel *infoCellModel = [[EditInfoCellModel alloc] init];
            infoCellModel.title = title;
            if (0 == idx1) {
                if (0 == idx2) { // 昵称
                    infoCellModel.content = self.personalInfoModel.nickName;
                } else if (1 == idx2) { // 个性签名
                    infoCellModel.content = self.personalInfoModel.sign;
                }
            }
            
            if (1 == idx1) {
                if (0 == idx2) { // 姓名
                    infoCellModel.content = self.personalInfoModel.name;
                } else if (1 == idx2) { // 性别
                    infoCellModel.content = self.personalInfoModel.sex;
                } else if (2 == idx2) { // 生日
                    infoCellModel.content = self.personalInfoModel.birthday;
                } else if (3 == idx2) { // 身高
                    infoCellModel.content = self.personalInfoModel.height;
                }  else if (4 == idx2) { // 体重
                    infoCellModel.content = self.personalInfoModel.weight;
                } else if (5 == idx2) { // 所在地
                    infoCellModel.content = self.personalInfoModel.city;
                }
            }
            
            [sectionArray addObject:infoCellModel];
        }];
        
        [self.infoModelArray addObject:sectionArray];
    }];
}

- (void)p_createTableView {
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 70, self.view.width, SCREEN_HEIGHT - 70);
    
    CGFloat footerViewH = H(140);
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, footerViewH)];
    CGFloat saveBtnX = W(24.5);
    CGFloat saveBtnW = footerView.width - 2*saveBtnX;
    CGFloat saveBtnH = H(43);
    CGFloat saveBtnY = (footerView.height - saveBtnH)*0.5;
    UIButton *saveBtn = [self createButtonWithTile:@"保存" frame:CGRectMake(saveBtnX, saveBtnY, saveBtnW, saveBtnH)];
    [saveBtn addTarget:self action:@selector(p_saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:saveBtn];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableView delegate ************************************************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infoModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.infoModelArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            EditInfoCell1 *cell = [EditInfoCell1 cellWithTableView:tableView];
            cell.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
            cell.infoCellModel = self.infoModelArray[indexPath.section][indexPath.row];
            return cell;
        } else if (1 == indexPath.row) {
            EditInfoSignatureCell *cell = [EditInfoSignatureCell cellWithTableView:tableView];
            cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            cell.infoCellModel = self.infoModelArray[indexPath.section][indexPath.row];
            return cell;
        }
    } else if (1 == indexPath.section) {
        if (0 == indexPath.row) {
            EditInfoCell1 *cell = [EditInfoCell1 cellWithTableView:tableView];
            cell.rectCornerStyle = UIRectCornerTopLeft | UIRectCornerTopRight;
            cell.infoCellModel = self.infoModelArray[indexPath.section][indexPath.row];
            return cell;
        } else if (2 == indexPath.row) {
            EditInfoDatePickerCell *cell = [EditInfoDatePickerCell cellWithTableView:tableView];
            cell.infoCellModel = self.infoModelArray[indexPath.section][indexPath.row];
            cell.textfieldInputView = TextfieldInputViewDatePicker;
            return cell;
        } else {
            EditInfoCell2 *cell = [EditInfoCell2 cellWithTableView:tableView];
            cell.infoCellModel = self.infoModelArray[indexPath.section][indexPath.row];
            cell.rectCornerStyle = UIRectCornerAllCorners;
            if (indexPath.row == ([self.infoModelArray[indexPath.section] count] - 1)) {
                cell.rectCornerStyle = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            }
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            return H(60);
        } else if (1 == indexPath.row) {
            return H(150);
        }
    } else if (1 == indexPath.section) {
        return H(60);
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, H(44))];
        headerView.backgroundColor = TSHEXCOLOR(0x1b2a47);
        CGFloat titleLabX = W(20);
        CGFloat titleLabY = 0;
        CGFloat titleLabW = W(100);
        CGFloat titleLabH = headerView.height;
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(titleLabX, titleLabY, titleLabW, titleLabH)];
        titleLab.font = [UIFont systemFontOfSize:W(15.0)];
        titleLab.textColor = TSHEXCOLOR(0xffffff);
        titleLab.text = @"实名信息";
        [headerView addSubview:titleLab];
        return headerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        return H(44);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1 == indexPath.section) {
        if (1 == indexPath.row || 3 == indexPath.row || 4 == indexPath.row) {
            NSArray *valueArray = @[];
            NSString *defaultValue = @"";
            EditInfoCellModel *infoCellModel = self.infoModelArray[indexPath.section][indexPath.row];
            if (1 == indexPath.row) {
                valueArray = SexSelectArray;
                if (0 == infoCellModel.content.length) {
                    defaultValue = SexSelectArray[0];
                } else {
                    defaultValue = infoCellModel.content;
                }
            } else if (3 == indexPath.row) { // 身高
                valueArray = [self p_getHeightDataArray];
                if (0 == infoCellModel.content.length) {
                    defaultValue = @"180CM";
                } else {
                    defaultValue = infoCellModel.content;
                }
            } else if (4 == indexPath.row) { // 体重
                valueArray = [self p_getWeightDataArray];
                if (0 == infoCellModel.content.length) {
                    defaultValue = @"70KG";
                } else {
                    defaultValue = infoCellModel.content;
                }
            }
            
            [self scrollToBottom];
            [self p_showPickViewWithValueArray:valueArray defaultValue:defaultValue indexPath:indexPath];
        }
        
        if (5 == indexPath.row) { // 选择地区
            [self p_showAreaPickView];
        }
    }
}

- (void)p_updateViewFrameWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = 0;
        }];
    }
}

- (void)p_showPickViewWithValueArray:(NSArray *)valueArray defaultValue:(NSString *)defaultValue indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = -H(135);
        }];
    }
    
    CustomPickerView *pickView = [[CustomPickerView alloc] initWithFrame:self.view.bounds pickerViewType:PickerViewTypeName valueArray:valueArray returnValue:^(id returnValue) {
        EditInfoCellModel *infoCellModel = self.infoModelArray[indexPath.section][indexPath.row];
        infoCellModel.content = returnValue;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } dismissReturnBlock:^(id returnValue) {
        EditInfoCellModel *infoCellModel = self.infoModelArray[indexPath.section][indexPath.row];
        infoCellModel.content = returnValue;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self p_updateViewFrameWithIndexPath:indexPath];
    }];
    pickView.defaultValue = defaultValue;
    [pickView show];
}

- (void)p_showAreaPickView {
    [self scrollToBottom];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.y = -H(150);
    }];
    BLAreaPickerView *pickView = [[BLAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, H(280))];
    pickView.y = SCREEN_HEIGHT - pickView.height + H(60);
    pickView.pickViewDelegate = self;
    [pickView bl_show];
}

#pragma mark - BLPickerViewDelegate ************************************************************
- (void)bl_selectedAreaResultWithProvince:(NSString *)provinceTitle city:(NSString *)cityTitle area:(NSString *)areaTitle{
    EditInfoCellModel *infoCellModel = self.infoModelArray[1][5];
    infoCellModel.content = [NSString stringWithFormat:@"%@%@%@", provinceTitle, cityTitle, areaTitle];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self p_updateViewFrameWithIndexPath:indexPath];
}

- (void)bl_cancelButtonClicked {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:1];
    [self p_updateViewFrameWithIndexPath:indexPath];
}

#pragma mark - get pickView data tools method
- (NSArray *)p_getHeightDataArray {
    NSMutableArray *heightArray = @[].mutableCopy;
    for (int i = 100; i < 260; i ++) {
        NSString *heightString = [NSString stringWithFormat:@"%dCM", i];
        [heightArray addObject:heightString];
    }
    
    return heightArray;
}

- (NSArray *)p_getWeightDataArray {
    NSMutableArray *weightArray = @[].mutableCopy;
    for (int i = 30; i < 200; i ++) {
        NSString *weightString = [NSString stringWithFormat:@"%dKG", i];
        [weightArray addObject:weightString];
    }
    
    return weightArray;
}

- (void)p_saveBtnClick:(UIButton *)saveBtn { // 保存修改后的个人信息
    NSMutableDictionary *paramsDict = @{}.mutableCopy;
    [self.infoModelArray enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger idx1, BOOL * _Nonnull stop) {
        [subArray enumerateObjectsUsingBlock:^(EditInfoCellModel *infoCellModel, NSUInteger idx2, BOOL * _Nonnull stop) {
            if (0 == idx1) {
                if (0 == idx2) { // 昵称
                    paramsDict[@"nickName"] = infoCellModel.content;
                } else if (1 == idx2) { // 个性签名
                    paramsDict[@"sign"] = infoCellModel.content;
                }
            }
            
            if (1 == idx1) {
                if (0 == idx2) { // 姓名
                    paramsDict[@"name"] = infoCellModel.content;
                } else if (1 == idx2) { // 性别
                    paramsDict[@"sex"] = infoCellModel.content;
                } else if (2 == idx2) { // 生日
                    paramsDict[@"birthday"] = infoCellModel.content;
                } else if (3 == idx2) { // 身高
                    paramsDict[@"height"] = infoCellModel.content;
                }  else if (4 == idx2) { // 体重
                    paramsDict[@"weight"] = infoCellModel.content;
                } else if (5 == idx2) { // 所在地
                    paramsDict[@"city"] = infoCellModel.content;
                }
            }
        }];
    }];
    
    DDLog(@"paramsDict is:%@", paramsDict);
    PersonalViewModel *personalViewModel = [[PersonalViewModel alloc] initWithPramasDict:paramsDict];
    [personalViewModel setBlockWithReturnBlock:^(id returnValue) {
        DDLog(@"updateSsoUser returnValue is:%@", returnValue);
        self.savePersonalInfoSuccessBlock ? self.savePersonalInfoSuccessBlock() : nil;
        [SVProgressHUD showInfoWithStatus:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } WithErrorBlock:^(id errorCode) {
        [SVProgressHUD showInfoWithStatus:errorCode];
    } WithFailureBlock:^{
    }];
    [personalViewModel updateSsoUser];
}
@end
