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
    // Initialization code
}

- (void)setCellData {
   _post = self.post;
    self.imageView.file = self.post[@"image"];
    [self.imageView loadInBackground];
//    self.imageView.file = "insta_camera_btn.png";
    self.captionLabel.text = self.post[@"caption"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
