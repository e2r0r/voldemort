//
//  QuAppController.h
//  voldemort
//
//  Created by  on 7/25/12.
//  Copyright (c) 2012 Quant,Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuAppController : UIViewController <UIWebViewDelegate>

@property (strong,nonatomic) NSString *app_title;
@property (strong,nonatomic) NSString *app_link;
@property (strong,nonatomic) IBOutlet UINavigationItem *navi_bar;
@property (strong,nonatomic) IBOutlet UIWebView  *wv;

- (void)dismiss;
@end
