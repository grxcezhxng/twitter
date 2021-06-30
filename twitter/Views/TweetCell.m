//
//  TweetCell.m
//  twitter
//
//  Created by gracezhg on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "AppDelegate.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshData {
    self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favorLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}

- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited) {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self.favorButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        [self refreshData];

        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if (error){
                  NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             }
             else {
                 NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
    else {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self.favorButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        [self refreshData];

        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
                     if (error){
                          NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
                     }
                     else {
                         [self refreshData];
                         NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                         
                     }
        }];
    }
}


- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted) {
            self.tweet.retweeted = NO;
            self.tweet.retweetCount -= 1;
            [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
            [self refreshData];

            [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
                 if(error){
                      NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
                 }
                 else{
                     [self refreshData];
                     NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                 }
            }];
    }
    else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        [self refreshData];
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
                 }
                 else {
                     [self refreshData];
                     NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                 }
            }];
        }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
