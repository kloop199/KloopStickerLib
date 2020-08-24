//
//  KloopPasterVc.h
//  DunnMaxPopularJobPro
//
//  Created by mac on 2020/3/4.
//  Copyright © 2020 MacOS. All rights reserved.
//

#import "TevaBaseVc.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PasterCtrllerDelegate <NSObject>
- (void)pasterAddFinished:(UIImage *)imageFinished ;
@end


@interface KloopPasterVc : TevaBaseVc
@property (nonatomic,weak)   id <PasterCtrllerDelegate> delegate ;
@property (nonatomic,strong) UIImage *imageWillHandle ;
@end

NS_ASSUME_NONNULL_END
