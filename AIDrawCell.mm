#import "AIDrawCell.h"

@implementation AIDrawCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:identifier]))
	{
		[self setupCanvas];
	}
	return self;
}

-(void)setupCanvas
{
	UIView* canvasContainer = [[UIView alloc] initWithFrame:CGRectZero];
	canvasContainer.clipsToBounds = YES;
	canvasContainer.layer.cornerRadius = 15.;
	[self.contentView addSubview:canvasContainer];

	const CGFloat inset = 25.;
	canvasContainer.translatesAutoresizingMaskIntoConstraints = NO;
	[canvasContainer.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:inset].active = YES;
	[canvasContainer.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-inset].active = YES;
	[canvasContainer.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:inset].active = YES;
	[canvasContainer.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-inset].active = YES;
	[canvasContainer.heightAnchor constraintEqualToAnchor:canvasContainer.widthAnchor].active = YES;

	_canvasView = [[AICanvasView alloc] initWithFrame:CGRectZero];
	_canvasView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[canvasContainer addSubview:_canvasView];
}
@end
