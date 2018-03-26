//
//  TFactsView.m
//  
//
//  Created by Anupam Rao on 22/03/18.
//
//

#import "TFactsView.h"
#import "Masonry.h"
@implementation TFactsView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return(self);
}

- (void)updateConstraints {
    [self mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.superview).with.insets(UIEdgeInsetsZero);
    }];
    [super updateConstraints];
}

// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end
