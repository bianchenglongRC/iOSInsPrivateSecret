//
//  NSMutableData+generatePostBody.m
//  iOSLike4Like
//
//  Created by Blues on 15/9/11.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "NSMutableData+generatePostBody.h"

@implementation NSMutableData (generatePostBody)

+ (NSMutableData *)generatePostBodyWithRequestBody:(NSDictionary *)requestBody Boundary:(NSString *)boundary {
    NSMutableData *body = [NSMutableData data];
    NSString *endLine = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    int i = 0;
    for (id key in [requestBody keyEnumerator]) {
        i++;
        
        if (([[requestBody valueForKey:key] isKindOfClass:[UIImage class]])
            ||([[requestBody valueForKey:key] isKindOfClass:[NSData class]])) {
            
            [dataDictionary setObject:[requestBody valueForKey:key] forKey:key];
            continue;
            
        }
        [body appendData:[[NSString
                          stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                          key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[requestBody valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (i == 2) {
            endLine  = [NSString stringWithFormat:@"\r\n--%@--\r\n", boundary];
        }
        
        [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
        
        
    }
    
//    if ([dataDictionary count] > 0) {
//        for (id key in dataDictionary) {
//            NSObject *dataParam = [dataDictionary valueForKey:key];
//            if ([dataParam isKindOfClass:[UIImage class]]) {
//                NSData* imageData = UIImagePNGRepresentation((UIImage*)dataParam);
//                [[self class] utfAppendBody:body
//                               data:[NSString stringWithFormat:
//                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
//                [[self class] utfAppendBody:body
//                               data:@"Content-Type: image/png\r\n\r\n"];
//                [body appendData:imageData];
//            } else {
//                NSAssert([dataParam isKindOfClass:[NSData class]],
//                         @"dataParam must be a UIImage or NSData");
//                [[self class] utfAppendBody:body
//                               data:[NSString stringWithFormat:
//                                     @"Content-Disposition: form-data; filename=\"%@\"\r\n", key]];
//                [[self class] utfAppendBody:body
//                               data:@"Content-Type: content/unknown\r\n\r\n"];
//                [body appendData:(NSData*)dataParam];
//            }
//            
//            
//            
//            
//            [[self class] utfAppendBody:body data:endLine];
//            
//        }
//    }
    
    
    NSString *result = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    
    return body;
}

- (void)utfAppendBody:(NSMutableData *)body data:(NSString *)data {
    [body appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}


@end
