//
//  LoopImageScrollView.h
//  ScrollViewLoopDemo
//
//  Created by Adam on 15/6/26.
//  Copyright (c) 2015年 Adam.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoopImageScrollViewDelegate <NSObject>

-(void)loopCurrentIndex:(NSInteger)index;

@end

@interface LoopImageScrollView : UIView

@property (nonatomic,assign) id<LoopImageScrollViewDelegate> delegate;

@property (nonatomic,retain)NSArray *imageURLArray;

@end
