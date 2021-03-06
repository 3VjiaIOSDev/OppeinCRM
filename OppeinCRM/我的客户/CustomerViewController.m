//
//  CustomerViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "CustomerViewController.h"
#import "CustomerInfoViewController.h"
#import "AddNewCustomerViewController.h"

@interface CustomerViewController ()
{
    NSInteger carMakesIndex;
    NSArray *carMakes1;
    AFLoadIngView *afloading;
}

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    isFlash = NO;
    [self initData];
    [self initNavigation];
    [self initHTHorizontalView];
    
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height-155)];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self setExtraCellLineHidden:self.customerTable];
    [self.view addSubview:self.customerTable];
    
    
    [self initYiRefreshHeader];
    [self initYiRefreshFooter];
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}


-(void)viewDidAppear:(BOOL)animated
{
    
    if([customerType isEqualToString:@"HaveRegister"]&&(isFlash == YES))
    {
        self.customerNameAry = [[NSMutableArray alloc]init];
        self.customerPhoneAry = [[NSMutableArray alloc]init];
        self.customerAddrAry = [[NSMutableArray alloc]init];
        self.CustomerId = [[NSMutableArray alloc]init];
        self.ServiceId = [[NSMutableArray alloc]init];
        self.serviceNO = [[NSMutableArray alloc]init];
        self.UserId = [[NSMutableArray alloc]init];
        [self.customerTable reloadData];
        indexPage = 1;
        [self getCustomerList:@"HaveRegister" index:1 keyWord:@""];
        isFlash = NO;
    }
    float pt = self.view.frame.size.width/320;
    if (carMakesIndex <= 2) {
        [scrView setContentOffset:CGPointMake(0, -64) animated:NO];
    }
    else if ((carMakesIndex >=3)&&(carMakesIndex <= 6))
    {
        [scrView setContentOffset:CGPointMake((carMakesIndex-2)*55, -64) animated:NO];
    }
    else
    {
        [scrView setContentOffset:CGPointMake(340/pt, -64) animated:NO];
    }
    
    self.selectionList.selectedButtonIndex = carMakesIndex;
    [self.selectionList reloadData];
    
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    float pt = self.view.frame.size.width/320;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.customerNameAry = [[NSMutableArray alloc]init];
        self.customerPhoneAry = [[NSMutableArray alloc]init];
        self.customerAddrAry = [[NSMutableArray alloc]init];
        self.CustomerId = [[NSMutableArray alloc]init];
        self.ServiceId = [[NSMutableArray alloc]init];
        self.serviceNO = [[NSMutableArray alloc]init];
        self.UserId = [[NSMutableArray alloc]init];
        [self.customerTable reloadData];
        indexPage = 1;
        carMakesIndex++;
        [self.selectionList reloadData];
        if (carMakesIndex > carMakes1.count-1) {
            carMakesIndex = carMakes1.count-1;
        }
        if (carMakesIndex <= 2) {
            [scrView setContentOffset:CGPointMake(0, -64) animated:YES];
        }
        else if ((carMakesIndex >=3)&&(carMakesIndex <= 6))
        {
            [scrView setContentOffset:CGPointMake((carMakesIndex-2)*55, -64) animated:YES];
        }
        else
        {
            [scrView setContentOffset:CGPointMake(340/pt, -64) animated:YES];
        }
        self.selectionList.selectedButtonIndex = carMakesIndex;
        [self.selectionList reloadData];
        [self getCustomerList:[carMakes1 objectAtIndex:carMakesIndex] index:1 keyWord:@""];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        self.customerNameAry = [[NSMutableArray alloc]init];
        self.customerPhoneAry = [[NSMutableArray alloc]init];
        self.customerAddrAry = [[NSMutableArray alloc]init];
        self.CustomerId = [[NSMutableArray alloc]init];
        self.ServiceId = [[NSMutableArray alloc]init];
        self.serviceNO = [[NSMutableArray alloc]init];
        self.UserId = [[NSMutableArray alloc]init];
        [self.customerTable reloadData];
        indexPage = 1;
        carMakesIndex--;
        [self.selectionList reloadData];
        if (carMakesIndex < 0) {
            carMakesIndex = 0;
        }
        if (carMakesIndex <= 2) {
            [scrView setContentOffset:CGPointMake(0, -64) animated:YES];
        }
        else if ((carMakesIndex >=3)&&(carMakesIndex <= 6))
        {
            [scrView setContentOffset:CGPointMake((carMakesIndex-2)*55, -64) animated:YES];
        }
        else
        {
            [scrView setContentOffset:CGPointMake(340/pt, -64) animated:YES];
        }
        
        self.selectionList.selectedButtonIndex = carMakesIndex;
        [self.selectionList reloadData];
        [self getCustomerList:[carMakes1 objectAtIndex:carMakesIndex] index:1 keyWord:@""];
    }
}
#pragma mark 初始化

