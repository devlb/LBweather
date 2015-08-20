//
//  JsonModel.m
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "JsonModel.h"

@implementation JsonModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    [super setValuesForKeysWithDictionary:dic];
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@没找到:key:%@  value:%@",[self class],key,value);
}

@end
