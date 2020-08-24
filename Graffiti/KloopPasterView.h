//
//  KloopPasterView.h
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KloopPasterStageView.h"

@class KloopPasterView ;

@protocol KloopPasterViewDelegate <NSObject>
- (void)makePasterBecomeFirstRespond:(int)pasterID ;
- (void)removePaster:(int)pasterID ;
@end

@interface KloopPasterView : UIView

@property (nonatomic,strong)    UIImage *imagePaster ;
@property (nonatomic)           int     pasterID ;
@property (nonatomic)           BOOL    isOnFirst ;
@property (nonatomic,weak)    id <KloopPasterViewDelegate> delegate ;
- (instancetype)initWithBgView:(KloopPasterStageView *)bgView
                      pasterID:(int)pasterID
                           img:(UIImage *)img ;
- (void)remove ;

@end
