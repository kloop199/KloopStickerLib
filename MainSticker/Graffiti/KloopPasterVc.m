//
//  PasterController.m
//  XTPasterManager
//
//  Created by TuTu on 15/10/16.
//  Copyright © 2015年 teason. All rights reserved.
//

#import "KloopPasterVc.h"
#import "KloopPasterChooseView.h"
#import "KloopPasterStageView.h"
#import "KloopPasterView.h"
#import "TevaTypeDetailModel.h"
#define APPFRAME        [UIScreen mainScreen].bounds

static const CGFloat width_pasterChoose = 110.0f ;

@interface KloopPasterVc () <UIScrollViewDelegate,KloopPasterChooseViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
// UIs
@property (weak, nonatomic) UIScrollView *pasterScrollView;
@property (strong, nonatomic)        KloopPasterStageView *stageView ;
// Attrs
@property (nonatomic,copy) NSArray *pasterList ;
@end

@implementation KloopPasterVc
#pragma mark - KloopPasterChooseViewDelegate
- (void)pasterClick:(NSString *)paster
{
    
    UIImage *image = ImageViewFile(paster);
    
    if (!image) return ;
    
    //在这里 添加 贴纸
    [_stageView addPasterWithImg:image] ;
}


#pragma mark - Property
- (NSArray *)pasterList
{
    if (!_pasterList)
    {
        NSArray *pasterList=[TevaTypeDetailModel mj_objectArrayWithFilename:StickerData];
        NSMutableArray *pasters=[NSMutableArray new];
        for (TevaTypeDetailModel *entity in pasterList) {
            [pasters addObject:entity.sticker];
        }
        _pasterList = pasters ;
    }
    
    return _pasterList ;
}

#pragma mark - Actions
- (IBAction)backButtonClickedAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)nextButtonClickedAction
{
    UIImage *imgResult = [_stageView doneEdit] ;
    [self.delegate pasterAddFinished:imgResult] ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark - Life cycle
- (void)setup
{
//    CGFloat sideFlex = 10.0f ;
//    CGRect rectImage = CGRectZero ;
//    CGFloat length = APPFRAME.size.width - sideFlex * 2 ;
//    rectImage.size = CGSizeMake(length, length) ;
//    CGFloat y = (APPFRAME.size.height - self.pasterScrollView.frame.size.height - length) ;
//    rectImage.origin.x = sideFlex ;
//    rectImage.origin.y = y ;
    
    UIImageView *imgBgView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imgBgView.contentMode=UIViewContentModeScaleAspectFill;
    imgBgView.layer.masksToBounds=YES;
    imgBgView.image=self.imageWillHandle;
     [self.view addSubview:imgBgView];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:imgBgView.bounds];
    toolBar.barStyle = UIBarStyleBlack;
    [imgBgView addSubview:toolBar];
    
    _stageView = [[KloopPasterStageView alloc] initWithFrame:CGRectMake(0, isNotchScreen()?kScaleScreen(38):kScaleScreen(0), SCREEN_WIDTH, kScaleScreen(468))];
    [self.view addSubview:_stageView] ;
    
    _stageView.originImage = self.imageWillHandle;
    _stageView.backgroundColor = [UIColor clearColor] ;
 
    //[self.view bringSubviewToFront:self.topBar] ;
    self.pasterScrollView=self.scrollView;
    self.pasterScrollView.backgroundColor=ClearColor; //self.pasterScrollView.contentSize=CGSizeMake(self.pasterList.count*width_pasterChoose, 0);
    
    [self.scrollContentView addSubview:self.pasterScrollView];
    [self.view bringSubviewToFront:self.scrollContentView];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonClickedAction)];
}

- (void)viewDidLoad{
    self.navigationItem.title=FormatString(@"%@ Edit",AppDisplayName);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup] ;
    [self scrollviewSetup] ;
    
}


- (void)scrollviewSetup
{
    _pasterScrollView.delegate = self ;
    _pasterScrollView.pagingEnabled = NO ;
    _pasterScrollView.showsVerticalScrollIndicator = NO ;
    _pasterScrollView.showsHorizontalScrollIndicator = NO ;
    _pasterScrollView.bounces = YES ;
    _pasterScrollView.contentSize = CGSizeMake(kScaleScreen(63)+width_pasterChoose * self.pasterList.count,
                                           self.pasterScrollView.frame.size.height) ;
    
    int _x = 0 ;
    
    for (int i = 0; i < self.pasterList.count; i++)
    {
        CGRect rect = CGRectMake(_x, -kScaleScreen(16), width_pasterChoose, self.pasterScrollView.frame.size.height) ;
        KloopPasterChooseView *pView = (KloopPasterChooseView *)[[[NSBundle mainBundle] loadNibNamed:@"KloopPasterChooseView" owner:self options:nil] lastObject] ;
        pView.frame = rect ;
        
        pView.aPaster = self.pasterList[i] ;
        
        pView.delegate = self ;
        [_pasterScrollView addSubview:pView] ;
        
        _x += width_pasterChoose ;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
