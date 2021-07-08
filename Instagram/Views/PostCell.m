//
//  PostCell.m
//  Instagram
//
//  Created by gracezhg on 7/6/21.
//

#import "PostCell.h"
#import "Post.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCellData {
    _post = self.post;
    self.imageView.file = self.post[@"image"];
    self.imageView.layer.cornerRadius = 5;
    [self.imageView loadInBackground];
    self.profilePhoto.layer.cornerRadius = 25;
    self.captionLabel.text = self.post[@"caption"];
    PFUser *author = self.post[@"author"];
    self.authorLabel.text = author.username;
}

@end
