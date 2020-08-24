//
//  ViewController.m
//  智能拼图
//
//  Created by shizhi on 2017/12/6.
//  Copyright © 2017年 shizhi. All rights reserved.
//

#import "KloopPuzzleGameVc.h"
#import "KloopSquareCell.h"
#import "UIImage+tools.h"
#import "KloopStarSearcher.h"
#import "KloopPiecesStatus.h"
#import "KloopCollectionViewDelegate.h"
#import "KloopSquareModel.h"

@interface KloopPuzzleGameVc ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *originalImg;
@property (strong, nonatomic) NSMutableArray *cellDataSource;
@property (assign, nonatomic) BOOL showNo;//显示编号
@property (assign, nonatomic) BOOL isAutoGaming;//是否正在拼图
@property (strong, nonatomic) NSTimer *timer;
#pragma mark - 状态
/// 当前游戏状态
@property (nonatomic, strong) KloopPiecesStatus *currentStatus;
/// 完成时的游戏状态
@property (nonatomic, strong) KloopPiecesStatus *completedStatus;

@property (strong, nonatomic) NSMutableArray <KloopPiecesStatus *>*path;
@property (strong, nonatomic) KloopPathSearcher *searcher;
@property (strong, nonatomic)  KloopCollectionViewDelegate *collectionViewDelegate;
@property (weak, nonatomic) IBOutlet UIButton *randomBtn;
@property (weak, nonatomic) IBOutlet UIButton *autoBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation KloopPuzzleGameVc
static const NSInteger _totalCol=2;
static const NSInteger _totalRow=3;

NSInteger totalCols = _totalCol;
NSInteger totalRows = _totalRow;

+(instancetype) sharePuzzle{
    static KloopPuzzleGameVc* vc=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc=[KloopPuzzleGameVc new];
    });
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=AppDisplayName;
    self.randomBtn.backgroundColor=RandomColor;
    self.autoBtn.backgroundColor=RandomColor;
    self.bgView.backgroundColor=TransparentColor(0.68);
    [self.originalImg viewCircle:33 borderColor:WhiteColor];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(carryOnClick)];
    [self.randomBtn viewCircle:13];
    [self.autoBtn viewCircle:13];
    self.randomBtn.backgroundColor=ThemeColor;
    self.autoBtn.backgroundColor=ThemeColor;
    [self.collectionView viewCircle:36 borderColor:ThemeColor];
    //初始某些操作
    [self initialSth];
}
-(void)promptClick{
    
    self.originalImg.hidden=NO;
    self.bgView.hidden=NO;
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Continue" style:UIBarButtonItemStylePlain target:self action:@selector(carryOnClick)];
}
-(void)carryOnClick{
    self.originalImg.hidden=YES;
    self.bgView.hidden=YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Tips" style:UIBarButtonItemStylePlain target:self action:@selector(promptClick)];
}
#pragma mark -初始设置
- (void)initialSth {
    totalRows=arc4random_uniform(4)+2;
    totalCols=arc4random_uniform(4)+2;
    if(self.puzzleImage){
        self.originalImg.image = ImageViewFile(self.puzzleImage);
    }else{
        self.originalImg.image = [UIImage imageNamed:PlaceholderImage];
    }
    _currentStatus = [KloopPiecesStatus statusWithCols:totalCols Rows:totalRows image:self.originalImg.image];
    _completedStatus = [_currentStatus copyStatus];
//  打乱图块
    self.cellDataSource = [_currentStatus disorganize];
//  设置代理
    [self  collectionViewDelegate];
    
    self.collectionViewDelegate.status = [_currentStatus copyStatus];    
}

#pragma mark -collectionViewDelegate
- (KloopCollectionViewDelegate *)collectionViewDelegate {
    if (_collectionViewDelegate == nil) {
        WeakSelf
        _collectionViewDelegate = [KloopCollectionViewDelegate createCollectionViewDelegateWithDataSource: self.cellDataSource selectBlock:^(NSIndexPath *indexPath) {
            NSLog(@"点击了%ld行cell", (long)indexPath.row);
            weakSelf.currentStatus.indexOfWhite = indexPath.item;
            weakSelf.currentStatus.pieceArrayModel = self.cellDataSource;
            weakSelf.currentStatus.pieceArray =  weakSelf.currentStatus.currentIndexs ;
            
            //自动拼图暂停后如果手动拼图要重置
            [self resetAutoGaming];

            [self.collectionView reloadData];
            
//            if ([_currentStatus isSuccess: self.cellDataSource]) {
//                [self showAlert:@"恭喜！你牛逼啊"];
//            } ;
            if ([weakSelf.currentStatus isSuccessWithCurrent: self.cellDataSource andTarget:weakSelf.completedStatus.pieceArrayModel]) {
                //[self showAlert:@"成功"];
                SuccessAction(@"完成");
            } ;
        }];
        
        self.collectionView.delegate = _collectionViewDelegate;
        self.collectionView.dataSource = _collectionViewDelegate;
    }
    return _collectionViewDelegate;
}



