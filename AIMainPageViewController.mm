#import "AIMainPageViewController.h"

@implementation AIMainPageViewController
-(instancetype)init
{
	if ((self = [super init]))
	{
		self.title = @"LearnAI";
	}
	return self;
}

-(void)loadView
{
	[super loadView];
	self.view.backgroundColor = UIColor.systemBackgroundColor;
}
@end
