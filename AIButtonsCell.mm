#import "AIButtonsCell.h"

@implementation AIButtonsCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:identifier]))
	{
		[self setupButtons];
	}
	return self;
}

-(void)setupButtons
{
	_stackView = [UIStackView new];
	_stackView.axis = UILayoutConstraintAxisHorizontal;
	_stackView.distribution = UIStackViewDistributionFillEqually;
	_stackView.spacing = 10.;
	_stackView.layoutMarginsRelativeArrangement = YES;
	_stackView.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(10., 10., 10., 10.);
	[self.contentView addSubview:_stackView];

	const CGFloat height = 70.;
	_stackView.translatesAutoresizingMaskIntoConstraints = NO;
	[_stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
	[_stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active = YES;
	[_stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
	[_stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
	[_stackView.heightAnchor constraintEqualToConstant:height].active = YES;

	//add buttons:
	const CGFloat cornerRadius = 5.;
	void(^layoutBtn)(UIButton*) = ^(UIButton* btn){
		btn.clipsToBounds = YES;
		btn.layer.cornerRadius = cornerRadius;
		[_stackView addArrangedSubview:btn];
	};
	
	UIButton* submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
	submitBtn.backgroundColor = UIColor.greenColor;
	layoutBtn(submitBtn);

	UIButton* clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[clearBtn addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
	clearBtn.backgroundColor = UIColor.redColor;
	layoutBtn(clearBtn);
}

-(void)submit:(UIButton*)submitBtn
{
	[self.delegate buttonPressed:submitBtn ofType:AIButtonTypeSubmit];
}

-(void)clear:(UIButton*)clearBtn
{
	[self.delegate buttonPressed:clearBtn ofType:AIButtonTypeClear];
}
@end
