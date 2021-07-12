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
    self.backgroundColor = UIColor.clearColor;
}

- (void)setCellData {
    _post = self.post;

    self.imageView.layer.cornerRadius = 5;
    
    PFFileObject *const postPhoto = self.post.image;
    NSURL *const imageURL = [NSURL URLWithString:postPhoto.url];
    [self.imageView setImageWithURL:imageURL];
    
    PFUser *const author = self.post[@"author"];
    
    PFFileObject *const profilePhoto = author[@"profilePhoto"];
    NSURL *const profileImageURL = [NSURL URLWithString:profilePhoto.url];
    [self.profilePhoto setImageWithURL:profileImageURL];
    
    self.profilePhoto.layer.cornerRadius = 25;
    self.captionLabel.text = self.post[@"caption"];
    self.authorLabel.text = author.username;
}

@end
