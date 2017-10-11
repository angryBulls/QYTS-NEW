//
//  LocationManagerTool.m
//  QYTS
//
//  Created by lxd on 2017/8/30.
//  Copyright © 2017年 longcai. All rights reserved.
//

#import "LocationManagerTool.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface LocationManagerTool () <CLLocationManagerDelegate>
@property (nonatomic, copy) LocationSuccessBlock locationSuccessBlock;
@property (nonatomic, copy) LocationFailedBlock locationFailedBlock;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *currentCity;//城市
@property (nonatomic, copy) NSString *strLatitude;//经度
@property (nonatomic, copy) NSString *strLongitude;//维度
@end

@implementation LocationManagerTool
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 1000.0f;
    }
    return _locationManager;
}

- (instancetype)initWithLocationSuccess:(LocationSuccessBlock)locationSuccessBlock locationFailedBlock:(LocationFailedBlock)locationFailedBlock {
    if (self = [super init]) {
        _locationSuccessBlock = locationSuccessBlock;
        _locationFailedBlock = locationFailedBlock;
    }
    return self;
}

- (void)startUpdatLocation {
    [self p_locatemap];
}

- (void)stopUpdatLocation {
    [_locationManager stopUpdatingLocation];
}

- (void)p_locatemap {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [_locationManager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    DDLog(@"当前的经纬度 %f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    //这里的代码是为了判断didUpdateLocations调用了几次 有可能会出现多次调用 为了避免不必要的麻烦 在这里加个if判断 如果大于1.0就return
    NSTimeInterval locationAge = -[currentLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 1.0){ //如果调用已经一次，不再执行
        return;
    }
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
            if (!_currentCity) {
                _currentCity = @"无法定位当前城市";
                self.locationFailedBlock ? self.locationFailedBlock() : nil;
                return;
            }
            
            NSMutableDictionary *locationDict = [NSMutableDictionary dictionary];
            locationDict[@"country"] = placeMark.country;
            locationDict[@"city"] = _currentCity;
            locationDict[@"subLocality"] = placeMark.subLocality;
            //看需求定义一个全局变量来接收赋值
            DDLog(@"当前国家 - %@",placeMark.country);//当前国家
            DDLog(@"当前城市 - %@",_currentCity);//当前城市
            DDLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
            DDLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
            DDLog(@"具体地址 - %@",placeMark.name);//具体地址
//            NSString *message = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placeMark.country,_currentCity,placeMark.subLocality,placeMark.thoroughfare,placeMark.name];
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
//            [alert show];
            
            self.locationSuccessBlock ? self.locationSuccessBlock(locationDict) : nil;
        } else if (error == nil && placemarks.count){
            self.locationFailedBlock ? self.locationFailedBlock() : nil;
        } else if (error) {
            self.locationFailedBlock ? self.locationFailedBlock() : nil;
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [_locationManager stopUpdatingLocation];
    self.locationFailedBlock ? self.locationFailedBlock() : nil;
}
@end
