#import "AITestViewController.h"
#import "AITableCell.h"
#import "AIDrawCell.h"
#import "AIButtonsCell.h"

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
			RLog(@"submit"); //TODO
			break;
		case AIButtonTypeClear:
			[_drawCell.canvasView clear];
			break;
	}
}
@end
