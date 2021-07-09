//
//  PostCell.m
//  Instagram
//
//  Created by gracezhg on 7/6/21.
//

#import "PostCell.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCellData {
    _post = self.post;
    self.imageView.file = self.post[@"image"];
    self.imageView.layer.cornerRadius = 5;
    [self.imageView loadInBackground];
    
    PFFileObject * profilePhoto = self.user[@"profilePhoto"];
    NSURL * imageURL = [NSURL URLWithString:profilePhoto.url];
    NSLog(@"Profile photo link: %@", imageURL);
    [self.profilePhoto setImageWithURL:imageURL];
    
    self.profilePhoto.layer.cornerRadius = 25;
    self.captionLabel.text = self.post[@"caption"];
    PFUser *author = self.post[@"author"];
    self.authorLabel.text = author.username;
}

@end
