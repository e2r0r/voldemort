//
//  QuViewController.m
//  voldemort
//
//  Created by  on 7/24/12.
//  Copyright (c) 2012 Quant,Inc. All rights reserved.
//

#import "QuViewController.h"
#import "QuAppDelegate.h"
#import "QuAppController.h"

@interface QuViewController ()

@end

@implementation QuViewController
@synthesize device_task = _device_task;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		
	}
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"device_task"]) {
        self.device_task = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_task"];
    }
    else {
        self.device_task = nil;
    }
    	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    [self performSelector:@selector(fetchDelay) withObject:nil afterDelay:0.3f];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.device_task == nil) {
        return 1;
    }
    else {
        return [self.device_task count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.device_task == nil) {
        NSString *CellIdentifier = @"empty";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text = @"No App";        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"app_task_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [[self.device_task objectAtIndex:indexPath.row] objectForKey:@"name"];
        // Configure the cell...
        
        return cell;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
//    NSString *_url = [[self.device_task objectAtIndex:indexPath.row] objectForKey:@"url"];
//    UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    
//    [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
//    [self.view addSubview:wv];
    
    QuAppController *app = [[QuAppController alloc] initWithNibName:@"QuAppController" bundle:nil];
    app.app_title = [[self.device_task objectAtIndex:indexPath.row] objectForKey:@"name"];
    app.app_link = [[self.device_task objectAtIndex:indexPath.row] objectForKey:@"url"];
    
    //app.navi.title = [[self.device_task objectAtIndex:indexPath.row] objectForKey:@"name"];
    [self presentModalViewController:app animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self fetchDelay];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)fetchDelay {
    
    QuAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSDictionary *request_data = [[NSDictionary alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"task_last_update"]) {
        NSString *last_upate = [[NSUserDefaults standardUserDefaults] objectForKey:@"task_last_update"];
        
        request_data = [delegate request:@"fetch" willCallWithOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:delegate.devToken,[[NSUserDefaults standardUserDefaults] objectForKey:@"device_email"],last_upate, nil] forKeys:[NSArray arrayWithObjects:@"device",@"email",@"update", nil]]];
    }
    else {
        request_data = [delegate request:@"fetch" willCallWithOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:delegate.devToken,[[NSUserDefaults standardUserDefaults] objectForKey:@"device_email"], nil] forKeys:[NSArray arrayWithObjects:@"device",@"email", nil]]];
    }
    
    
    if ([[request_data objectForKey:@"code"] intValue] == 1) {
        NSMutableArray *_task = [[NSMutableArray alloc] init];
        
        for (NSDictionary *item in [request_data objectForKey:@"data"]) {
            [_task addObject:item];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",[[request_data objectForKey:@"update"] intValue]] forKey:@"task_last_update"];
        self.device_task = _task;
        [[NSUserDefaults standardUserDefaults] setObject:self.device_task forKey:@"device_task"];

        [self.tableView reloadData];
    }

    
}

@end
