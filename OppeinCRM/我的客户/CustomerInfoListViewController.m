//
//  CustomerInfoListViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "CustomerInfoListViewController.h"
#import "NSAlertView.h"
#import "AFLoadIngView.h"

@interface CustomerInfoListViewController ()
{
    AFLoadIngView *afloading;
}
@end

@implementation CustomerInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customerBaseAry = [[NSArray alloc]initWithObjects:@"姓名",@"移动手机",@"备用手机",@"电子邮件",@"QQ",@"家庭住址", nil];
    // self.baseAry = [[NSMutableArray alloc]initWithArray:self.customerBaseAry];
    self.customerIntentionAry = [[NSArray alloc]initWithObjects:@"客户来源",@"客户类型",@"导购",@"设计师",@"装企设计师",@"业务员",@"预算金额",@"预约量尺时间",@"预算购买产品", nil];
    // self.intentionAry = [[NSMutableArray alloc]initWithArray:self.customerIntentionAry];
    self.customerRoomAry = [[NSArray alloc]initWithObjects:@"房屋类型",@"房屋户型",@"平方价",@"预估交房时间",@"所属楼盘", nil];
    // self.roomAry = [[NSMutableArray alloc]initWithArray:self.customerRoomAry];
    self.customerInfoListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-30) style:UITableViewStyleGrouped];
    self.customerInfoListTable.delegate = self;
    self.customerInfoListTable.dataSource = self;
    [self.view addSubview:self.customerInfoListTable];
    // Do any additional setup after loading the view.
    
    [self initNavigation];
    [self getCustomerInfo];

}
#pragma mark 初始化导航栏

-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [navigationItem setTitle:@"查看客户详情"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //把导航栏集合添加入导航栏中，设置动画关闭
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

#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.baseAry.count;
    }
    if (section == 1) {
        return self.intentionAry.count;
    }
    else
        return self.roomAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        if (indexPath.section == 0) {
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(20, 10, 100, 20) text:[self.customerBaseAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO];
            
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(150, 10, self.view.frame.size.width-170, 20) text:[self.baseAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentRight isNumLine:NO];
            
        }
        if (indexPath.section == 1) {
            //cell.textLabel.text = [self.customerIntentionAry objectAtIndex:indexPath.row];
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(20, 10, 100, 20) text:[self.customerIntentionAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO];
            
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(150, 10, self.view.frame.size.width-170, 20) text:[self.intentionAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentRight isNumLine:NO];
        }
        if (indexPath.section ==2) {
            //cell.textLabel.text = [self.customerRoomAry objectAtIndex:indexPath.row];
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(20, 10, 100, 20) text:[self.customerRoomAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentLeft isNumLine:NO];
            
            [NSAlertView initLabelView:cell.contentView frame:CGRectMake(150, 10, self.view.frame.size.width-170, 20) text:[self.roomAry objectAtIndex:indexPath.row] font:14.0f alignment:NSTextAlignmentRight isNumLine:NO];
        }
    }
    return cell;
}

#pragma mark 客户详细信息数据请求

-(void)getCustomerInfo
{
    self.baseAry = [[NSMutableArray alloc]init];
    self.intentionAry = [[NSMutableArray alloc]init];
    self.roomAry = [[NSMutableArray alloc]init];
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    NSDictionary *dict = @{@"authCode":code,@"customerId":self.CustomerId,@"serviceId":self.ServiceId};
    [HttpRequset post:dict method:@"Customer/GetCustomerInfo" completionBlock:^(id obj) {
         [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [dic[@"JSON"]objectFromJSONString];
            NSDictionary *CustomeInfo = [JSON objectForKey:@"CustomeInfo"];
            name = [CustomeInfo objectForKey:@"CustomerName"];
            [self.baseAry addObject:name];
            
            phone1 = [CustomeInfo objectForKey:@"Mobile"];
            [self.baseAry addObject:phone1];
            phone2 = [CustomeInfo objectForKey:@"NMobile"];
            [self.baseAry addObject:phone2];
            
            
            NSDictionary *CustomerService = [JSON objectForKey:@"CustomerService"];
            email = [CustomerService objectForKey:@"Email"];
            [self.baseAry addObject:email];
            qq = [CustomerService objectForKey:@"QQ"];
            [self.baseAry addObject:qq];
            
            NSString *Province = [CustomeInfo objectForKey:@"Province"];
            NSString *City = [CustomeInfo objectForKey:@"City"];
            NSString *CArea = [CustomeInfo objectForKey:@"CArea"];
            NSString *Address = [CustomeInfo objectForKey:@"Address"];
            
            addr = [NSString stringWithFormat:@"%@%@%@%@",Province,City,CArea,Address];
            [self.baseAry addObject:addr];
            
            customerSource = [CustomerService objectForKey:@"CustomerSource"];
            [self.intentionAry addObject:customerSource];
            
            customerType = [CustomerService objectForKey:@"CustomerType"];
            [self.intentionAry addObject:customerType];
            
            shoppingGuide = [CustomerService objectForKey:@"SalesPerson"];
            [self.intentionAry addObject:shoppingGuide];
            
            designer = [CustomerService objectForKey:@"Designer"];
            [self.intentionAry addObject:designer];
            
            decDesigner = [CustomerService objectForKey:@"AllianceDesigner"];
            [self.intentionAry addObject:decDesigner];
            
            salesman = [CustomerService objectForKey:@"Promoter"];
            [self.intentionAry addObject:salesman];
            
            NSNumber *Budget = [CustomerService objectForKey:@"Budget"];
            budgetCoust = [NSString stringWithFormat:@"%.1f",[Budget floatValue]];
            [self.intentionAry addObject:budgetCoust];
            
            budgetTime = @"";//[CustomerService objectForKey:@"MeasueTime"];
            [self.intentionAry addObject:budgetTime];
            budgetProducts = [CustomerService objectForKey:@"BuyWill"];
            [self.intentionAry addObject:budgetProducts];
            
            
            roomType = [CustomerService objectForKey:@"HouseType"];
            [self.roomAry addObject:roomType];
            
            roomApart = [CustomerService objectForKey:@"RoomType"];
            [self.roomAry addObject:roomApart];
            
            NSNumber *p = [CustomerService objectForKey:@"SquarePrice"];
            price = [NSString stringWithFormat:@"%.1f",[p floatValue]];
            [self.roomAry addObject:price];
            
            deliveryTime = @"";//[CustomerService objectForKey:@"GetHouseTime"];
            [self.roomAry addObject:deliveryTime];
            
            property = [CustomerService objectForKey:@"HousesName"];
            [self.roomAry addObject:property];
            
            [self.customerInfoListTable reloadData];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
