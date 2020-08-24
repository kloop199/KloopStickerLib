//
//  KloopPriorityQueue.h
//  KloopPriorityQueueDemo
//
//  Created by JiongXing on 2016/11/4.
//  Copyright © 2016年 JiongXing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSComparisonResult(^KloopPriorityQueueComparator)(id obj1, id obj2);

/// 二叉堆实现的优先队列，大顶堆。
@interface KloopPriorityQueue : NSObject

/// 定义元素的比较逻辑
@property (nonatomic, copy) KloopPriorityQueueComparator comparator;

/// 统计队列长度
@property (nonatomic, assign, readonly) NSInteger count;

/// 创建实例
+ (instancetype)queueWithComparator:(KloopPriorityQueueComparator)comparator;

/// 创建实例
+ (instancetype)queueWithData:(NSArray *)data comparator:(KloopPriorityQueueComparator)comparator;

/// 入列
- (void)enQueue:(id)element;

/// 出列
- (id)deQueue;

/// 取整个队列数据
- (NSArray *)fetchData;

/// 清空整个队列
- (void)clearData;

/// Debug:打印队列
- (void)logDataWithMessage:(NSString *)message;

@end

