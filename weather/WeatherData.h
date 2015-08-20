//
//  Weatherinfo.h
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"
#import "WeatherItm.h"

@interface WeatherData : JsonModel

@property (strong,nonatomic) NSString *wendu;
@property (strong,nonatomic) NSString *ganmao;
@property (strong,nonatomic) NSArray *forecast;
@property (strong,nonatomic) NSString *city;
@property (strong,nonatomic) NSString *aqi;
@property (strong,nonatomic) WeatherItm *yesterday;

@end
