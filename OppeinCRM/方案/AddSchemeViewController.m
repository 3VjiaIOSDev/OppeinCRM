//
//  AddSchemeViewController.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/12.
//  Copyright © 2016年 3Vjia. All rights reserved.
//

#import "AddSchemeViewController.h"

@interface AddSchemeViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *table;
    NSMutableArray *dataArray;
    NSMutableArray *data1Array;
    NSArray *mearsureArr;
    AFLoadIngView *afloading;
    
    NSString *schemeId;
    NSString *imageDataStr;
    UIImageView *fileImage;
}
@end

@implementation AddSchemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavigation];
    dataArray = [NSMutableArray array];
    data1Array = [NSMutableArray array];
    [dataArray addObject:@"方案空间"];
    for (int i = 0; i< 7; i++) {
        if(i == 0)
        {
            [data1Array addObject:@"请选择方案"];
        }
        else if (i == 1)
        {
            [data1Array addObject:@"请输入方案名称"];
        }
        else
        {
            [data1Array addObject:@"无"];
        }
    }
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    
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
    navigationItem.title = @"添加方案";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"addcustomer.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addScheme)];
    navigationItem.rightBarButtonItem = rightButton;
    
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
-(void)addScheme
{
    if (!self.MeasureId) {
        [SVProgressHUD showErrorWithStatus:@"请选择空间方案"];
        return;
    }
    if (!self.SchemeName) {
        [SVProgressHUD showErrorWithStatus:@"请输入方案名称"];
        return;
    }
    [self AddScheme];
}

#pragma mark tabledelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        return 80;
    }
    else
        return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row != 6) {
        if(indexPath.row == 1)
        {
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [data1Array objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
        
        fileImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 60, 60)];
        [cell.contentView addSubview:fileImage];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            if (!mearsureArr) {
                [dataArray addObject:@"方案名称"];
                [dataArray addObject:@"户型"];
                [dataArray addObject:@"风格"];
                [dataArray addObject:@"面积"];
                [dataArray addObject:@"预算"];
                [dataArray addObject:@"附件"];
                [self getmearsureList];
                return;
            }
            [self showMearsureList];
        }
            break;
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"方案名称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.tag = 1000;
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField * txt = [[UITextField alloc] init];
            txt.backgroundColor = [UIColor whiteColor];
            txt.keyboardType = UIKeyboardTypePhonePad;
            txt.frame = CGRectMake(alert.center.x+65,alert.center.y+48, 150,23);
            [alert addSubview:txt];
            [alert show];
        }
            break;
        case 2:
        {
            [self getSchemeAttributeOfHouse];
        }
            break;
        case 3:
        {
            [self getSchemeAttributeOfStyle];
        }
            break;
        case 4:
        {
            [self getSchemeAttributeOfArea];
        }
            break;
        case 5:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"客户预算" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.tag = 1001;
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField * txt = [[UITextField alloc] init];
            txt.backgroundColor = [UIColor whiteColor];
            txt.keyboardType = UIKeyboardTypePhonePad;
            txt.frame = CGRectMake(alert.center.x+65,alert.center.y+48, 150,23);
            [alert addSubview:txt];
            [alert show];
        }
            break;
        case 6:
        {
            UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
            sheet.tag = 2004;
            [sheet showInView:self.view];
        }
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 1000)&&(buttonIndex==1)) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        [data1Array replaceObjectAtIndex:1 withObject:tf.text];
        self.SchemeName = tf.text;
    }
    if ((alertView.tag == 1001)&&(buttonIndex==1)) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        [data1Array replaceObjectAtIndex:5 withObject:tf.text];
        self.Budget = [tf.text floatValue];
    }
    [table reloadData];
}
-(void)getmearsureList
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code,
                           @"serviceId":self.serviceId};
    
    [HttpRequset post:dict method:@"MeasureSpace/GetMeasureList" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue] == 200)
        {
            mearsureArr = [dic[@"JSON"]objectFromJSONString];
            [self showMearsureList];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

-(void)showMearsureList
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择方案空间" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [mearsureArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [sheet addButtonWithTitle:obj[@"SpaceName"]];
    }];
    sheet.tag = 2000;
     [sheet showInView:self.view];
}


