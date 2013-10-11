#import "NSURL+Query.h"
// NSFoundation-Extension
#import "NSString+PercentEncoding.h"


#pragma mark - NSURL+Query
@implementation NSURL (Query)


#pragma mark - api
+ (NSURL *)URLWithString:(NSString *)URLString
                 queries:(NSDictionary *)queries
{
    NSString *str = URLString;
    NSInteger offset = 0;
    for (NSString *key in [queries allKeys]) {
        str = [NSString stringWithFormat:@"%@%@%@=%@",
            str, (offset == 0) ? @"?" : @"&", key, queries[key]
        ];
        offset++;
    }

    return [NSURL URLWithString:str];
}

- (NSDictionary *)queries
{
    NSArray *components = [[self query] componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionary];
    for (NSString *component in components) {
        // クエリなし
        if ([component isEqualToString:@""]) { continue; }
        NSArray *keyAndValues = [component componentsSeparatedByString:@"="];
        if ([keyAndValues count] < 2) { continue; }

        // クエリ生成
        NSString *str = [[keyAndValues objectAtIndex:1] decodeURIComponentString];
        [queryDict setObject:str forKey:[keyAndValues objectAtIndex:0]];
    }
    return queryDict;
}


@end
