#import "AITestViewController.h"

@implementation AITestViewController
-(instancetype)init
{
	if ((self = [super init]))
	{
		self.title = @"Test";
	}
	return self;
}

-(void)loadView
{
	[super loadView];
	self.view.backgroundColor = UIColor.systemBackgroundColor;
}
@end
