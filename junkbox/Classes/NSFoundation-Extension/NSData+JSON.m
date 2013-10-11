#import "NSData+JSON.h"


#pragma mark - NSData+JSON
@implementation NSData (JSON)


#pragma mark - api
- (id)JSON
{
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:self
                                              options:NSJSONReadingMutableLeaves
                                                error:&error];
    return ((error) ? nil : json);
}


@end
