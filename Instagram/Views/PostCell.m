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
    
    PFFileObject * postPhoto = self.post.image;
    NSURL * imageURL = [NSURL URLWithString:postPhoto.url];
    NSLog(@"Profile photo link: %@", imageURL);
    [self.imageView setImageWithURL:imageURL];
    
    PFUser *author = self.post[@"author"];
    
    PFFileObject * profilePhoto = author[@"profilePhoto"];
    NSURL * profileImageURL = [NSURL URLWithString:profilePhoto.url];
    NSLog(@"Profile photo link: %@", profileImageURL);
    [self.profilePhoto setImageWithURL:profileImageURL];
    
    self.profilePhoto.layer.cornerRadius = 25;
    self.captionLabel.text = self.post[@"caption"];
    self.authorLabel.text = author.username;
}

@end
