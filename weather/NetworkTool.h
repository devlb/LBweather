//
//  NetworkTool.h
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

@interface NetworkTool : NSObject

- (void)getInfoWithCityID:(NSString *)cityID success:(void (^)(Weather *))success failure:(void (^)())failure;

+ (instancetype)sharedNetworkTool;

@end
