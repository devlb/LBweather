//
//  WeatherItm.h
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@interface WeatherItm : JsonModel

@property (strong,nonatomic) NSString *fengxiang;
@property (strong,nonatomic) NSString *fengli;
@property (strong,nonatomic) NSString *high;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *low;
@property (strong,nonatomic) NSString *date;

@end