//初始化数组
-(void)initData
{
    self.customerNameAry = [[NSMutableArray alloc]init];
    self.customerPhoneAry = [[NSMutableArray alloc]init];
    self.customerAddrAry = [[NSMutableArray alloc]init];
    self.CustomerId = [[NSMutableArray alloc]init];
    self.ServiceId = [[NSMutableArray alloc]init];
    self.serviceNO = [[NSMutableArray alloc]init];
    self.UserId = [[NSMutableArray alloc]init];
    [self.customerTable reloadData];
    carMakesIndex = 0;
    
    carMakes1 = @[@"HaveRegister",
                  @"HaveDistribution",
                  @"HaveMeasure",
                  @"HaveDesign",
                  @"HaveChecked",
                  @"HaveCommunicate",
                  @"HaveCheckScale",
                  @"HaveContract",
                  @"HaveFinish",
                  @"HaveVisiting"];
}

//初始化分段选择器
-(void)initHTHorizontalView
{
    scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, 600, 40)];
    //核心：表示可滑动区域的大小    其实就是scrView中所有内容的总高度  当可滑动区域的高大于scrollView的高时，scrollView 才可以滑动
    [scrView setContentSize:CGSizeMake(0, -200)];
    [self.view addSubview:scrView];
    float pt = self.view.frame.size.width/320;
    self.selectionList = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, -66, 670*pt, 40)];
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    self.selectionList.backgroundColor = [UIColor colorWithRed:232/255.0 green:230/255.0 blue:226/255.0 alpha:1.0f];
    self.selectionList.selectionIndicatorColor = [UIColor colorWithRed:0 green:0.6392 blue:0.9255 alpha:1.0f];
    
    self.carMakes = @[@"已报备",
                      @"已分配",
                      @"已量尺",
                      @"已设计",
                      @"已检查",
                      @"已沟通",
                      @"已复尺",
                      @"已签合同",
                      @"安装完成",
                      @"已回访"];
    
    [scrView addSubview:self.selectionList];
}

#pragma mark 下拉刷新以及上拉加载

//下拉刷新
-(void)initYiRefreshHeader
{
    // YiRefreshHeader  头部刷新按钮的使用
    refreshHeader=[[YiRefreshHeader alloc] init];
    refreshHeader.scrollView=self.customerTable;
    [refreshHeader header];
    
    refreshHeader.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (customerType == nil) {
                customerType = @"HaveRegister";
                customerTypeChange = @"HaveRegister";
                [self getCustomerList:@"HaveRegister" index:1 keyWord:@""];
            }
            else
            {
                [self getCustomerList:customerType index:indexPage keyWord:@""];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                //[self analyseRequestData];
                [self.customerTable reloadData];
                [refreshHeader endRefreshing];
            });
        });
    };
    // 是否在进入该界面的时候就开始进入刷新状态
    [refreshHeader beginRefreshing];
}

//上拉刷新
-(void)initYiRefreshFooter
{
    // YiRefreshFooter  底部刷新按钮的使用
    refreshFooter=[[YiRefreshFooter alloc] init];
    refreshFooter.scrollView=self.customerTable;
    [refreshFooter footer];
    
    refreshFooter.beginRefreshingBlock=^(){
        // 后台执行：
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //sleep(2);
            // [self analyseRequestData];
            if (customerType == nil) {
                customerType = @"HaveRegister";
                customerTypeChange = @"HaveRegister";
                [self getCustomerList:@"HaveRegister" index:1 keyWord:@""];
            }
            else
            {
                [self getCustomerList:customerType index:indexPage keyWord:@""];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新视图
                [self.customerTable reloadData];
                [refreshFooter endRefreshing];
            });
        });
    };
}

