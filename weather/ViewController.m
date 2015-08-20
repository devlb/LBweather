//
//  ViewController.m
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "ViewController.h"
#import "NetworkTool.h"
#import "WeatherData.h"
#import "WeatherItm.h"
#import "Weather.h"
#import "ViewController.h"
#import "AddCityController.h"
#import "MBProgressHUD.h"

//Github源码地址 https://github.com/LBhub/LBweather.git
//联系邮箱:devlibo@163.com
//欢迎指正问题

@interface ViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate>
{
    UIView *headView;
    UILabel *cityLabel;
    UILabel *timeLabel;
    CGSize mainSize;
}

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIView *weatherView;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *typeLabel;
@property (strong,nonatomic) UILabel *temperatureLabel;
@property (strong,nonatomic) UILabel *minLabel;
@property (strong,nonatomic) UILabel *maxLabel;
@property (strong,nonatomic) WeatherData *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainSize = self.view.frame.size;
   
    [self addHeadView];
    [self addWeatherView];
    [self addTableView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPullDown:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}

- (void)addHeadView{
    [self.navigationController.navigationBar setTranslucent:YES];
    
    CGFloat headViewH = 44;
    CGFloat btnH = 22;
    CGFloat labelH = 22;
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainSize.width, headViewH)];
    headView.backgroundColor = [UIColor clearColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(8, (headViewH - btnH) / 2, 60, btnH)];
    
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setTitle:@"+" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont fontWithName:[UILabel new].font.fontName size:23];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(goCityView) forControlEvents:(UIControlEventTouchUpInside)];
    
    cityLabel = [[UILabel alloc] initWithFrame:CGRectMake((mainSize.width - 70)/2, 0, 70, labelH)];
    cityLabel.textColor = [UIColor blackColor];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((mainSize.width - 100) / 2, CGRectGetMaxY(cityLabel.frame), 100, labelH)];
    
    [headView addSubview:btn];
    [headView addSubview:cityLabel];
    [headView addSubview:timeLabel];
    [self.navigationController.navigationBar addSubview:headView];
}

- (void)addTableView{
    [self.view addSubview:[UIView new]];
    CGFloat tableH = 44 * 5;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, mainSize.height - tableH , mainSize.width, tableH) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
}

- (void)addWeatherView{
    CGFloat weatherH = 200;
    CGFloat edge = 8;
    CGFloat imgW = 40;
    CGFloat numW = 90;
    CGFloat minLabelW = 90;
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.weatherView = [[UIView alloc] initWithFrame:CGRectMake(0, mainSize.height - edge - weatherH - 5 * 44, mainSize.width, weatherH)];
    self.weatherView.backgroundColor = [UIColor clearColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(edge, edge, imgW, imgW)];
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 * edge + imgW, edge, numW, imgW)];
    self.typeLabel.textColor = [UIColor whiteColor];;
   // [self.typeLabel sizeToFit];
    
    self.minLabel = [[UILabel alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(self.imageView.frame) + edge, minLabelW, imgW)];
    self.minLabel.textColor = [UIColor whiteColor];
    self.minLabel.adjustsFontSizeToFitWidth = YES;
    
    self.maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(edge + CGRectGetMaxX(self.minLabel.frame), CGRectGetMaxY(self.imageView.frame) + edge, minLabelW, imgW)];
    self.maxLabel.textColor = [UIColor whiteColor];
    self.maxLabel.adjustsFontSizeToFitWidth = YES;
    
    self.temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(self.minLabel.frame) + edge, numW, numW)];
    self.temperatureLabel.font = [UIFont fontWithName:[UILabel new].font.fontName size:60];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    
    [self.weatherView addSubview:self.imageView];
    [self.weatherView addSubview:self.typeLabel];
    [self.weatherView addSubview:self.minLabel];
    [self.weatherView addSubview:self.maxLabel];
    
    [self.weatherView addSubview:self.temperatureLabel];
    [self.navigationController.navigationBar addSubview:self.weatherView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsCompact)];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    int num = rand()%4;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"show_image_%d.png",num]]];
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"show_image_%d.png",num]]];
    [self loadData];
}

- (void)loadData{
    if (self.cityDic.allValues.count < 1) {
        [[[UIAlertView alloc] initWithTitle:@"还未选择城市" message:@"请先选择城市" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
   cityLabel.text = [[self.cityDic allKeys] firstObject];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkTool sharedNetworkTool] getInfoWithCityID:self.cityDic.allValues[0] success:^(Weather *d) {
        //[hud hide:YES];
        weakSelf.data = d.data;
        WeatherItm *itm = weakSelf.data.forecast[0];
        dispatch_sync(dispatch_get_main_queue(), ^{
            timeLabel.text = itm.date;
            //TODO:部分图标缺少
            NSString *imgName = [NSString stringWithFormat:@"weather_icon.bundle/icon/detail_186x186/%@.png",itm.type];
            weakSelf.imageView.image = [UIImage imageNamed:imgName];
            weakSelf.typeLabel.text = itm.type;
            weakSelf.minLabel.text = [itm.low substringFromIndex:2];
            weakSelf.maxLabel.text = [itm.high substringFromIndex:2];
            weakSelf.temperatureLabel.text = weakSelf.data.wendu;
            [weakSelf.tableView reloadData];
        });
        
    } failure:^{
        [[[UIAlertView alloc] initWithTitle:@"加载失败" message:@"加载失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }];
}

- (void)goCityView{
    AddCityController *cityVC = [[AddCityController alloc] init];
    cityVC.vc = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self goCityView];
}

-(void)onPullDown:(UIPanGestureRecognizer *)pan{
    NSLog(@"下拉刷新");
    CGPoint translation = [pan translationInView:self.view];
    
    pan.view.center = CGPointMake(self.view.center.x,
                                  pan.view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self.view];

    if (translation.y < 0 ) {
       // translation.y = 0;
        return;
    }else if (translation.y >= 40){
        translation.y = 40;
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        [UIView  animateWithDuration:0.4 animations:^{
            pan.view.center = CGPointMake(mainSize.width / 2, mainSize.height/2);
        }];
        [self loadData];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.data) ?  self.data.forecast.count: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeatherItm *itm = self.data.forecast[indexPath.row];
    
    static NSString *identifier = @"otherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = itm.date;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ~ %@",[itm.low substringFromIndex:2],[itm.high substringFromIndex:2]];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imgView.center = cell.center;
    NSString *imgName = [NSString stringWithFormat:@"weather_icon.bundle/icon/detail_186x186/%@.png",itm.type];
    imgView.image = [UIImage imageNamed:imgName];
    [cell.contentView addSubview:imgView];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
