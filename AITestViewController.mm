#import "AITestViewController.h"
#import "AIDrawCell.h"

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
			[AIDrawCell class]
		];
	}
	return self;
}

-(void)loadView
{
	[super loadView];

	self.view.backgroundColor = UIColor.systemBackgroundColor;
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
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell)
		cell = [(UITableViewCell*)[_cellClasses[index] alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
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
@end
