//
//  KloopPasterChooseView.h
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KloopPasterChooseViewDelegate <NSObject>
- (void)pasterClick:(NSString *)paster ;
@end

@interface KloopPasterChooseView : UIView
@property (nonatomic,weak)   id <KloopPasterChooseViewDelegate> delegate ;
@property (nonatomic,copy)   NSString *aPaster ;
@end
