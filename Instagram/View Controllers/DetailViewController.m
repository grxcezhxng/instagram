//
//  DetailViewController.m
//  Instagram
//
//  Created by gracezhg on 7/7/21.
//

#import "DetailViewController.h"
#import "Post.h"
#import "Parse/Parse.h"
#import <Parse/PFImageView.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DetailViewController

#pragma mark - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.imageView.file = self.post[@"image"];
    self.imageView.layer.cornerRadius = 5;
    [self.imageView loadInBackground];
    self.profilePhoto.layer.cornerRadius = 25;
    self.captionLabel.text = self.post[@"caption"];
    PFUser *const author = self.post[@"author"];
    self.usernameLabel.text = author.username;
    
    NSDate *const date = self.post.createdAt;
    NSDateFormatter *const dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *const dateString = [dateFormatter stringFromDate:date];
    self.timeLabel.text = dateString;
}

@end
