#import "AITestViewController.h"
#import "AITableCell.h"
#import "AIDrawCell.h"
#import "AIButtonsCell.h"
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

-(void)loadView
{
	[super loadView];
	self.tableView.delaysContentTouches = NO;
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
	UIImage* img = [_drawCell.canvasView imageWithPixelSize:CGSizeMake(28, 28)];
	Eigen::VectorXf x = [self vectorFromImage:img];
	//TODO - creating network should only be done once
	auto weights = loadWeights("/Library/Application Support/LearnAI/weights.csv");
	NeuralNet* net = new NeuralNet({784, 16, 16, 10}, &weights);
	Eigen::VectorXf h = net->go(x);
	unsigned guess = NeuralNet::findLargest(h);
	delete net;
	
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
	CGImageRef imageRef = img.CGImage;
	NSUInteger width = CGImageGetWidth(imageRef);
	NSUInteger height = CGImageGetHeight(imageRef);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	uint8_t* data = (uint8_t*)malloc(width * height);
	CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width, colorSpace, 0);
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);

	Eigen::VectorXf vec = Eigen::VectorXf::Zero(width * height);
	for (unsigned y = 0; y < height; y++)
	{
		for (unsigned x = 0; x < width; x++)
		{
			unsigned i = y * width + x;
			uint8_t pixel = 0xff - data[i]; //invert
			vec[i] = pixel;
		}
	}
	
	free((void*)data);
	return vec;
}
@end
