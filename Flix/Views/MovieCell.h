//
//  MovieCell.h
//  Flix
//
//  Created by Trustin Harris on 6/27/18.
//  Copyright © 2018 Trustin Harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *MovieView;
@property (weak, nonatomic) IBOutlet UILabel *OverViewLabel;

@end
