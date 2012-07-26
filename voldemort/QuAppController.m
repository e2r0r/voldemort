//
//  QuAppController.m
//  voldemort
//
//  Created by  on 7/25/12.
//  Copyright (c) 2012 Quant,Inc. All rights reserved.
//

#import "QuAppController.h"

@interface QuAppController ()

@end

@implementation QuAppController
@synthesize app_link=_app_link, app_title=_app_title, navi_bar = _navi_bar, wv = _wv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navi_bar.title = self.app_title;
    self.navi_bar.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.wv.delegate = self;
    [self.wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.app_link]]];

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

- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
