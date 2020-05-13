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
		[btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
		btn.tintColor = UIColor.whiteColor;
		btn.clipsToBounds = YES;
		btn.layer.cornerRadius = cornerRadius;
		[_stackView addArrangedSubview:btn];
	};
	
	UIButton* submitBtn = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"checkmark.circle"] target:self action:@selector(submit:)];
	[submitBtn setTitle:@" Submit" forState:UIControlStateNormal];
	submitBtn.backgroundColor = [UIColor colorWithRed:0.188 green:0.82 blue:0.345 alpha:1.];
	layoutBtn(submitBtn);

	UIButton* clearBtn = [UIButton systemButtonWithImage:[UIImage systemImageNamed:@"multiply.circle"] target:self action:@selector(clear:)];
	[clearBtn setTitle:@" Clear" forState:UIControlStateNormal];
	clearBtn.backgroundColor = [UIColor colorWithRed:1. green:0.271 blue:0.227 alpha:1.];
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
