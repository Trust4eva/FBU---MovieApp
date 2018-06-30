//
//  DetailViewController.m
//  Flix
//
//  Created by Trustin Harris on 6/28/18.
//  Copyright © 2018 Trustin Harris. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *MovieView;
@property (weak, nonatomic) IBOutlet UIImageView *backDropView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overViewLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    NSString *poserURLString = self.movies[@"poster_path"];
    NSString *fullposterURLString = [baseURLString stringByAppendingString:poserURLString];
    NSURL *posterURL = [NSURL URLWithString:fullposterURLString];
    [self.MovieView setImageWithURL:posterURL];
    

    NSString *backdropURLString = self.movies[@"backdrop_path"];
    NSString *fullbackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullbackdropURLString];
    [self.backDropView setImageWithURL:backdropURL];
    
    self.titleLabel.text = self.movies[@"title"];
    self.overViewLabel.text = self.movies[@"overview"];
    [self.overViewLabel sizeToFit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *cell = sender;

    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movies = self.movies;
}

- (IBAction)onTap:(id)sender {
    [self performSegueWithIdentifier:@"trailerSegue" sender:sender];
}

   


@end
