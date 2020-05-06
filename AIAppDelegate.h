@class AITestViewController;
@class AITrainViewController;

@interface AIAppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, strong) UITabBarController* tabController;
@property (nonatomic, strong) AITestViewController* testController;
@property (nonatomic, strong) AITrainViewController* trainController;
@end
