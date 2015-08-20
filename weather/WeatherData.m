//
//  Weatherinfo.m
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "WeatherData.h"
#import "WeatherItm.h"

@implementation WeatherData

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"forecast"]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            [arr addObject:[[WeatherItm alloc] initWithDictionary:dic]];
        }
        self.forecast = arr;
    }else{
        [super setValue:value forKey:key];
    }

}

@end