#pragma mark 绘制界面

//初始化导航栏
-(void)initNavigation
{
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    searchBarButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    addCustomerBarButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addcustomer.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addCustomerAction:)];
    backButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"cancle.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    donebutton  = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"search.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addCustomerBarButton,searchBarButton, nil];
}

#pragma mark 搜索功能实现
-(void)searchAction:(id)sender
{
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.font = [UIFont systemFontOfSize:14.0f];
    searchField.placeholder = @"关键字";
    searchField.delegate = self;
    searchField.returnKeyType = UIReturnKeyDone;
    
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.titleView = searchField;
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = donebutton;
}

-(void)cancelAction:(id)sender
{
    self.customerNameAry = [[NSMutableArray alloc]init];
    self.customerPhoneAry = [[NSMutableArray alloc]init];
    self.customerAddrAry = [[NSMutableArray alloc]init];
    self.CustomerId = [[NSMutableArray alloc]init];
    self.ServiceId = [[NSMutableArray alloc]init];
    self.serviceNO = [[NSMutableArray alloc]init];
    self.UserId = [[NSMutableArray alloc]init];
    [self.customerTable reloadData];
    indexPage = 1;
    [self getCustomerList:customerType index:indexPage keyWord:@""];
    [searchField resignFirstResponder];
    self.navigationItem.titleView = nil;
    self.navigationItem.title = @"我的客户";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addCustomerBarButton,searchBarButton, nil];
}
-(void)doneAction:(id)sender
{
    [searchField resignFirstResponder];
    if (searchField.text.length <= 0) {
        return;
    }
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    self.customerNameAry = [[NSMutableArray alloc]init];
    self.customerPhoneAry = [[NSMutableArray alloc]init];
    self.customerAddrAry = [[NSMutableArray alloc]init];
    self.CustomerId = [[NSMutableArray alloc]init];
    self.serviceNO = [[NSMutableArray alloc]init];
    self.ServiceId = [[NSMutableArray alloc]init];
    self.UserId = [[NSMutableArray alloc]init];
    [self.customerTable reloadData];
    [self getCustomerList:customerType index:1 keyWord:searchField.text];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//添加用户信息
-(void)addCustomerAction:(id)sender
{
    isFlash = YES;
    AddNewCustomerViewController *addNewCustomerVC = [[AddNewCustomerViewController alloc]init];
    [self presentViewController:addNewCustomerVC animated:YES completion:nil];
}

#pragma mark - 分段选择器方法实现

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.carMakes.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return self.carMakes[index];
}

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    [searchField resignFirstResponder];
    /*已报备:HaveRegister  已分配:HaveDistribution 已量尺:HaveMeasure 已设计:HaveDesign
     已检查:HaveChecked   已沟通:HaveCommunicate  已复尺:HaveCheckScale  已签合同:HaveContract
     安装完成:HaveFinish   已回访:HaveVisiting
     */
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    dispatch_async(dispatch_get_main_queue(), ^{
        float pt = self.view.frame.size.width/320;
        self.customerNameAry = [[NSMutableArray alloc]init];
        self.customerPhoneAry = [[NSMutableArray alloc]init];
        self.customerAddrAry = [[NSMutableArray alloc]init];
        self.CustomerId = [[NSMutableArray alloc]init];
        self.ServiceId = [[NSMutableArray alloc]init];
        self.serviceNO = [[NSMutableArray alloc]init];
        self.UserId = [[NSMutableArray alloc]init];
        [self.customerTable reloadData];
        indexPage = 1;
        [self.selectionList reloadData];
        if ([self.carMakes[index]isEqualToString:@"已报备"]) {
            carMakesIndex = 0;
            customerType  = @"HaveRegister";
            [self getCustomerList:@"HaveRegister" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(0, -64) animated:YES];
        }
        else if ([self.carMakes[index]isEqualToString:@"已分配"]) {
            carMakesIndex = 1;
            customerType  = @"HaveDistribution";
            [self getCustomerList:@"HaveDistribution" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(0, -64) animated:YES];
        }
        else if ([self.carMakes[index]isEqualToString:@"已量尺"]) {
            carMakesIndex = 2;
            customerType  = @"HaveMeasure";
            [self getCustomerList:@"HaveMeasure" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(0, -64) animated:YES];
        }
        else if ([self.carMakes[index]isEqualToString:@"已设计"]) {
            carMakesIndex = 3;
            customerType  = @"HaveDesign";
            [self getCustomerList:@"HaveDesign" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(55, -64) animated:YES];
        }
        else if ([self.carMakes[index]isEqualToString:@"已检查"]) {
            carMakesIndex = 4;
            customerType  = @"HaveChecked";
            [self getCustomerList:@"HaveChecked" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(110, -64) animated:YES];
        }
        else if ([self.carMakes[index]isEqualToString:@"已沟通"]) {
            carMakesIndex = 5;
            customerType  = @"HaveCommunicate";
            [self getCustomerList:@"HaveCommunicate" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(165, -64) animated:YES];
        }
        else if ([self.carMakes[index]isEqualToString:@"已复尺"]) {
            carMakesIndex = 6;
            customerType  = @"HaveCheckScale";
            [self getCustomerList:@"HaveCheckScale" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(220, -64) animated:YES];
        }
        else if ([self.carMakes[index]isEqualToString:@"已签合同"]) {
            carMakesIndex = 7;
            customerType  = @"HaveContract";
            [self getCustomerList:@"HaveContract" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(340/pt, -64) animated:YES];
        }
        else if ([self.carMakes[index]isEqualToString:@"安装完成"]) {
            carMakesIndex = 8;
            customerType  = @"HaveFinish";
            [self getCustomerList:@"HaveFinish" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(340/pt, -64) animated:YES];
        }
        else if ([self.carMakes[index]isEqualToString:@"已回访"]) {
            carMakesIndex = 9;
            customerType  = @"HaveVisiting";
            [self getCustomerList:@"HaveVisiting" index:indexPage keyWord:@""];
            [scrView setContentOffset:CGPointMake(340/pt, -64) animated:YES];
        }
    });
}

