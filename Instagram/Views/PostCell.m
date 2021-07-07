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

- (void)setCellData:(Post *)post {
//    self.captionLabel.text = post.caption;
    self.captionLabel.text = @"ABCs";
    // Configure the view for the selected state
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
