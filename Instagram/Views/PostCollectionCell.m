//
//  PostCollectionCell.m
//  Instagram
//
//  Created by gracezhg on 7/9/21.
//

#import "PostCollectionCell.h"

@implementation PostCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.postView.layer.masksToBounds = YES;
    self.postView.clipsToBounds = YES;
}

@end
