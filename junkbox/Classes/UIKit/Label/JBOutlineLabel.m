#import "JBOutlineLabel.h"


#pragma mark - JBOutlineLabel
@implementation JBOutlineLabel


#pragma mark - synthesize
@synthesize outlineColor;
@synthesize outlineWidth;


#pragma mark - dealloc
- (void)dealloc
{
    self.outlineColor = nil;
}


#pragma mark - api
- (void)drawTextInRect:(CGRect)rect
{
    if (self.outlineColor == nil) {
        [super drawTextInRect:rect];
        return;
    }

    CGSize shadowOffset = self.shadowOffset;
    UIColor *txtColor = self.textColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, self.outlineWidth);
    CGContextSetLineJoin(contextRef, kCGLineJoinRound);


    CGContextSetTextDrawingMode(contextRef, kCGTextFill);
    self.textColor = txtColor;
    [super drawTextInRect:CGRectInset(rect, self.outlineWidth, self.outlineWidth)];

    CGContextSetTextDrawingMode(contextRef, kCGTextStroke);
    self.textColor = self.outlineColor;
    [super drawTextInRect:CGRectInset(rect, self.outlineWidth, self.outlineWidth)];

    self.textColor = txtColor;


/*
    CGContextSetTextDrawingMode(contextRef, kCGTextStroke);
    self.textColor = self.outlineColor;
    [super drawTextInRect:CGRectInset(rect, self.outlineWidth, self.outlineWidth)];

    CGContextSetTextDrawingMode(contextRef, kCGTextFill);
    self.textColor = txtColor;
    [super drawTextInRect:CGRectInset(rect, self.outlineWidth, self.outlineWidth)];
*/

    self.shadowOffset = shadowOffset;
}


@end
