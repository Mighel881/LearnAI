#import "AITestViewController.h"
#import "AITableCell.h"
#import "AIDrawCell.h"
#import "AIButtonsCell.h"
#import "UIImage+Pixels.h"
#include <fstream>

std::vector<Eigen::MatrixXf> loadWeights(std::string filePath)
{
	std::vector<Eigen::MatrixXf> ret;

	std::ifstream f(filePath);
	std::string line;
	while (std::getline(f, line))
	{
		unsigned rows;
		unsigned cols;
		Eigen::MatrixXf w;

		std::istringstream iss(line);
		float a;
		for (int i = 0; (iss >> a); i++)
		{
			if (i == 0)
			{
				rows = a;
			}
			else if (i == 1)
			{
				cols = a;
				w.resize(rows, cols);
			}
			else
				w.data()[i - 2] = a;
			char c;
			iss >> c;
			if (c != ',') break;
		}

		ret.push_back(w);
	}

	f.close();
	return ret;
}

@implementation AITestViewController
{
	NSArray<Class>* _cellClasses;
}

-(instancetype)init
{
	if ((self = [self initWithStyle:UITableViewStyleGrouped]))
	{
		self.title = @"Test";
		UIImage* itemImg = [UIImage systemImageNamed:@"pencil.and.outline"];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Test" image:itemImg tag:0];

		_cellClasses = @[
			[AIDrawCell class],
			[AIButtonsCell class]
		];
	}
	return self;
}

-(void)loadNetworkWithWeights:(NSString*)weightPath
{
	auto weights = loadWeights(weightPath.UTF8String);
	_network = new NeuralNet({784, 16, 16, 10}, &weights);
}

-(void)loadView
{
	[super loadView];
	self.tableView.delaysContentTouches = NO;
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	[self loadNetworkWithWeights:@"/Library/Application Support/LearnAI/weights.csv"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	return _cellClasses.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	NSUInteger index = indexPath.row;
	NSString* identifier = NSStringFromClass(_cellClasses[index]);
	AITableCell* cell = (AITableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell)
		cell = [(AITableCell*)[_cellClasses[index] alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
	cell.delegate = self;
	if ([cell isKindOfClass:[AIDrawCell class]])
		_drawCell = (AIDrawCell*)cell;
	return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewAutomaticDimension;
}

-(BOOL)tableView:(UITableView*)tableView shouldHighlightRowAtIndexPath:(NSIndexPath*)indexPath
{
	return NO;
}

-(NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	return nil;
}

-(void)buttonPressed:(UIButton*)btn ofType:(AIButtonType)type
{
	switch (type)
	{
		case AIButtonTypeSubmit:
			[self submitDrawing];
			break;
		case AIButtonTypeClear:
			[_drawCell.canvasView clear];
			break;
	}
}

/*
Ideas for improvements:
- Normalise vector so values are from 0 - 255
- Thicker pen
*/

-(void)submitDrawing
{
	UIImage* img = [_drawCell.canvasView captureImage];
	Eigen::VectorXf x = [self vectorFromImage:img];

	Eigen::VectorXf h = _network->go(x);
	unsigned guess = NeuralNet::findLargest(h);
	
	NSString* msg = [NSString stringWithFormat:@"I think that is a %u", guess];
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Luketh" message:msg preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* correctAction = [UIAlertAction actionWithTitle:@"Correct" style:UIAlertActionStyleDefault handler:nil];
	UIAlertAction* incorrectAction = [UIAlertAction actionWithTitle:@"Incorrect" style:UIAlertActionStyleDefault handler:nil];
	[alert addAction:correctAction];
	[alert addAction:incorrectAction];
	[self presentViewController:alert animated:YES completion:nil];
}

-(Eigen::VectorXf)vectorFromImage:(UIImage*)img
{
	//find far edge pixels:
	CGSize size = img.size;
	__block NSUInteger minX = size.width - 1;
	__block NSUInteger minY = size.height - 1;
	__block NSUInteger maxX = 0, maxY = 0;
	[img iteratePixels:^(NSUInteger x, NSUInteger y, uint8_t pixel){
		if (pixel < 0xff)
		{
			if (x < minX) minX = x;
			if (y < minY) minY = y;
			if (x > maxX) maxX = x;
			if (y > maxY) maxY = y;
		}
		return YES;
	}];

	//crop image:
	CGFloat croppedWidth = maxX - minX;
	CGFloat croppedHeight = maxY - minY;
	CGRect croppedRect = CGRectMake(minX, minY, croppedWidth, croppedHeight);
	UIGraphicsBeginImageContextWithOptions(croppedRect.size, YES, 1.);
	[img drawInRect:CGRectMake(-croppedRect.origin.x, -croppedRect.origin.y, size.width, size.height)];
	img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	//render in 28x28 grid, with margin:
	const CGFloat margin = 4;
	CGSize finalSize = CGSizeMake(28., 28.);
	UIGraphicsBeginImageContextWithOptions(finalSize, YES, 1.);
	//fill white background:
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor);
	CGContextFillRect(context, CGRectMake(0, 0, finalSize.width, finalSize.height));
	//render smaller version in context:
	CGFloat largestLength = MAX(croppedWidth, croppedHeight);
	CGFloat innerSize = finalSize.width - 2 * margin;
	CGSize scaledSize = CGSizeMake(croppedWidth / largestLength * innerSize, croppedHeight / largestLength * innerSize);
	CGFloat startX = (finalSize.width - scaledSize.width) / 2;
	CGFloat startY = (finalSize.height - scaledSize.height) / 2;
	CGRect renderFrame = CGRectMake(startX, startY, scaledSize.width, scaledSize.height);
	[img drawInRect:renderFrame];
	img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	__block Eigen::VectorXf vec = Eigen::VectorXf::Zero(finalSize.width * finalSize.height);
	[img iteratePixels:^(NSUInteger x, NSUInteger y, uint8_t pixel){
		unsigned i = y * finalSize.width + x;
		vec[i] = 0xff - pixel;
		return YES;
	}];
	return vec;
}

-(void)dealloc
{
	delete _network;
}
@end
