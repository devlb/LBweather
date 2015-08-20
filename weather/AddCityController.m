//
//  AddCityController.m
//  weather
//
//  Created by lb on 15/8/20.
//  Copyright (c) 2015年 李波. All rights reserved.
//

#import "AddCityController.h"
#define HEADERVIEWTAG 200
#define TABLEVIEWTAG 201
#define RESULTTABLEVIEWTAG 202
#define CELLHEADVIEWH 44

@interface AddCityController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (strong,nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic) NSDictionary *cityDic;
@property (strong,nonatomic) NSMutableArray *cityArr;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *showArr;
@property (assign,nonatomic) CGSize mainSize;
@property (strong,nonatomic) UITableView *resultTableView;
@property (strong,nonatomic) NSMutableArray *resultArr;
@end

@implementation AddCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addData];
    [self addUI];
    self.navigationController.navigationBarHidden = YES;
}

- (void)addData{
    self.mainSize = self.view.frame.size;
     NSString *cityPath = [[NSBundle mainBundle]pathForResource:@"cityList.plist" ofType:nil];
    self.cityDic = [NSDictionary dictionaryWithContentsOfFile:cityPath];
    
    NSString *provincePath = [[NSBundle mainBundle]pathForResource:@"ProvinceCity.plist" ofType:nil];
    NSDictionary *provinceDic = [NSDictionary dictionaryWithContentsOfFile:provincePath];
    
    self.showArr = [NSMutableArray array];
    self.cityArr = [NSMutableArray array];
    for (NSString *provinceName in provinceDic.allKeys) {
        NSMutableArray *arr = [NSMutableArray arrayWithObject:provinceName];
        [self.showArr addObject:@NO];
        for (NSString *cityName in provinceDic[provinceName]) {
            [arr addObject:cityName];
        }
        [self.cityArr addObject:arr];
    }
    
}

- (void)addUI{
    CGFloat edge = 8;
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.mainSize.width, 44)];
    self.searchBar.placeholder = @"请输入城市名";
    self.searchBar.translucent = YES;
    [self.searchBar setShowsCancelButton:YES];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame) + edge, self.mainSize.width, self.mainSize.height - CGRectGetMaxY(self.searchBar.frame) - 8) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tag = TABLEVIEWTAG;
    [self.view addSubview:self.tableView];
    
    self.resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame) + edge, self.mainSize.width, self.mainSize.height - CGRectGetMaxY(self.searchBar.frame) - 8) style:(UITableViewStyleGrouped)];
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.tag = RESULTTABLEVIEWTAG;

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.resultTableView];
    [self.resultTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.resultArr = [NSMutableArray array];
    for (NSArray *citys in self.cityArr) {
        for (NSString *cityName in citys) {
            if ([cityName  containsString:searchText]) {
                if ([cityName isEqual:citys[0]]) {//输入省时
                    for (int i = 1;i < citys.count;i++) {
                        NSString *tmp = citys[i];
                        [self.resultArr addObject:@{citys[0]:tmp}];
                    }
                }else{
                    [self.resultArr addObject:@{citys[0]:cityName}];
                }
                
                [self.resultTableView reloadData];
            }
        }
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == RESULTTABLEVIEWTAG) {//搜索
        return self.resultArr.count;
    }
    
    if ([self.showArr[section] boolValue] == YES) {
        return [self.cityArr[section] count] - 1;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == RESULTTABLEVIEWTAG) {
        return 1;
    }
    
    if (tableView.tag == TABLEVIEWTAG) {
        return  self.cityArr.count;
    }else{
    
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == RESULTTABLEVIEWTAG) {
         return [self getResultCellWithTable:tableView indexPath:indexPath];
    }
    
    static  NSString *identifier = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
                                           
    cell.textLabel.text  = self.cityArr[indexPath.section][indexPath.row + 1];
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell *)getResultCellWithTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static  NSString *identifier = @"resultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    NSDictionary *dic = self.resultArr[indexPath.row];
    cell.textLabel.text = [dic.allKeys firstObject];
    cell.detailTextLabel.text = [dic.allValues firstObject];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CELLHEADVIEWH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == RESULTTABLEVIEWTAG) {
        return [UIView new];
    }
    
    CGFloat edge = 8;
    CGFloat imgW = CELLHEADVIEWH - 2 * edge;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.mainSize.width, CELLHEADVIEWH - 0)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = HEADERVIEWTAG + section;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, edge,100,44 - edge * 2)];
    label.text = self.cityArr[section][0];
    
    NSString *imgStr = ([self.showArr[section] boolValue]) ?  @"up2" : @"down2";
    UIImage *img = [UIImage imageNamed:imgStr];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.mainSize.width - edge - imgW, edge, imgW, imgW)];
    imageView.image = img;
    imageView.userInteractionEnabled = YES;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CELLHEADVIEWH-1, self.mainSize.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tap.delegate = self;
    [view addGestureRecognizer:tap];
    
    [view addSubview:label];
    [view addSubview:imageView];
    [view addSubview:line];
    return view;

}

- (void)onTap:(UITapGestureRecognizer *)tap{
    int index = tap.view.tag - HEADERVIEWTAG;
    BOOL status = [self.showArr[index] boolValue];
    
    self.showArr[index] = [NSNumber numberWithBool:!status];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *cityName;
    if (tableView.tag == RESULTTABLEVIEWTAG) {
        cityName = [[self.resultArr[indexPath.row] allValues] lastObject];
    }else if (tableView.tag == TABLEVIEWTAG){
       cityName = self.cityArr[indexPath.section][indexPath.row + 1];
    }
    
    NSDictionary *dic = @{cityName:self.cityDic[cityName]};
    self.vc.cityDic = dic;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
