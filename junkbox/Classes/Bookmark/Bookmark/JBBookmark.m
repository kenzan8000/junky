#import "JBBookmark.h"
#import <xlocale.h>


#pragma mark - JBBookmark
@implementation JBBookmark


#pragma mark - dynamic
@dynamic author;
@dynamic dcSubject;
@dynamic entryId;
@dynamic issued;
@dynamic link;
@dynamic summary;
@dynamic title;


#pragma mark - release
- (void)dealloc
{
    self.author = nil;
    self.dcSubject = nil;
    self.entryId = nil;
    self.issued = nil;
    self.link = nil;
    self.summary = nil;
    self.title = nil;
}


#pragma mark - api
- (void)setParametersWithJSON:(NSDictionary *)JSON
{
    NSArray *allKeys = [JSON allKeys];

    // author
    if ([allKeys containsObject:@"author"] &&
         [JSON[@"author"] isKindOfClass:[NSDictionary class]] &&
         [[JSON[@"author"] allKeys] containsObject:@"name"]) {
        self.author = [NSString stringWithFormat:@"%@", JSON[@"author"][@"name"]];
    }
    if (self.author == nil) {
        self.author = @"";
    }

    // dcSubject
    if ([allKeys containsObject:@"dc:subject"]) {
        id subject = JSON[@"dc:subject"];
        NSArray *subjectArray = nil;
        if ([subject isKindOfClass:[NSArray class]]) {
            subjectArray = subject;
        }
        else {
            subjectArray = @[[NSString stringWithFormat:@"%@", subject]];
        }
        self.dcSubject = [subjectArray componentsJoinedByString:@","];
    }
    if (self.dcSubject == nil) {
        self.dcSubject = [@[] componentsJoinedByString:@","];
    }

    // entryId
    if ([allKeys containsObject:@"id"]) {
        self.entryId = [NSString stringWithFormat:@"%@", JSON[@"id"]];
    }
    if (self.entryId == nil) {
        self.entryId = @"";
    }

    // issued
    if ([allKeys containsObject:@"issued"]) {
/*
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-ddTHH:mm:ss+09:00";

        NSString *dateString = [NSString stringWithFormat:@"%@", JSON[@"issued"]];
        self.issued = [dateFormatter dateFromString:dateString];
*/
        NSString *dateString = [NSString stringWithFormat:@"%@", JSON[@"issued"]];
        struct tm  sometime;
        const char *formatString = "%Y-%m-%dT%H:%M:%SZ";
        strptime_l(dateString.UTF8String, formatString, &sometime, NULL);
        self.issued = [NSDate dateWithTimeIntervalSince1970:timegm(&sometime)];
    }
    if (self.issued == nil) {
        self.issued = [NSDate date];
    }

    // link
    if ([allKeys containsObject:@"link"]) {
        id subject = JSON[@"link"];
        NSArray *linkArray = nil;
        if ([subject isKindOfClass:[NSArray class]]) {
            linkArray = subject;
        }
        else {
            linkArray = @[subject];
        }

        for (NSDictionary *l in linkArray) {
            if ([l isKindOfClass:[NSDictionary class]] == NO) {
                continue;
            }
            if ([[l allKeys] containsObject:@"_href"] == NO     ||
                [[l allKeys] containsObject:@"_rel"] == NO) {
                continue;
            }
            if ([l[@"_rel"] isEqualToString:@"related"]) {
                self.link = [NSString stringWithFormat:@"%@", l[@"_href"]];
            }
            break;
        }
    }
    if (self.link == nil) {
        self.link = @"";
    }

    // summary
    if ([allKeys containsObject:@"summary"]) {
        self.summary = [NSString stringWithFormat:@"%@", JSON[@"summary"]];
    }
    if (self.summary == nil) {
        self.summary = @"";
    }

    // title
    if ([allKeys containsObject:@"title"]) {
        self.title = [NSString stringWithFormat:@"%@", JSON[@"title"]];
    }
    if (self.title == nil) {
        self.title = @"";
    }
}

- (NSArray *)tags
{
    return [self.dcSubject componentsSeparatedByString:@","];
}

- (NSURL *)URL
{
    return [NSURL URLWithString:self.link];
}


@end
