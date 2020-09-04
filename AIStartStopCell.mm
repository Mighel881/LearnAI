#import "AIStartStopCell.h"

@implementation AIStartStopCell
{
	BOOL _started;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:identifier]))
	{
		_started = NO;
		[self setupButton];
	}
	return self;
}

-(void)setupButton
{
	const CGFloat cornerRadius = 5.;
	UIButton* btn = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"checkmark.circle"] target:self action:@selector(startStop:)];
	[btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	btn.tintColor = UIColor.whiteColor;
	btn.clipsToBounds = YES;
	btn.layer.cornerRadius = cornerRadius;
	[btn setTitle:@" Start" forState:UIControlStateNormal];
	btn.backgroundColor = [UIColor colorWithRed:0.188 green:0.82 blue:0.345 alpha:1.];
	[self.contentView addSubview:btn];

	const CGFloat height = 50.5;
	const CGFloat padding = 10.;
	btn.translatesAutoresizingMaskIntoConstraints = NO;
	[btn.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:padding].active = YES;
	[btn.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-padding].active = YES;
	[btn.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:padding].active = YES;
	[btn.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-padding].active = YES;
	[btn.heightAnchor constraintEqualToConstant:height].active = YES;
}

-(void)startStop:(UIButton*)btn
{
	[self.delegate buttonPressed:btn ofType:(_started ? AIButtonTypeStop : AIButtonTypeStart)];
	NSString* imgName = _started ? @"checkmark.circle" : @"multiply.circle";
	[btn setImage:[UIImage systemImageNamed:imgName] forState:UIControlStateNormal];
	if (_started)
		btn.backgroundColor = [UIColor colorWithRed:0.188 green:0.82 blue:0.345 alpha:1.];
	else
		btn.backgroundColor = [UIColor colorWithRed:1. green:0.271 blue:0.227 alpha:1.];
	[btn setTitle:_started ? @" Start" : @" Stop" forState:UIControlStateNormal];
	_started = !_started;
}
@end