#pragma mark uitabledelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.customerNameAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 65, 20)];
        nameLab.text = [self.customerNameAry objectAtIndex:indexPath.row];
        nameLab.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.font = [UIFont systemFontOfSize:17.0f];
        [cell.contentView addSubview:nameLab];
        
        UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 200, 20)];
        phoneLab.text = [self.customerPhoneAry objectAtIndex:indexPath.row];
        phoneLab.textColor = [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
        phoneLab.textAlignment = NSTextAlignmentLeft;
        phoneLab.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:phoneLab];
        
        UILabel *adrLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 300, 20)];
        adrLab.text =[self.customerAddrAry objectAtIndex:indexPath.row];
        adrLab.textAlignment = NSTextAlignmentLeft;
        adrLab.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:137/255.0 alpha:1.0];
        adrLab.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:adrLab];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        
        longPressGR.minimumPressDuration = 1;
        
        [self.view addGestureRecognizer:longPressGR];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CustomerInfoViewController *customerInfoVC = [[CustomerInfoViewController alloc]init];
        
        customerInfoVC.name = [self.customerNameAry objectAtIndex:indexPath.row];
        customerInfoVC.phone = [self.customerPhoneAry objectAtIndex:indexPath.row];
        customerInfoVC.address = [self.customerAddrAry objectAtIndex:indexPath.row];
        customerInfoVC.CustomerId = [self.CustomerId objectAtIndex:indexPath.row];
        customerInfoVC.ServiceId = [self.ServiceId objectAtIndex:indexPath.row];
        customerInfoVC.UserId = [self.UserId objectAtIndex:indexPath.row];
        customerInfoVC.serviceNO = [self.serviceNO objectAtIndex:indexPath.row];
        
        [self presentViewController:customerInfoVC animated:YES completion:nil];
    });
}

//tableView 优化
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

