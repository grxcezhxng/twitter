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
//    if (self.tweet.favorited) {
//        [self.favorButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
//    }
//    if (self.tweet.retweeted) {
//        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
//    }
}

- (IBAction)didTapFavorite:(id)sender {
    
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [self.favorButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    
    [self refreshData];

    // Sent POST request to POST favorite/create endpoint
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
         if (error){
              NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
         }
         else {
             NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
         }
     }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
