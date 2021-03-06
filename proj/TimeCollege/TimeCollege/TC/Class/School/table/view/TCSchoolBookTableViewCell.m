//
//  TCSchoolBookTableViewCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCSchoolBookTableViewCell.h"
#import "ZStarView.h"

@interface TCSchoolBookTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *puhlish;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet ZStarView *starView;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation TCSchoolBookTableViewCell

- (void)setIndex:(NSIndexPath *)index{
    _index = index;
    if (index.row == 0) {
        _line.hidden = YES;
    }
    
    [self.starView setScore:3 withAnimation:NO];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.puhlish.textColor = UIColor.YBColor_6A6A6A;
    self.info.textColor = UIColor.YBColor_6A6A6A;
    
    self.bookName.font = [UIFont systemFontOfSize:18];
    self.puhlish.font = [UIFont systemFontOfSize:14];
    self.info.font = [UIFont systemFontOfSize:14];
    

}

- (void)index:(NSIndexPath *)index firstCellHiddenLine:(BOOL)firstCellHiddenLine{
    if (index.row == 0 && firstCellHiddenLine) {
        _line.hidden = YES;
    }
}

@end
