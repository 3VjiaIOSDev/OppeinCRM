//
//  CommunicateTableViewCell.m
//  Crm
//
//  Created by svj on 15/10/22.
//  Copyright (c) 2015年 com.3vjia. All rights reserved.
//

#import "CommunicateTableViewCell.h"

@implementation CommunicateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setCommunicateObj:(communicateModel *)communicateObj
{
    
    NSString * str = [communicateObj.CreateTime substringWithRange:NSMakeRange(5, 5)];
    CGSize dateSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    self.dateLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, dateSize.width, 30)];
    self.dateLab.font = [UIFont systemFontOfSize:15];
    self.dateLab.text = str;
    [self addSubview:self.dateLab];
    
    
    NSString *nameStr = communicateObj.userName;
    CGSize nameSize = [nameStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.dateLab.frame)+5, self.dateLab.frame.origin.y, nameSize.width, 30)];
    name.text = nameStr;
    name.font = [UIFont systemFontOfSize:15];
    [self addSubview:name];
    
    CGSize infoSize = [communicateObj.Content boundingRectWithSize:CGSizeMake(self.frame.size.width-CGRectGetMaxX(name.frame)-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    UILabel * infoLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(name.frame)+5, self.dateLab.frame.origin.y, infoSize.width, 30)];
    infoLab.text = communicateObj.Content;
    infoLab.font = [UIFont systemFontOfSize:15];
    infoLab.numberOfLines = 0;
    [self addSubview:infoLab];
    
    self.replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.replyBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, self.dateLab.frame.origin.y, 40, 30);
    [self.replyBtn setTitle:@"回复" forState:UIControlStateNormal];
    [self.replyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.replyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.replyBtn];
    
    if (communicateObj.anwser.count !=0) {
        [communicateObj.anwser enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSString *nameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
            CGSize nameSize = [nameStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(infoLab.frame)+5+idx*(30+5), nameSize.width, 30)];
            lab1.text = nameStr;
            lab1.font = [UIFont systemFontOfSize:15];
            [self addSubview:lab1];
            UILabel * reply = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab1.frame)+5, lab1.frame.origin.y, 40, 30)];
            reply.text = @"回复:";
            reply.font = [UIFont systemFontOfSize:15];
            reply.textColor = [UIColor redColor];
            [self addSubview:reply];
            
            
            
            UILabel * anwserLab = [[UILabel alloc]initWithFrame:CGRectMake(infoLab.frame.origin.x, CGRectGetMaxY(infoLab.frame)+5+idx*(30+5), self.frame.size.width-CGRectGetMaxX(name.frame)-10, 30)];
            anwserLab.text = obj[@"ac"];
            anwserLab.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
            anwserLab.font = [UIFont systemFontOfSize:15];
            [self addSubview:anwserLab];
            self.cellHeight = CGRectGetMaxY(anwserLab.frame)+10;
        }];
        
    }else{
       self.cellHeight = CGRectGetMaxY(infoLab.frame)+10;
    }
    
    
}
@end
