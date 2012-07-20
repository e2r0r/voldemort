//
//  QuLoginController.h
//  voldemort
//
//  Created by  on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuLoginController : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) IBOutlet UILabel *device_label;
@property (nonatomic,strong) IBOutlet UITextField *user_email;
@property (nonatomic,strong) IBOutlet UITextField *device_nickname;
@property (nonatomic,strong) IBOutlet UIButton *login_submit;
@property (nonatomic,strong) IBOutlet UILabel *res;

- (IBAction)keyboard_done:(id)sender;

- (IBAction)submit_with_device:(id)sender;

- (IBAction)dismiss_back_keyboard:(id)sender;
@end
