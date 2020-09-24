#import "AISliderView.h"

@implementation AISliderView
{
	struct SliderDescriptor _descriptor;
	id<AISliderDelegate> _delegate;
	UILabel* _titleLabel;
	UILabel* _valueLabel;
	UISlider* _slider;
}

-(instancetype)initWithDescriptor:(struct SliderDescriptor)descriptor delegate:(id<AISliderDelegate>)delegate
{
	if ((self = [self init]))
	{
		_descriptor = descriptor;
		_delegate = delegate;
		[self setupSlider];
	}
	return self;
}

-(NSString*)labelForValue:(CGFloat)value
{
	if (_descriptor.integer)
		return [NSString stringWithFormat:@"%d", (int)(value + 0.5)];
	return [NSString stringWithFormat:@"%.2f", value];
}

-(void)sliderUpdated:(UISlider*)slider
{
	_valueLabel.text = [self labelForValue:slider.value];
}

-(void)setupSlider
{
	const CGFloat ratio = 0.3;
	const CGFloat padding = 10;
	const CGFloat labelWidth = 40;

	_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_titleLabel.text = _descriptor.title;
	[self addSubview:_titleLabel];

	_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:padding].active = YES;
	[_titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-padding].active = YES;
	[_titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:padding].active = YES;
	[_titleLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:ratio].active = YES;

	_valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_valueLabel.textAlignment = NSTextAlignmentRight;
	_valueLabel.text = [self labelForValue:_descriptor.min];
	_valueLabel.adjustsFontSizeToFitWidth = YES;
	[self addSubview:_valueLabel];

	_valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_valueLabel.widthAnchor constraintEqualToConstant:labelWidth].active = YES;
	[_valueLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-padding].active = YES;
	[_valueLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor].active = YES;
	[_valueLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;

	_slider = [[UISlider alloc] initWithFrame:CGRectZero];
	_slider.minimumValue = _descriptor.min;
	_slider.maximumValue = _descriptor.max;
	[_slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:_slider];

	_slider.translatesAutoresizingMaskIntoConstraints = NO;
	[_slider.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:padding].active = YES;
	[_slider.trailingAnchor constraintEqualToAnchor:_valueLabel.leadingAnchor constant:-padding].active = YES;
	[_slider.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor].active = YES;
	[_slider.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}
@end
