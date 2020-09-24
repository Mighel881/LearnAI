#import "AISlidersCell.h"
#include <vector>

@implementation AISlidersCell
{
	UIStackView* _stackView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:identifier]))
	{
		[self setupSliders];
	}
	return self;
}

-(void)setupSliders
{
	const CGFloat sliderHeight = 75;
	const CGFloat padding = 10;
	std::vector<SliderDescriptor> sliders = {
		(SliderDescriptor){@"trainingRate", @"Training Rate", 0, 1.0, NO},
		(SliderDescriptor){@"batchSize", @"Batch Size", 1, 128, YES},
		(SliderDescriptor){@"hiddenLayerCount", @"No. Hidden Layer", 0, 5, YES},
		(SliderDescriptor){@"hiddenNodeCount", @"No. Hidden Nodes", 1, 100, YES}
	};
	CGFloat stackViewHeight = sliders.size() * sliderHeight + (sliders.size() - 1) * padding;

	_stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
	[self addSubview:_stackView];

	_stackView.translatesAutoresizingMaskIntoConstraints = NO;
	[_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
	[_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
	[_stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
	[_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
	[_stackView.heightAnchor constraintEqualToConstant:stackViewHeight].active = YES;

	_stackView.axis = UILayoutConstraintAxisVertical;
	_stackView.distribution = UIStackViewDistributionFillEqually;
	_stackView.spacing = padding;

	for (SliderDescriptor slider : sliders)
	{
		AISliderView* sliderView = [[AISliderView alloc] initWithDescriptor:slider delegate:self];
		[_stackView addArrangedSubview:sliderView];
	}
}

-(void)slider:(NSString*)key didChangeToValue:(NSNumber*)value
{

}
@end
