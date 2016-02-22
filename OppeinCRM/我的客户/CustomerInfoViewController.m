//
//  CustomerInfoViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "CustomerInfoViewController.h"
#import "OpinionViewController.h"
#import "CustomerInfoListViewController.h"
#import "CommunicateVC.h"
#import "CustomerFollowUpViewController.h"
#import "MearsureIistViewController.h"
#import "SchemeListViewController.h"
#import "SchemeCommunionViewController.h"

@interface CustomerInfoViewController ()
{
    AFLoadIngView *afloading;
}
@end

@implementation CustomerInfoViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.customerTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.customerTable.delegate = self;
    self.customerTable.dataSource = self;
    [self.view addSubview:self.customerTable];
    
    self.customerAry1 = [[NSArray alloc]initWithObjects:self.address,@"客户详情",@"量尺信息",@"方案信息",@"方案沟通",@"客户跟进",@"收款登记",@"合同登记",@"客户流失",nil];
    customerImg = [[NSArray alloc]initWithObjects:@"location",@"iconfont-liebiao",@"iconfont-iconmianfeiliangfang",@"iconfont-fangan",@"iconfont-jiaoliu",@"iconfont-bianji",@"iconfont-jiesuandengji",@"iconfont-hetongdengji",@"iconfont-07kehuliushiyujing",nil];
    [self initNavigation];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height-80, 64, 64);
    //[button setTitle:@"建议" forState:UIControlStateNormal];
    [button setImage:[[UIImage imageNamed:@"opinion"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(opinion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)opinion
{
//    if (![URLApi isPermission:@"1402"]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加交流失败" message:@"您当前没有权限添加交流信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
    OpinionViewController *vc =[[OpinionViewController alloc]init];
    vc.ServiceId = self.ServiceId;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark 导航栏

-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    [navigationItem setTitle:@"客户信息"];
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.customerAry1.count+1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.section == 0)
        {
            if (indexPath.row == 0) {
                UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 20)];
                nameLab.textAlignment = NSTextAlignmentLeft;
                nameLab.font = [UIFont systemFontOfSize:15.0f];
                nameLab.text = self.name;
                [cell.contentView addSubview:nameLab];
                UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, 150, 20)];
                phoneLab.textAlignment = NSTextAlignmentLeft;
                phoneLab.font = [UIFont systemFontOfSize:12.0f];
                phoneLab.text = self.phone;
                [cell.contentView addSubview:phoneLab];
                for (int i = 0; i < 2; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    btn.frame = CGRectMake(self.view.frame.size.width-50-i*60, 20, 40, 30);
                    btn.tag = 2000+i;
                    [btn setImage:[[UIImage imageNamed:(i == 0)?@"phone":@"message"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
                    
                    [btn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                }
            }
//            else if(indexPath.row ==1)
//            {
//                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15, 18)];
//                img.image = [UIImage imageNamed:@"location.png"];
//                [cell.contentView addSubview:img];
//                
//                UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, self.view.frame.size.width-50, 20)];
//                lab.text = [self.customerAry1 objectAtIndex:indexPath.row-1];
//                lab.font = [UIFont systemFontOfSize:14.0f];
//                lab.textAlignment = NSTextAlignmentLeft;
//                [cell.contentView addSubview:lab];
//            }
            else
            {
                cell.imageView.image = [UIImage imageNamed:[customerImg objectAtIndex:indexPath.row-1]];
                cell.textLabel.text = [self.customerAry1 objectAtIndex:indexPath.row-1];
                cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section == 0)&&(indexPath.row == 0))
    {
        return 80;
    }
    if (indexPath.section == 1) {
        return 60;
    }
    else
        return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                
                break;
            }
            case 1:
            {
                
                break;
            }
            case 2:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                CustomerInfoListViewController *vc = [[CustomerInfoListViewController alloc]init];
                vc.CustomerId = self.CustomerId;
                vc.ServiceId = self.ServiceId;
                [self presentViewController:vc animated:YES completion:nil];
                });
            }
            break;
            case 3:
            {
                //量尺信息
                dispatch_async(dispatch_get_main_queue(), ^{
                MearsureIistViewController *vc = [[MearsureIistViewController alloc]init];
                vc.ServiceId = self.ServiceId;
                vc.UserId = self.UserId;
                [self presentViewController:vc animated:YES completion:nil];
                });
            }
                break;
            case 4:
            {
                //方案信息
                dispatch_async(dispatch_get_main_queue(), ^{
                SchemeListViewController *vc = [[SchemeListViewController alloc]init];
                    vc.serviceId = self.ServiceId;
                    vc.serviceNo = self.serviceNO;
                [self presentViewController:vc animated:YES completion:nil];
                });
            }
                break;
            case 5:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SchemeCommunionViewController *communicate = [[SchemeCommunionViewController alloc]init];
                    communicate.serviceId = self.ServiceId;
                    communicate.serviceNo = self.serviceNO;
                    [self presentViewController:communicate animated:YES completion:nil];
                });
            }
                break;
            case 6:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CustomerFollowUpViewController *vc = [[CustomerFollowUpViewController alloc]init];
                    vc.serviceId = self.ServiceId;
                    vc.customerId = self.CustomerId;
                    vc.serviceNO = self.serviceNO;
                    [self presentViewController:vc animated:YES completion:nil];
                });
            }
                break;
            default:
                break;
        }
    }
    //else
//    {    if (![URLApi isPermission:@"301"]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"查看量尺信息失败" message:@"您当前没有权限查看量尺信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
  //  }
//        RuleInfoViewController *ruleInfoVC = [[RuleInfoViewController alloc]init];
//        ruleInfoVC.MeasureId =[self.customerAry4 objectAtIndex:indexPath.row];
//        ruleInfoVC.spaceId = [self.customerAry5 objectAtIndex:indexPath.row];
//        ruleInfoVC.ServiceId = self.ServiceId;
//        ruleInfoVC.UserId = self.UserId;
//        [self presentViewController:ruleInfoVC animated:YES completion:nil];
   // }
}

#pragma mark 通信模块

-(void)sendMessage:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 2000) {
        //电话
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定拨打电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }
    else
    {
        //短信
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择短信模板" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"模板一",@"模板二",@"模板三", nil];
        [sheet showInView:self.view];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",self.phone];
    //NSString *smsStr = [NSString stringWithFormat:@"sms://%@",self.phone];
    if((alertView.tag == 1000)&&(buttonIndex == 1))
    {
        //拨打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }
    else if ((alertView.tag == 1001)&&(buttonIndex == 1))
    {
        [self sendSms:@"模板一"];
    }
    else if ((alertView.tag == 1002)&&(buttonIndex == 1))
    {
        [self sendSms:@"模板二"];
    }
    else if ((alertView.tag == 10032222)&&(buttonIndex == 1))
    {
        [self sendSms:@"模板三"];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择模板一" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1001;
        [alert show];
    }
    else if (buttonIndex == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择模板二" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1002;
        [alert show];
    }
    else if (buttonIndex == 2)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择模板三" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1003;
        [alert show];
    }
}
-(void)sendSms:(NSString*)sms
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
        //设置委托
        mc.messageComposeDelegate = self;
        //短信内容
        mc.body = sms;
        //短信接收者，可设置多个
        mc.recipients = [NSArray arrayWithObjects:self.phone,nil];
        
        [self presentViewController:mc animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"当前设备不支持发送短信"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
