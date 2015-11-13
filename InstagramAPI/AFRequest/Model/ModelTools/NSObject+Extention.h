//
//  NSObject+Extention.h
//  iTrends
//
//  Created by wujin on 12-8-29.
//
//

#import <Foundation/Foundation.h>

/*
 定义一个需要指定时间后执行的block块
 */
typedef void(^BlockPerform)(id param);

/**
 向dispatch_async提交一个block
 该block先向某个全局队列提交一个指定优先级的任务，然后在完成后在主线程上再提交一个任务
 @param priority : 对应dispatch_get_global_queue函数的优先级参数
 @param workblock : 用于后台处理任务的block
 @param uiblock : 用于在后台任务完成后在主线程上执行的block
 */
UIKIT_STATIC_INLINE void dispatch_async_work_ui(dispatch_queue_priority_t priority,dispatch_block_t workblock,dispatch_block_t uiblock)
{
	dispatch_async(dispatch_get_global_queue(priority, 0), ^{
		workblock();
		dispatch_async(dispatch_get_main_queue(),uiblock);
	});
}



/**
 申明一个 block_self 的指针，指向自身，以用于在block中使用
 */
#if __has_feature(objc_arc)
#define IMP_BLOCK_SELF(type) __weak type *block_self=self;
#else
#define IMP_BLOCK_SELF(type) __block type *block_self=self;
#endif

@interface NSObject (Extention)
/**
 设置关联的一个参数对象
 此对象会被 retain一次，会在对象dealloc的release
 请使用
	-(id)associatedObjectRetain
 获取此对象
 @param object : 要关联的参数
 */
-(void)setAssociatedObjectRetain:(id)object;
/**
 获取关联的一个参数对象
 此对象会被 retain一次
 请使用
	-(id)setAssociatedObjectRetain:
 设置此对象
 @return 返回关联的对象
 */
-(id)associatedObjectRetain;

/**
 设置关联的一个参数对象
 此对象不会被 retain，只是一个弱引用
 请使用
	-(id)associatedObject
 获取此对象
 */
-(void)setAssociatedObject:(id)object;
/**
 获取关联的一个参数对象
 此对象不会被 retain，只是一个弱引用
 使用
	-(id)setAssociatedObject:
 设置此对象
 @return 返回设置的对象
 */
-(id)associatedObject;

//============================for JSON ========================//
- (NSString *)JSONString;

@end
