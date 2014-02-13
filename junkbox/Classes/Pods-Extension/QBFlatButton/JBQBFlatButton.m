#import "JBQBFlatButton.h"


#pragma mark - JBQBFlatButton
@interface JBQBFlatButton ()


- (void)drawRoundedRect:(CGRect)rect radius:(CGFloat)radius context:(CGContextRef)context;


@end


#pragma mark - JBQBFlatButton
@implementation JBQBFlatButton


#pragma mark - api
- (void)drawRect:(CGRect)rect
{
    // UIButton#drawRect
    SEL selector = @selector(drawRect:);
    void(*UIButtonFunction)(id, SEL, ...) = (void(*)(id, SEL, ...))[UIButton instanceMethodForSelector:selector];
    UIButtonFunction(self, selector, rect);

    // draw
    CGSize size = self.bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect faceRect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(faceRect.size.width, faceRect.size.height), NO, 0.0);

    [[self faceColorForState:self.state] set];

    [self drawRoundedRect:faceRect
                   radius:self.radius
                  context:UIGraphicsGetCurrentContext()];
    UIImage *faceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [[self sideColorForState:self.state] set];

    CGRect sideRect = CGRectMake(0, size.height * 1.0 / 4.0, size.width, size.height * 3.0 / 4.0);
    [self drawRoundedRect:sideRect
                   radius:self.radius
                  context:context];

    CGRect faceShrinkedRect;
    if(self.state == UIControlStateSelected || self.state == UIControlStateHighlighted) {
        faceShrinkedRect = CGRectMake(0, self.depth, size.width, size.height - self.margin);
    } else {
        faceShrinkedRect = CGRectMake(0, 0, size.width, size.height - self.margin);
    }

    [faceImage drawInRect:faceShrinkedRect];
}


#pragma mark - private api
- (void)drawRoundedRect:(CGRect)rect
                 radius:(CGFloat)radius
                context:(CGContextRef)context
{
/*
    // QBFlatButton#drawRect
    SEL selector = @selector(drawRect:radius:context:);
    if ([QBFlatButton instancesRespondToSelector:selector]) {
        rect.origin.x += 8.0;
        rect.origin.y += 8.0;
        rect.size.width -= 16.0;
        rect.size.height -= 16.0;

        void(*QBFlatButtonFunction)(id, SEL, ...) = (void(*)(id, SEL, ...))[QBFlatButton instanceMethodForSelector:selector];
        QBFlatButtonFunction(self, selector, rect, radius, context);
    }
*/
/*
    rect.origin.x += 0.5;
    rect.origin.y += 0.5;
    rect.size.width -= 1.0;
    rect.size.height -= 1.0;
*/
    rect.origin.x += 8.0;
    rect.origin.y += 8.0;
    rect.size.width -= 16.0;
    rect.size.height -= 16.0;

    CGFloat lx = CGRectGetMinX(rect);
    CGFloat cx = CGRectGetMidX(rect);
    CGFloat rx = CGRectGetMaxX(rect);
    CGFloat by = CGRectGetMinY(rect);
    CGFloat cy = CGRectGetMidY(rect);
    CGFloat ty = CGRectGetMaxY(rect);

    CGContextMoveToPoint(context, lx, cy);
    CGContextAddArcToPoint(context, lx, by, cx, by, radius);
    CGContextAddArcToPoint(context, rx, by, rx, cy, radius);
    CGContextAddArcToPoint(context, rx, ty, cx, ty, radius);
    CGContextAddArcToPoint(context, lx, ty, lx, cy, radius);
    CGContextClosePath(context);

    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
