//
//  NSArray+Extension.h
//  iTrends
//
//  Created by wujin on 13-1-9.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)

/**
 返回数组中的第一个元素
 */
-(id)firstObject;

/**
 判断字符串数组是否包含某个字符串
 使用isEqualString来判断是否相同
 */
-(BOOL)containsString:(NSString*)string;

- (NSInteger)indexOfString:(NSString *)string;

/**
 使用一个block判断array中是否包含某个元素
 @param anObject : 要判断的对象
 @param compareBlock : 用于比较两个元素的block   此返回bool表示是否包含
 @return 返回bool表示是否包含
 */
-(BOOL)containsObject:(id)anObject usingCompareBlock:(BOOL(^)(id,id))compareBlock;
///计算重复的个数
-(int)containObjectNum:(id)anObject usingCompareBlock:(BOOL (^)(id, id))compareBlock;

-(BOOL)containObjectWithPredicate:(NSString *)format;

///找到符合条件的数据
- (NSArray *)containFormatArray:(NSString *)format;
@end
