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
    UIGraphicsBeginImageContextWithOptions(faceRect.size, NO, 0.0);

    [[self faceColorForState:self.state] set];

    [self drawRoundedRect:faceRect radius:self.radius context:UIGraphicsGetCurrentContext()];
    UIImage *faceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [[self sideColorForState:self.state] set];

    CGRect sideRect = CGRectMake(0, size.height * 1.0 / 4.0, size.width, size.height * 3.0 / 4.0);
    [self drawRoundedRect:sideRect radius:self.radius context:context];

    CGRect faceShrinkedRect;
    if(self.state == UIControlStateSelected || self.state == UIControlStateHighlighted) {
        faceShrinkedRect = CGRectMake(0, self.depth, size.width, size.height - self.margin);
    } else {
        faceShrinkedRect = CGRectMake(0, 0, size.width, size.height - self.margin);
    }

    [faceImage drawInRect:faceShrinkedRect];
}

- (void)drawRoundedRect:(CGRect)rect
                 radius:(CGFloat)radius
                context:(CGContextRef)context
{
    // QBFlatButton#drawRect
    SEL selector = @selector(drawRect:radius:context:);
    if ([super respondsToSelector:selector]) {
        void(*QBFlatButtonFunction)(id, SEL, ...) = (void(*)(id, SEL, ...))[QBFlatButton instanceMethodForSelector:selector];
        QBFlatButtonFunction(self, selector, selector, radius, context);
    }

}

@end
