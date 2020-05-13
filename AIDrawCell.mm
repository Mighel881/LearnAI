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
	_canvasView = [[AICanvasView alloc] initWithFrame:CGRectZero];
	[self.contentView addSubview:_canvasView];

	CGFloat inset = 25.;
	_canvasView.translatesAutoresizingMaskIntoConstraints = NO;
	[_canvasView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:inset].active = YES;
	[_canvasView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-inset].active = YES;
	[_canvasView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:inset].active = YES;
	[_canvasView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-inset].active = YES;
	[_canvasView.heightAnchor constraintEqualToAnchor:_canvasView.widthAnchor].active = YES;
}
@end
