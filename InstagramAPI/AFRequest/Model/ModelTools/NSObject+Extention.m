//
//  NSObject+Extention.m
//  iTrends
//
//  Created by wujin on 12-8-29.
//
//

#import "NSObject+Extention.h"
#import <objc/runtime.h>
//NSString * const kAssociatedObjectKey=@"associatedobjectkey-234242";
//NSString * const kAssociatedObjectRetainKey=@"associatedobjectretainkey-235424";

static char kAssociatedObjectRetainKey;
static char kAssociatedObjectKey;

@implementation NSObject (Extention)

/**
 获取关联的一个参数对象
 此对象会被 retain一次，
 此对象会在dealloc的时候释放，所以请注意不要发生retinCycle
 */
-(void)setAssociatedObjectRetain:(id)object
{
    objc_setAssociatedObject(self, &kAssociatedObjectRetainKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)associatedObjectRetain
{
    return objc_getAssociatedObject(self, &kAssociatedObjectRetainKey);
}

/**
 获取关联的一个参数对象
 此对象不会被 retain，只是一个弱引用
 */
-(void)setAssociatedObject:(id)object
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey, object, OBJC_ASSOCIATION_ASSIGN);
}
-(id)associatedObject
{
    return objc_getAssociatedObject(self, &kAssociatedObjectKey);
}

- (NSString *)JSONString
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
}


@end