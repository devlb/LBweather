//
//  NetworkTool.m
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "NetworkTool.h"

@implementation NetworkTool

static NetworkTool *tool;

+ (instancetype)sharedNetworkTool{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
       tool  = [[self alloc] init];
    });
    return tool;
}

- (void)getInfoWithCityID:(NSString *)cityID success:(void (^)(Weather *weather))success failure:(void (^)())failure{
 //   http://m.weather.com.cn/atad/101090801.html
    NSString *urlStr = [NSString stringWithFormat:@"http://wthrcdn.etouch.cn/weather_mini?citykey=%@",cityID];
    NSLog(@"url:%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
   [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       if (connectionError) {
           failure();
       }else{
           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
           
           Weather *t = [[Weather alloc] initWithDictionary:dic];
           success(t);
       }
    }];

}



@end
