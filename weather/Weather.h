//
//  WeatherInfo.h
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"
#import "JsonModel.h"

@interface Weather : JsonModel

@property (strong,nonatomic) WeatherData *data;
@property (strong,nonatomic) NSString *desc;
@property (strong,nonatomic) NSString *status;


@end
