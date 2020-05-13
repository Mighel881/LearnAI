#import "AICanvasView.h"

@implementation AICanvasView
{
	NSMutableArray<NSMutableArray<NSValue*>*>* _lines;
}

-(instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		_lines = [NSMutableArray array];
		self.backgroundColor = UIColor.whiteColor;
		self.layer.cornerRadius = 15.;

		//setup shadow
		self.layer.shadowColor = UIColor.blackColor.CGColor;
		self.layer.shadowOpacity = .5;
		self.layer.shadowOffset = CGSizeZero;
		self.layer.shadowRadius = 15.;

		//setup gesture:
		_gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
		[self addGestureRecognizer:_gesture];
	}
	return self;
}

-(void)drag:(UIPanGestureRecognizer*)gesture
{
	CGPoint point;
	switch (gesture.state)
	{
		case UIGestureRecognizerStateBegan:
			[_lines addObject:[NSMutableArray array]];
		case UIGestureRecognizerStateChanged:
			point = [gesture locationInView:self];
			[_lines.lastObject addObject:@(point)];
			[self setNeedsDisplay];
			break;
		default:
			break;
	}
}

-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 15.);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);

	for (NSMutableArray<NSValue*>* line in _lines)
	{
		for (NSUInteger i = 0; i < line.count; i++)
		{
			CGPoint point = [line[i] CGPointValue];
			if (i == 0)
				CGContextMoveToPoint(context, point.x, point.y);
			else
				CGContextAddLineToPoint(context, point.x, point.y);
		}
	}

	CGContextStrokePath(context);
}
@end
