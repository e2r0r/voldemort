//
//  QuViewController.h
//  voldemort
//
//  Created by  on 7/24/12.
//  Copyright (c) 2012 Quant,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MessagePack.h"

@interface QuViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
}

@property (strong,nonatomic) NSArray *device_task;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)fetchDelay;
@end