-(void) resetAutoGaming {
    _searcher = nil;
    [_timer invalidate];
    _timer = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resetAutoGaming];
}
#pragma mark -searcher

-(KloopPathSearcher *)searcher {
    if (_searcher == nil) {
        _searcher = [[KloopStarSearcher alloc] init];
        
        _searcher.startStatus = [self.currentStatus copyStatus];
        _searcher.targetStatus = [self.completedStatus copyStatus];
        
        [_searcher setEqualComparator:^BOOL(KloopPiecesStatus *status1, KloopPiecesStatus *status2) {
            
            return [status1 equalWithStatus:status2];
        }];
       
    }
    return _searcher;
}

#pragma mark -自动拼图
- (IBAction)help:(UIButton *)sender {
    
    if ([_currentStatus isSuccessWithCurrent:self.cellDataSource andTarget:_completedStatus.pieceArrayModel]) {
        return;
    }

    if (_isAutoGaming) {
        //[sender setImage:[UIImage imageNamed:@"暂停"] forState:0];
        [sender setTitle:@"Auto" forState:0];
        [_timer setFireDate:[NSDate distantFuture]];
         _isAutoGaming = !_isAutoGaming;
        
        return;
    } else {
        //[sender setImage:[UIImage imageNamed:@"自动"] forState:0];
        [sender setTitle:@"Suspend" forState:0];
        [_timer setFireDate:[NSDate date]];
        
    }
    
    
    if (self.currentStatus.indexOfWhite < 0) {
        return;
    }

    
    if (!_searcher) {
        
        // 开始搜索
        NSDate *startDate = [NSDate date];
        _path = [self.searcher search];
        
        NSInteger pathCount = _path.count;
        NSLog(@"耗时：%.3f秒", [[NSDate date] timeIntervalSince1970] - [startDate timeIntervalSince1970]);
        NSLog(@"需要移动：%@步", @(pathCount));
        if (!_path || pathCount == 0) {
            return  ;
        }
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerAction:) userInfo:sema repeats:YES];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            dispatch_semaphore_signal(sema);
//        }];
        WeakSelf
                      // 开始自动拼图
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [weakSelf.path enumerateObjectsUsingBlock:^(KloopPiecesStatus * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
 
                        // 等待信号
                        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                        // 刷新UI
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 显示排列

                            [self.cellDataSource removeAllObjects];
                            [obj.pieceArrayModel enumerateObjectsUsingBlock:^(KloopSquareModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [self.cellDataSource addObject: obj];
                                
                            }];
                            self.collectionViewDelegate.status.indexOfWhite = obj.indexOfWhite;
                            weakSelf.currentStatus = [obj copyStatus];
                            
                            NSLog(@"xxxxxxxx-----%lu",(unsigned long)idx);
                            [self.collectionView reloadData];
        
                        });
                    }];
        
                    // 拼图完成
                    [weakSelf.timer invalidate];
                    weakSelf.searcher = nil;
                    self.currentStatus = [weakSelf.path lastObject];
                    self.isAutoGaming = NO;
               
        
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sender setTitle:@"Auto" forState:0];
                    });
        
                });
    }
    _isAutoGaming = !_isAutoGaming;
  
}

-(void)timerAction:(id)sender  {
 dispatch_semaphore_signal([sender userInfo]);
}

#pragma mark -重来一盘
- (IBAction)reStart:(UIButton *)sender {
    self.originalImg.hidden=YES;
    self.bgView.hidden=YES;
    [self resetAutoGaming];

    if (self.isAutoGaming) {
        _isAutoGaming = NO;
     }

    _collectionViewDelegate = nil;
  
    totalRows = _totalRow;
    totalCols = _totalCol;
    
    [self initialSth];
    self.collectionViewDelegate.showNo = _showNo;
    [self.collectionView reloadData];
    
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Tips" style:UIBarButtonItemStylePlain target:self action:@selector(promptClick)];
}
#pragma mark - 提示框
- (void)showAlert:(NSString *)text {
    //显示提示框
   
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                   message:text
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                          }];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)dealloc{
    debugMethod();
}
@end
