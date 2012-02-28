#import "UnrotatingView.h"

@implementation UnrotatingView {
    CGLayerRef _cgLayer;
}

- (void)willChangeStatusBarOrientation:(NSNotification *)note {
    NSLog(@"%@", note);
}

- (void)didChangeStatusBarOrientation:(NSNotification *)note {
    NSLog(@"%@", note);
}

- (void)awakeFromNib {
    self.contentMode = UIViewContentModeRedraw;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(willChangeStatusBarOrientation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeStatusBarOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)initCGLayer {
    _cgLayer = CGLayerCreateWithContext(UIGraphicsGetCurrentContext(), CGSizeMake(320, 480), NULL);
    CGContextRef gc = CGLayerGetContext(_cgLayer);
    UIFont *font = [UIFont systemFontOfSize:16];

    UIGraphicsPushContext(gc); {
        [@"speaker" drawInRect:CGRectMake(0, 0, 320, 24) withFont:font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        [@"home button" drawInRect:CGRectMake(0, 480 - 24, 320, -24) withFont:font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        CGContextSaveGState(gc); {
            CGContextRotateCTM(gc, M_PI_2);
            [@"volume buttons" drawInRect:CGRectMake(20, -24, 460, 24) withFont:font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentLeft];
        } CGContextRestoreGState(gc);
    } UIGraphicsPopContext();

    CGContextBeginPath(gc);
    CGContextAddRect(gc, CGRectMake(20, 420, 280, 20));
    CGContextSetFillColorWithColor(gc, UIColor.blueColor.CGColor);
    CGContextFillPath(gc);
    
    CGContextBeginPath(gc);
    CGContextAddRect(gc, CGRectMake(120, 230, 80, 20));
    CGContextSetFillColorWithColor(gc, UIColor.greenColor.CGColor);
    CGContextFillPath(gc);
    
    CGContextBeginPath(gc);
    CGContextSaveGState(gc); {
        CGContextTranslateCTM(gc, 160, 120);
        CGContextMoveToPoint(gc, 0, -100);
        for (int i = 0; i < 4; ++i) {
            CGContextRotateCTM(gc, 4 * M_PI / 5);
            CGContextAddLineToPoint(gc, 0, -100);
        }
    } CGContextRestoreGState(gc);
    CGContextClosePath(gc);
    CGContextSetFillColorWithColor(gc, UIColor.redColor.CGColor);
    CGContextFillPath(gc);
}

- (void)drawRect:(CGRect)rect
{
    if (!_cgLayer) {
        [self initCGLayer];
    }

    CGContextRef gc = UIGraphicsGetCurrentContext();
    CGContextSaveGState(gc); {
        CGSize mySize = self.bounds.size;
        CGSize cgLayerSize = CGLayerGetSize(_cgLayer);
        CGContextTranslateCTM(gc, mySize.width / 2, mySize.height / 2);
        CGContextConcatCTM(gc, CGAffineTransformInvert(self.window.rootViewController.view.transform));
        CGContextTranslateCTM(gc, -cgLayerSize.width / 2, -cgLayerSize.height / 2);
        CGContextDrawLayerAtPoint(gc, CGPointZero, _cgLayer);
    } CGContextRestoreGState(gc);
}

@end
