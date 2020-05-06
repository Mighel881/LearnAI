#import "AIAppDelegate.h"
#import "AITestViewController.h"
#import "AITrainViewController.h"

@implementation AIAppDelegate
-(void)applicationDidFinishLaunching:(UIApplication*)application
{
	_testController = [AITestViewController new];
	_trainController = [AITrainViewController new];

	UINavigationController*(^createNav)(UIViewController*) = ^(UIViewController* vc){
		UINavigationController* navCont = [[UINavigationController alloc] initWithRootViewController:vc];
		navCont.navigationBar.prefersLargeTitles = YES;
		return navCont;
	};

	_tabController = [UITabBarController new];
	_tabController.viewControllers = @[createNav(_testController), createNav(_trainController)];
	
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_window.rootViewController = _tabController;
	[_window makeKeyAndVisible];
}
@end
