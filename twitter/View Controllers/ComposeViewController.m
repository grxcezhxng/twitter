//
//  ComposeViewController.m
//  twitter
//
//  Created by gracezhg on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.textView.text = nil;
    self.textView.textColor = UIColor.blackColor;
}

- (IBAction)handleClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)handleTweet:(id)sender {
    [[APIManager shared]
     postStatusWithText:self.textView.text
     completion:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        } else {
            NSLog(@"Error composing tweet: %@", error.localizedDescription);
        }
    }];
}

@end
