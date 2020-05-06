#import "AITrainViewController.h"

@implementation AITrainViewController
-(instancetype)init
{
	if ((self = [super init]))
	{
		self.title = @"Train";
	}
	return self;
}

-(void)loadView
{
	[super loadView];
	self.view.backgroundColor = UIColor.systemBackgroundColor;
}
@end
