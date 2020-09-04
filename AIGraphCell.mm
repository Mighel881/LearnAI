#import "AIGraphCell.h"

@implementation AIGraphCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:identifier]))
	{
		[self setupGraphView];
	}
	return self;
}

-(void)setupGraphView
{
	_graphView = [[CPTGraphHostingView alloc] initWithFrame:CGRectZero];
	_graphView.clipsToBounds = YES;
	[self.contentView addSubview:_graphView];

	const CGFloat inset = 25.;
	_graphView.translatesAutoresizingMaskIntoConstraints = NO;
	[_graphView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:inset].active = YES;
	[_graphView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-inset].active = YES;
	[_graphView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:inset].active = YES;
	[_graphView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-inset].active = YES;
	[_graphView.heightAnchor constraintEqualToAnchor:_graphView.widthAnchor].active = YES;
}

-(void)didMoveToWindow
{
	[super didMoveToWindow];
	[self createGraph];
}

-(void)createGraph
{
	CPTXYGraph* graph = [[CPTXYGraph alloc] initWithFrame:_graphView.bounds];
	_graphView.hostedGraph = graph;
	_graph = graph;
	graph.backgroundColor = [UIColor blackColor].CGColor;

	CPTMutableTextStyle* titleStyle = [CPTMutableTextStyle new];
	titleStyle.color = [CPTColor whiteColor];
	titleStyle.fontName = @"HelveticaNeue-Bold";
	titleStyle.fontSize = 20.0;
	titleStyle.textAlignment = CPTTextAlignmentCenter;
	graph.titleTextStyle = titleStyle;

	graph.title = @"Cost";
	graph.paddingBottom = 40.0;
	graph.paddingLeft = 40.0;
	graph.paddingTop = 30.0;
	graph.paddingRight = 15.0;

	CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:@0 length:@1];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:@0 length:@1];

	CPTMutableTextStyle* axisTextStyle = [CPTMutableTextStyle new];
	axisTextStyle.color = [CPTColor whiteColor];
	axisTextStyle.fontName = @"HelveticaNeue-Bold";
	axisTextStyle.fontSize = 10.0;
	axisTextStyle.textAlignment = CPTTextAlignmentCenter;

	CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle new];
	lineStyle.lineColor = [CPTColor whiteColor];
	lineStyle.lineWidth = 5;

	CPTMutableLineStyle* gridLineStyle = [CPTMutableLineStyle new];
	gridLineStyle.lineColor = [CPTColor grayColor];
	gridLineStyle.lineWidth = 0.5;

	CPTXYAxisSet* axisSet = (CPTXYAxisSet*)graph.axisSet;
	CPTXYAxis* x = axisSet.xAxis;
	x.majorIntervalLength = @10;
	x.minorTicksPerInterval = 9;
	x.labelTextStyle = axisTextStyle;
	x.minorGridLineStyle = gridLineStyle;
	x.axisLineStyle = lineStyle;
	x.axisConstraints = [[CPTConstraints alloc] initWithLowerOffset:0];

	CPTXYAxis* y = axisSet.yAxis;
	y.majorIntervalLength = @2;
	y.minorTicksPerInterval = 19;
	y.labelTextStyle = axisTextStyle;
	y.minorGridLineStyle = gridLineStyle;
	y.axisLineStyle = lineStyle;
	y.axisConstraints = [[CPTConstraints alloc] initWithLowerOffset:0];

	CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:graph.bounds];
	CPTMutableLineStyle* graphLineStyle = [plot.dataLineStyle mutableCopy];
	graphLineStyle.lineWidth = 2.0;
	graphLineStyle.lineColor = [CPTColor whiteColor];
	plot.dataLineStyle = graphLineStyle;
	plot.dataSource = (id<CPTScatterPlotDataSource>)self.delegate;
	_plot = plot;

	[graph addPlot:plot];
}
@end
