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

- (void)textViewDidChange:(UITextView *)textView {
    NSUInteger length;
      length = [self.textView.text length];
    self.characterLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    const int characterLimit = 140;
    NSString *newText = [self.textView.text stringByReplacingCharactersInRange:range withString:text];
    return newText.length < characterLimit;
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
