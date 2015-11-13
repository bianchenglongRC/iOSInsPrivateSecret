//
//  NSArray+Extension.m
//  iTrends
//
//  Created by wujin on 13-1-9.
//
//

#import "NSArray+Extension.h"
//#import "DDLog.h"

@implementation NSArray (Extension)
-(id)firstObject
{
    if (self.count==0) {
        return nil;
    }else{
        return [self objectAtIndex:0];
    }
}

-(BOOL)containsString:(NSString *)string
{
	if (string==nil||[string isEqualToString:@""]) {
		return NO;
	}
    for (NSString *str in self) {
        if ([str isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)indexOfString:(NSString *)string
{
    NSInteger index = NSNotFound;
    
    for (int stringIndex = 0; stringIndex < self.count; stringIndex++) {
        NSString *searchString = [self objectAtIndex:stringIndex];
        
        if ([searchString isEqualToString:string]) {
            index = stringIndex;
            
            break;
        }
    }
    
    return index;
}

-(BOOL)containsObject:(id)anObject usingCompareBlock:(BOOL (^)(id, id))compareBlock
{
	if (anObject==nil) {
		return NO;
	}
	for (id obj in self) {
		if (compareBlock(obj,anObject)) {
			return YES;
		}
	}
	return NO;
}

-(int)containObjectNum:(id)anObject usingCompareBlock:(BOOL (^)(id, id))compareBlock
{
    int count = 0;
	if (anObject==nil) {
		return count;
	}
	for (id obj in self) {
		if (compareBlock(obj,anObject)) {
			count++;
		}
	}
	return count;
}

-(BOOL)containObjectWithPredicate:(NSString *)format
{
    NSPredicate *findPredicate = [NSPredicate predicateWithFormat:format];
    @try {
        NSArray *temp =[self filteredArrayUsingPredicate:findPredicate];
        if (temp && temp.count>0) {
            return YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
 
    return NO;
}

- (NSArray *)containFormatArray:(NSString *)format
{
    NSPredicate *findPredicate = [NSPredicate predicateWithFormat:format];
    return [self filteredArrayUsingPredicate:findPredicate];
}
@end