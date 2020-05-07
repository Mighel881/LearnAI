#import "AICanvasView.h"

@implementation AICanvasView
-(instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.backgroundColor = UIColor.whiteColor;
		self.layer.cornerRadius = 15.;

		//setup shadow
		self.layer.shadowColor = UIColor.blackColor.CGColor;
		self.layer.shadowOpacity = .5;
		self.layer.shadowOffset = CGSizeZero;
		self.layer.shadowRadius = 15.;
	}
	return self;
}
@end
