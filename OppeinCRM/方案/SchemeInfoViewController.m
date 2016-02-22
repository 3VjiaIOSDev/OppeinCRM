//
//  SchemeInfoViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/14.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "SchemeInfoViewController.h"

@interface SchemeInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *dataArr;
    NSArray *dataArr1;
    NSArray *images;
}
@end

@implementation SchemeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArr = @[@"方案名称",@"方案空间",@"风格",@"空间户型",@"空间面积",@"方案预算"];
    NSNumber *budget = self.dicData[@"Budget"];
    dataArr1 = @[self.dicData[@"SchemeName"],
                 self.dicData[@"SpaceName"],
                 self.dicData[@"Style"],
                 self.dicData[@"RoomType"],
                 self.dicData[@"Area"],
                 [NSString stringWithFormat:@"%@",budget]];
    images = self.dicData[@"FileList"];
    
    [self initNavigation];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    table.delegate = self;
    table.dataSource = self;
    [self setExtraCellLineHidden:table];
    
    [self.view addSubview:table];
    
}
//tableView 优化
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化导航栏
-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.title = @"方案详情";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == dataArr.count) {
        return 80;
    }
    else
        return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count+1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idenfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row != dataArr.count) {
        cell.textLabel.text = [dataArr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.text = [dataArr1 objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    else
    {
        [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15+idx*80, 10, 60, 60)];
            NSString *imagePath = [NSString stringWithFormat:@"%@%@",imagePathURL,obj[@"FileFullPath"]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"少女情怀.jpg"]];
            [cell.contentView addSubview:imageView];
        }];
    }
    return cell;
}
@end
