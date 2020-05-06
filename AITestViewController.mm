#import "AITestViewController.h"

@implementation AITestViewController
-(instancetype)init
{
	if ((self = [super init]))
	{
		self.title = @"Test";
		UIImage* itemImg = [UIImage systemImageNamed:@"pencil.and.outline"];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Test" image:itemImg tag:0];
	}
	return self;
}

-(void)loadView
{
	[super loadView];
	self.view.backgroundColor = UIColor.systemBackgroundColor;
}
@end
