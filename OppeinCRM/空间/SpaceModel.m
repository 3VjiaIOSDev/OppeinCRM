//
//  SpaceModel.m
//  OppeinCRM
//
//  Created by 3Vjia on 16/1/8.
//  Copyright © 2016年 3Vjia. All rights reserved.
//
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define TableWidth 300
#define Tableheight 360

#import "SpaceModel.h"


@implementation SpaceModel


-(id)initWithArray:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f];
        self.dic = dic;
        self.dataArray = [dic objectForKey:@"ContrlContainer"];
        self.spaceDic = [[NSMutableDictionary alloc]init];
        self.saveArray  = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            [self.saveArray addObject:@""];
        }
        [self initUI];
    }
    return self;
}
-(NSMutableArray *)keyArray
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.dataArray.count; i++) {
        NSString *Id = [[self.dataArray objectAtIndex:i]objectForKey:@"Id"];
        NSString *ControlType = [[self.dataArray objectAtIndex:i]objectForKey:@"ControlType"];
        if ([ControlType isEqualToString:@"text"]) {
            [arr addObject:[NSString stringWithFormat:@"txt_%@",Id]];
        }
        else
        {
            [arr addObject:[NSString stringWithFormat:@"rdo_%@",Id]];
        }
    }
    return arr;
}
-(void)dismissView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}
-(void)cancel:(id)sender
{
    [self dismissView];
}

-(void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(SpaceModel:withArray:objectArray:)]) {
        [self.delegate SpaceModel:self withArray:[self keyArray] objectArray:self.saveArray];
    }
    [self dismissView];
}

-(void)initUI
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-TableWidth)/2, (ScreenHeight-Tableheight)/2, TableWidth, Tableheight)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 10.0f;
    [self addSubview:view];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TableWidth, Tableheight-40)];
    table.delegate = self;
    table.dataSource = self;
    table.layer.cornerRadius = 10.0f;
    [view addSubview:table];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(45, 325, 60, 30);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(195, 325, 60, 30);
    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
}

#pragma mark tabledelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *text = [[self.dataArray objectAtIndex:indexPath.row]objectForKey:@"Text"];
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    if ([[[self.dataArray objectAtIndex:indexPath.row]objectForKey:@"ControlType"]isEqualToString:@"radio"]) {
        NSString *value = [[self.dataArray objectAtIndex:indexPath.row]objectForKey:@"DefaultValue"];
        NSArray *arr = [value componentsSeparatedByString:@";"];
        [self cellRadioWithArray:arr tag:indexPath.row view:cell.contentView groupId:text];
    }
    else if ([[[self.dataArray objectAtIndex:indexPath.row]objectForKey:@"ControlType"]isEqualToString:@"checkbox"]) {
        NSString *value = [[self.dataArray objectAtIndex:indexPath.row]objectForKey:@"DefaultValue"];
        NSArray *arr = [value componentsSeparatedByString:@";"];
        [self cellCheckBoxWithArray:arr tag:indexPath.row view:cell.contentView];
    }
    else
    {
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(100, 12, 180, 20)];
        field.delegate = self;
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.tag = indexPath.row;
        [cell.contentView addSubview:field];
    }
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.saveArray replaceObjectAtIndex:textField.tag withObject:textField.text];
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    [self.saveArray replaceObjectAtIndex:radio.tag withObject:radio.titleLabel.text];
}

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    NSString *string = [self.saveArray objectAtIndex:checkbox.tag];
    NSArray *arr = [string componentsSeparatedByString:@";"];
    NSMutableArray *array =[[NSMutableArray alloc]initWithArray:arr];
    if (checked) {
        [array addObject:checkbox.titleLabel.text];
    }
    else
        [array removeObject:checkbox.titleLabel.text];
    NSString *ns=[array componentsJoinedByString:@";"];
    
    [self.saveArray replaceObjectAtIndex:checkbox.tag withObject:ns];
}
-(void)cellRadioWithArray:(NSArray*)array tag:(NSInteger)tag view:(UIView*)view groupId:(NSString*)groupId
{
    NSInteger count = array.count;
    if (count >= 4) {
        count = 4;
    }
    for (int i = 0; i < count; i++) {
        
        QRadioButton *radio = [[QRadioButton alloc] initWithDelegate:self groupId:groupId];
        radio.frame =CGRectMake(300-50*(i+1), 7, 50, 30);
        [radio setTitle:[array objectAtIndex:i]forState:UIControlStateNormal];
        [radio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [radio.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
        [view addSubview:radio];
        if ([radio.titleLabel.text isEqualToString:[self.saveArray objectAtIndex:tag]]) {
            [radio setChecked:YES];
        }
    }
}
-(void)cellCheckBoxWithArray:(NSArray*)array tag:(NSInteger)tag view:(UIView*)view
{
    NSInteger count = array.count;
    if (count >= 4) {
        count = 4;
    }
    NSString *string = [self.saveArray objectAtIndex:tag];
    NSArray *arr = [string componentsSeparatedByString:@";"];
    for (int i = 0; i < count; i++) {
        
        QCheckBox *check = [[QCheckBox alloc] initWithDelegate:self];
        check.tag = tag;
        check.frame =CGRectMake(300-50*(i+1), 7, 50, 30);
        [check setTitle:[array objectAtIndex:i]forState:UIControlStateNormal];
        [check setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [check.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
        [view addSubview:check];
        
        if ([arr containsObject:check.titleLabel.text]) {
            [check setChecked:YES];
        }
    }
}


@end
