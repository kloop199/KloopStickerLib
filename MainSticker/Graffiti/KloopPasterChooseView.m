//
//  KloopPasterChooseView.m
//  subao
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "KloopPasterChooseView.h"


@interface KloopPasterChooseView ()
@property (weak, nonatomic) IBOutlet UIImageView    *imgPaster;
@property (weak, nonatomic) IBOutlet UILabel        *lb_namePaster;
@property (weak, nonatomic) IBOutlet UIButton       *bt_bg;
@end

@implementation KloopPasterChooseView

- (void)setAPaster:(NSString *)aPaster
{
    _aPaster = aPaster ;
    
    _lb_namePaster.text = aPaster ;
    
    _imgPaster.image = ImageViewFile(aPaster);
    
    [self.imgPaster viewCircle:33 borderColor:ThemeColor];
}

- (IBAction)btBackgroundClickAction:(id)sender
{
    [self.delegate pasterClick:self.aPaster] ;
}
-(void)awakeFromNib{
    [super awakeFromNib];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
