#import "AIAppDelegate.h"
#import "AIMainPageViewController.h"

@implementation AIAppDelegate
-(void)applicationDidFinishLaunching:(UIApplication*)application
{
	_window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_rootViewController = [[UINavigationController alloc] initWithRootViewController:[[AIMainPageViewController alloc] init]];
	_window.rootViewController = _rootViewController;
	[_window makeKeyAndVisible];
}
@end
