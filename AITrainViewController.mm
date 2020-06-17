#import "AITrainViewController.h"

@implementation AITrainViewController
-(instancetype)init
{
	if ((self = [super init]))
	{
		self.title = @"Train";
		UIImage* itemImg = [UIImage systemImageNamed:@"slider.horizontal.3"];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Train" image:itemImg tag:0];
	}
	return self;
}

-(void)loadView
{
	[super loadView];
	self.view.backgroundColor = UIColor.systemBackgroundColor;
}

-(void)viewDidLoad
{
	[super viewDidLoad];

	//DEBUG
	[self startTrain];
}

-(void)startTrain
{
	if (!_trainingSet.size())
	{
		_trainingSet = loadDataset("/Library/Application Support/LearnAI/", MNISTDatasetTypeTrain);
	}
}
@end
