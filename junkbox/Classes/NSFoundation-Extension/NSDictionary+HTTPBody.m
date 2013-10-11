#import "NSDictionary+HTTPBody.h"
/// NSFoundation-Extension
#import "NSString+PercentEncoding.h"


#pragma mark - NSDictionary+HTTPBody
@implementation NSDictionary (HTTPBody)


#pragma mark - api
- (NSData *)HTTPBodyValue
{
    NSInteger queryCount = 0;
    NSMutableString *HTTPBodyString = [NSMutableString string];
    for (NSString *key in self) {
        id value = self[key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }
        if ([value isKindOfClass:[NSString class]] == NO) {
            continue;
        }

        NSString *s = [NSString stringWithFormat:@"%@=%@", key, [value encodeURIComponentString]];
        s = (queryCount > 0) ? [NSString stringWithFormat:@"&%@", s] : [NSString stringWithFormat:@"?%@", s];
        queryCount++;

        [HTTPBodyString appendString:s];
    }
    if ([HTTPBodyString length] > 0) {
        [HTTPBodyString deleteCharactersInRange:NSMakeRange([HTTPBodyString length]-1, 1)];
    }

    return [HTTPBodyString dataUsingEncoding:NSUTF8StringEncoding];
}


@end
