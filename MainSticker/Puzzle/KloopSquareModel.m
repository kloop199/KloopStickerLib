//
//  KloopSquareModel.m
//  智能拼图
//
//  Created by Yjt on 2017/12/27.
//  Copyright © 2017年 shizhi. All rights reserved.
//

#import "KloopSquareModel.h"

@implementation KloopSquareModel
+ (instancetype)squuareWithID:(NSInteger)ID image:(UIImage *)image {
    KloopSquareModel *squuare = [[KloopSquareModel alloc] init];
    squuare.originalIndex = ID;
    squuare.image = image;
    return squuare;
}
@end