#pragma mark actionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (actionSheet.tag == 2000) {
        if ((mearsureArr.count <= 0)||(buttonIndex==0)) {
            return;
        }
        self.MeasureId = [mearsureArr objectAtIndex:buttonIndex-1][@"MeasureId"];
        NSNumber *budget = [mearsureArr objectAtIndex:buttonIndex-1][@"Budget"];
        self.Budget = [budget floatValue];
        
        self.SpaceName = [mearsureArr objectAtIndex:buttonIndex-1][@"SpaceName"];
        
        self.RoomType = [mearsureArr objectAtIndex:buttonIndex-1][@"RoomType"];
        self.Area = [mearsureArr objectAtIndex:buttonIndex-1][@"Area"];
        self.Style = [mearsureArr objectAtIndex:buttonIndex-1][@"Style"];
        
        [data1Array replaceObjectAtIndex:0 withObject:self.SpaceName];
        //[data1Array replaceObjectAtIndex:1 withObject:self.SpaceName];
        [data1Array replaceObjectAtIndex:2 withObject:self.RoomType];
        [data1Array replaceObjectAtIndex:3 withObject:self.Style];
        [data1Array replaceObjectAtIndex:4 withObject:self.Area];
        [data1Array replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%f",self.Budget]];
    }
    else if (actionSheet.tag == 2001)
    {
        if (buttonIndex==0) {
            return;
        }
        [data1Array replaceObjectAtIndex:2 withObject:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
    else if (actionSheet.tag == 2002)
    {
        if (buttonIndex==0) {
            return;
        }
        [data1Array replaceObjectAtIndex:3 withObject:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
    else if(actionSheet.tag == 2003)
    {
        if (buttonIndex==0) {
            return;
        }
        [data1Array replaceObjectAtIndex:4 withObject:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
    else if(actionSheet.tag == 2004)
    {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
        else if(buttonIndex == 1)
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }

    }
    [table reloadData];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];

     UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageDataStr = [self encodeToPercentEscapeString:[self image2DataURL:img]];
    fileImage.image = img;
    [afloading dismiss];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 添加方案

-(void)AddScheme
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code,
                           @"MeasureId":self.MeasureId,
                           @"Budget":[NSNumber numberWithFloat:self.Budget],
                           @"SchemeName":self.SchemeName,
                           @"ServiceId":self.serviceId,
                           @"ServiceNo":self.serviceNo,
                           @"SpaceName":self.SpaceName,
                           @"RoomType":self.RoomType,
                           @"Area":self.Area,
                           @"Style":self.Style};
    [HttpRequset post:dict method:@"Scheme/AddScheme" completionBlock:^(id obj) {
       
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            schemeId = dic[@"JSON"];
            schemeId  = [schemeId stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [self updateImage];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"添加方案失败"];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}
#pragma mark 上传图片
-(void)updateImage
{
    if (!imageDataStr) {
        [self back];
        return;
    }
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dictionary = @{@"authCode":code,
                                 @"SchemeId":schemeId,@"FileString":imageDataStr,@"FileName":@"file_100.png",@"FileType":@"1"};
    [HttpRequset post:dictionary method:@"uploadfile/PostSchemeFileByString" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            [self back];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}
#pragma mark 获取户型数据

-(void)getSchemeAttributeOfHouse
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};
    
    [HttpRequset post:dict method:@"MeasureSpace/GetRoomInfo" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [dic[@"JSON"]objectFromJSONString];
            NSArray *StyleArr = JSON[@"HouseType"];
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择户型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [StyleArr enumerateObjectsUsingBlock:^(NSString *style, NSUInteger idx, BOOL * _Nonnull stop) {
                [sheet addButtonWithTitle:style];
            }];
            sheet.tag = 2001;
            [sheet showInView:self.view];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

#pragma mark 获取风格

-(void)getSchemeAttributeOfStyle
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};
    
    [HttpRequset post:dict method:@"MeasureSpace/GetRoomInfo" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [dic[@"JSON"]objectFromJSONString];
            NSArray *StyleArr = JSON[@"Style"];
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择风格" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [StyleArr enumerateObjectsUsingBlock:^(NSString *style, NSUInteger idx, BOOL * _Nonnull stop) {
                [sheet addButtonWithTitle:style];
            }];
            sheet.tag = 2002;
            [sheet showInView:self.view];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}

#pragma mark 获取面积

-(void)getSchemeAttributeOfArea
{
    [afloading removeFromSuperview];
    afloading = [[AFLoadIngView alloc]initWithLoading];
    [self.view addSubview:afloading];
    
    NSString *code = [HttpRequset initCode];
    code = [HttpRequset encodeToPercentEscapeString:code];
    
    NSDictionary *dict = @{@"authCode":code};
    
    [HttpRequset post:dict method:@"MeasureSpace/GetRoomInfo" completionBlock:^(id obj) {
        [afloading dismiss];
        NSDictionary *dic = [obj objectFromJSONString];
        if ([dic[@"Status"]integerValue]==200) {
            NSDictionary *JSON = [dic[@"JSON"]objectFromJSONString];
            NSArray *StyleArr = JSON[@"RoomType"];
            for (id area in StyleArr) {
                if ([area[@"RoomName"]isEqualToString:self.SpaceName]) {
                    NSArray *arr = area[@"Areas"];
                    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择面积" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                    [arr enumerateObjectsUsingBlock:^(NSString *style, NSUInteger idx, BOOL * _Nonnull stop) {
                        [sheet addButtonWithTitle:style];
                    }];
                    sheet.tag = 2003;
                    [sheet showInView:self.view];
                }
            }
           
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}
/*
 （转码）
 功能：将特殊字符encode编码  转义的字符 !*'();:@&=+$,/?%#[]
 输入：input：待转义的字符串
 返回：转义之后的字符串
 */
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}
- (NSString *) image2DataURL: (UIImage *) img
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    imageData = UIImagePNGRepresentation([self reSizeImage:img toSize:CGSizeMake(600, 400)]);
    mimeType = @"image/png";
    
    return [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:0]];
}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}

@end
