//
//  QuLoginController.m
//  voldemort
//
//  Created by  on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuLoginController.h"
#import "QuAppDelegate.h"
#import "QuViewController.h"

@interface QuLoginController ()

@end

@implementation QuLoginController
@synthesize device_label = _device_label, user_email = _user_email, device_nickname = _device_nickname, login_submit = _login_submit,res = _res;

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
    QuAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.device_label.lineBreakMode = UILineBreakModeWordWrap; 
    self.device_label.numberOfLines = 0;
    self.device_label.text = delegate.devToken;
    
    self.user_email.delegate = self;
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

- (IBAction)keyboard_done:(id)sender {
    if (sender == self.device_nickname) {
        [self.user_email becomeFirstResponder];
    }
    else {
        [self.user_email resignFirstResponder];
        [self submit_with_device:sender];
    }
}

- (IBAction)submit_with_device:(id)sender 
{
    //NSData *msgData = [@"hello from vdom" dataUsingEncoding:NSUTF8StringEncoding];
    if (![self isValidateEmail:self.user_email.text]) {
        self.res.text = @"email address may be wrong!";
    }
    else {
        QuAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        
        NSDictionary *submit_data = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:delegate.devToken,self.user_email.text,self.device_nickname.text, nil] forKeys:[NSArray arrayWithObjects:@"device",@"email",@"nick", nil]];
        
//        NSDictionary *request_data = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"register",submit_data, nil] forKeys:[NSArray arrayWithObjects:@"method",@"kwargs", nil]];
//        
//        NSData *msgData = [request_data messagePack];
//        
//        
//        if ([delegate.reqSocket sendData:msgData withFlags:ZMQ_NOBLOCK] == -1)
//        {
//            self.res.text = @"Network may be disconnected!";
//        }
//        
//        NSData *reply = [delegate.reqSocket receiveDataWithFlags:0];
//        NSLog(@"%@",[reply messagePackParse]);
//        NSString *replyString = [[NSString alloc] initWithData:reply encoding:NSUTF8StringEncoding];
//        self.res.text = replyString;
        NSDictionary *replyString = [delegate request:@"register" willCallWithOptions:submit_data];
        //NSLog(@"%@",replyString);
        self.res.text = [replyString objectForKey:@"data"];
        if ([[replyString objectForKey:@"code"] intValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:self.user_email.text forKey:@"device_email"];
            QuViewController *next = [[QuViewController alloc] initWithNibName:@"QuViewController" bundle:nil];
            [self presentModalViewController:next animated:YES];
        }
    }
    

}

- (IBAction)dismiss_back_keyboard:(id)sender {
    
    [self.user_email resignFirstResponder];
    [self.device_nickname resignFirstResponder];
}

- (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.user_email) {
        self.view.center = CGPointMake(self.view.center.x
                                       , self.view.center.y  - 60);
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.user_email) {
        self.view.center = CGPointMake(self.view.center.x
                                       , self.view.center.y + 60);
    }
    return YES;
}
@end
