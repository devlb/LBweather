//
//  WeatherInfo.m
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "Weather.h"
#import "WeatherData.h"

@implementation Weather

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqual:@"data"]) {
        self.data = [[WeatherData alloc] initWithDictionary:value];
    }else{
         [super setValue:value forKey:key];
    }
    
}



@end
