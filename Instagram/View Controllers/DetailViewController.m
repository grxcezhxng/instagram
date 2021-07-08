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
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.imageView.file = self.post[@"image"];
    self.imageView.layer.cornerRadius = 5;
    [self.imageView loadInBackground];
    self.profilePhoto.layer.cornerRadius = 25;
    self.captionLabel.text = self.post[@"caption"];
    PFUser *author = self.post[@"author"];
    self.usernameLabel.text = author.username;
    
    NSDate *date = self.post.createdAt;
       // Create a date formatter to properly reformat the provided timeStamp into readable date
       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
       [dateFormatter setDateFormat:@"MM-dd-yyyy"];
       NSString *dateString = [dateFormatter stringFromDate:date];
       self.timeLabel.text = dateString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
