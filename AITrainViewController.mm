#import "AITrainViewController.h"
#import "AIStartStopCell.h"
#include "NeuralNet.h"

@implementation AITrainViewController
{
	NSArray<Class>* _cellClasses;
	NeuralNet* _network;
	dispatch_queue_t _trainingQueue;
	NSMutableArray* _graphPoints;
	BOOL _needsStopping;
}

-(instancetype)init
{
	if ((self = [self initWithStyle:UITableViewStyleGrouped]))
	{
		self.title = @"Train";
		UIImage* itemImg = [UIImage systemImageNamed:@"slider.horizontal.3"];
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Train" image:itemImg tag:0];

		_cellClasses = @[
			[AIGraphCell class],
			[AIStartStopCell class]
		];

		_trainingQueue = dispatch_queue_create("com.muirey03.learnai-trainingQueue", DISPATCH_QUEUE_SERIAL);
	}
	return self;
}

-(void)loadView
{
	[super loadView];
	self.tableView.delaysContentTouches = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self setupPlotRange];
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
	if ([cell isKindOfClass:[AIGraphCell class]])
		_graphCell = (AIGraphCell*)cell;
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

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot*)plot
{
    return _graphPoints.count;
}

-(id)numberForPlot:(CPTPlot*)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber* num = nil;
	switch (fieldEnum)
	{
		case CPTScatterPlotFieldX:
			num = @(index);
			break;
		case CPTScatterPlotFieldY:
			if (index < _graphPoints.count)
				num = _graphPoints[index];
			break;
		default:
			num = nil;
	}
	return num;
}

-(void)buttonPressed:(UIButton*)btn ofType:(AIButtonType)type
{
	switch (type)
	{
		case AIButtonTypeStart:
			[self startTrain];
			break;
		case AIButtonTypeStop:
			[self stopTrain];
			break;
		default:
			break;
	}
}

-(void)setupPlotRange
{
	CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)_graphCell.graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:@0 length:@(_graphPoints.count + 1)];

	CGFloat maxCost = 1.0;
	for (NSNumber* pt in _graphPoints)
	{
		if ([pt floatValue] > maxCost)
			maxCost = [pt floatValue];
	}
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:@0 length:@(maxCost)];
}

-(void)startTrain
{
	_graphPoints = [NSMutableArray new];
	dispatch_async(_trainingQueue, ^{
		unsigned epochs = 1000;
		float trainingRate = 0.1f;
		unsigned batchSize = 64;
		uint32_t trainingSetSize = 10000;

		if (!_trainingSet.size())
		{
			_trainingSet = loadDataset("/Library/Application Support/LearnAI/", MNISTDatasetTypeTrain, trainingSetSize);
		}

		_network = new NeuralNet({784, 16, 16, 10}, nullptr);
		for (unsigned i = 0; i < epochs && !_needsStopping; i++)
		{
			float cost = _network->train(_trainingSet, trainingRate, batchSize);
			if (!_needsStopping)
				[self epochCompletedWithCost:cost];
		}
		_needsStopping = NO;
	});
}

-(void)stopTrain
{
	_needsStopping = YES;
}

-(void)epochCompletedWithCost:(float)cost
{
	dispatch_async(dispatch_get_main_queue(), ^{
		CGFloat maxCost = 1.0;
		for (NSNumber* pt in _graphPoints)
		{
			if ([pt floatValue] > maxCost)
				maxCost = [pt floatValue];
		}

		CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)_graphCell.graph.defaultPlotSpace;
		CPTPlotRange* oldRange = plotSpace.xRange;
		CPTPlotRange* newRange = [CPTPlotRange plotRangeWithLocation:@0 length:@(_graphPoints.count + 1)];
		[_graphPoints addObject:@((CGFloat)cost)];
		[_graphCell.graph reloadData];
		[CPTAnimation animate:plotSpace property:@"xRange" fromPlotRange:oldRange toPlotRange:newRange duration:0.3];
	
		if (cost > maxCost)
		{
			oldRange = plotSpace.yRange;
			newRange = [CPTPlotRange plotRangeWithLocation:@0 length:@(cost)];
			[CPTAnimation animate:plotSpace property:@"yRange" fromPlotRange:oldRange toPlotRange:newRange duration:0.3];
		}
	});
}

-(void)dealloc
{
	if (_network)
		delete _network;
}
@end
