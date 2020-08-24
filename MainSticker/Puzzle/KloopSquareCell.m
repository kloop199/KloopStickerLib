//
//  KloopSquareCell.m
//  智能拼图
//
//  Created by shizhi on 2017/12/6.
//  Copyright © 2017年 shizhi. All rights reserved.
//

#import "KloopSquareCell.h"
#import "UIImage+tools.h"
#import "KloopSquareModel.h"

@interface KloopSquareCell()

@property (nonatomic,weak) UIImageView *imageV;
@property (nonatomic ,assign)NSInteger originalIndex;

@end

@implementation KloopSquareCell

- (UIImageView *)imageV {
    
    if (_imageV == nil) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = self.bounds;
        [self.contentView addSubview:imageV];
        _imageV = imageV;
    }
    return _imageV;
}


- (void)setModel:(KloopSquareModel *)model {

    self.imageV.frame = self.bounds;
    self.originalIndex = model.originalIndex;
    if (_showNo) {
        self.imageV.image = [model.image addTextToView:[NSString stringWithFormat: @"%ld" ,(long)self.originalIndex]];
    } else {
        self.imageV.image = model.image;
    }
    
}

@end