//长按响应
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer  //长按响应函数
{
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.customerTable];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [self.customerTable indexPathForRowAtPoint:tmpPointTouch];
        deleteIndex = indexPath.row;
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"删除客户" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [sheet showInView:self.view];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self dedeteCustomer:[self.CustomerId objectAtIndex:deleteIndex]];
    }
}
#pragma mark 数据请求

//查询用户
-(void)getCustomerList:(NSString*)customerOfType index:(int)index keyWord:(NSString*)keyWord
{
    [customerIsNullLab removeFromSuperview];
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    NSDictionary *dict = @{@"authCode":code,
                           @"pageIndex":[NSNumber numberWithInt:index],
                           @"pageSize":[NSNumber numberWithInt:10],
                           @"keyWord":keyWord,
                           @"CustomerSchedule":customerOfType};
    [HttpRequset post:dict method:@"Customer/GetCustomerList" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        NSString *InfoMessage = [dic objectForKey:@"InfoMessage"];
        if (([dic[@"Status"]integerValue] == 200)&&([InfoMessage isEqualToString:@"获取列表成功"])) {
            indexPage++;
            NSDictionary *JSON = [[dic objectForKey:@"JSON"]objectFromJSONString];
            NSArray *ReList = [JSON objectForKey:@"ReList"];
            
            for (id relist in ReList) {
                //customerId  serviceId
                NSString *CustomerName = [relist objectForKey:@"CustomerName"];
                NSString *Mobile = [relist objectForKey:@"Mobile"];
                NSString *Province = [relist objectForKey:@"Province"];
                NSString *City = [relist objectForKey:@"City"];
                NSString *CArea = [relist objectForKey:@"CArea"];
                NSString *Address = [relist objectForKey:@"Address"];
                
                NSString *userAdr = [NSString stringWithFormat:@"%@%@%@%@",Province,City,CArea,Address];
                
                NSString *CustomerId = [relist objectForKey:@"CustomerId"];
                NSString *ServiceId = [relist objectForKey:@"ServiceId"];
                NSString *UserId = [relist objectForKey:@"UserId"];
                
                NSString *ServiceNo = [relist objectForKey:@"ServiceNo"];
                for (int i=0 ;i < self.customerNameAry.count;i++)
                {
                    if ([[self.customerNameAry objectAtIndex:i]isEqualToString:CustomerName]&&[[self.customerPhoneAry objectAtIndex:i]isEqualToString:Mobile]&&[[self.customerAddrAry objectAtIndex:i]isEqualToString:Address]) {
                        return;
                    }
                }
                [self.customerNameAry addObject:CustomerName];
                [self.customerPhoneAry addObject:Mobile];
                [self.customerAddrAry addObject:userAdr];
                
                [self.ServiceId addObject:ServiceId];
                [self.CustomerId addObject:CustomerId];
                [self.UserId addObject:UserId];
                [self.serviceNO addObject:ServiceNo];
                //[self.customerTable reloadData];
            }
            
            if (self.customerNameAry.count <= 0) {
                customerIsNullLab = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2)+15, 200, 30)];
                customerIsNullLab.text = @"没有客户信息";
                customerIsNullLab.font = [UIFont systemFontOfSize:17.0f];
                customerIsNullLab.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:customerIsNullLab];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.customerTable reloadData];
            });

        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

//删除用户

-(void)dedeteCustomer:(NSString*)customerId
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    NSDictionary *dict = @{@"authCode":code,@"customerId":customerId};
    [HttpRequset post:dict method:@"Customer/DelteCustomer" completionBlock:^(id obj) {
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSString *JSON = dic[@"JSON"];
            if ([JSON isEqualToString:@"true"])
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除客户成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                [self.customerNameAry removeObjectAtIndex:deleteIndex];
                [self.customerPhoneAry removeObjectAtIndex:deleteIndex];
                [self.customerAddrAry removeObjectAtIndex:deleteIndex];
                [self.ServiceId removeObjectAtIndex:deleteIndex];
                [self.CustomerId removeObjectAtIndex:deleteIndex];
                [self.UserId removeObjectAtIndex:deleteIndex];
                [self.serviceNO removeObjectAtIndex:deleteIndex];
                [self.customerTable reloadData];
            }
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
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
