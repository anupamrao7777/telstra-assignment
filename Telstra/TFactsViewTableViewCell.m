//
//  TFactsViewTableViewCell.m
//  
//
//  Created by Anupam Rao on 22/03/18.
//
//

#import "TFactsViewTableViewCell.h"
#import "Masonry.h"
float const kCellPadding = 1.0;
@implementation TFactsViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.thumbnailImage = [[UIImageView alloc] init];
        [self addSubview:self.thumbnailImage];
        self.thumbnailImage.contentMode = UIViewContentModeCenter;
        self.thumbnailImage.clipsToBounds = YES;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.font = [UIFont fontWithName:@"Arial" size:18.0f];
        [self.contentView addSubview:self.titleLabel];
        
        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.textColor = [UIColor grayColor];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [self.contentView addSubview:self.descriptionLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(_descriptionLabel.mas_top).with.offset(-kCellPadding);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [_descriptionLabel mas_updateConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.bottom.equalTo(_thumbnailImage.mas_top).with.offset(-kCellPadding);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [_thumbnailImage mas_updateConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        
    }];
    
    [super updateConstraints];
}




@end
