//
//  DetailViewController.m
//  Flix
//
//  Created by Trustin Harris on 6/28/18.
//  Copyright © 2018 Trustin Harris. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import <WebKit/WebKit.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *MovieView;
@property (weak, nonatomic) IBOutlet UIImageView *backDropView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overViewLabel;
@property (weak, nonatomic) IBOutlet WKWebView *trailerWV;
@property (strong, nonatomic) NSNumber *pressed;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pressed  = 0;
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    NSString *poserURLString = self.movies[@"poster_path"];
    
    if ([poserURLString isEqual:[NSNull null]]){
        self.MovieView.image = [UIImage imageNamed:@"sorry"];
    } else {
        NSString *fullposterURLString = [baseURLString stringByAppendingString:poserURLString];
        NSURL *posterURL = [NSURL URLWithString:fullposterURLString];
        [self.MovieView setImageWithURL:posterURL];
    }
    
   
    NSString *backdropURLString = self.movies[@"backdrop_path"];
 
    if ([backdropURLString isEqual:[NSNull null]]){
        self.backDropView.image = [UIImage imageNamed:@"sorry"];
        self.titleLabel.text = self.movies[@"title"];
        self.overViewLabel.text = self.movies[@"overview"];
        [self.overViewLabel sizeToFit];
        
    } else {
        NSString *fullbackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        NSURL *backdropURL = [NSURL URLWithString:fullbackdropURLString];
        [self.backDropView setImageWithURL:backdropURL];
        
        self.titleLabel.text = self.movies[@"title"];
        self.overViewLabel.text = self.movies[@"overview"];
        [self.overViewLabel sizeToFit];
    }
    
  
    
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
}

- (IBAction)onTap:(id)sender {
    [self performSegueWithIdentifier:@"trailerSegue" sender:sender];
}

- (IBAction)PlayTralierButton:(id)sender {
    if (self.pressed == 0) {
        NSString *youtubeURL = @"https://www.youtube.com/watch?v=";
        
        NSNumber *IDnum = self.movies[@"id"];
        NSString *BaseID = @"https://api.themoviedb.org/3/movie/";
        NSString *ENDID = @"/videos?api_key=d021bba725acbc5108f58873615323a6";
        NSString *FullID = [[BaseID stringByAppendingString:IDnum.stringValue] stringByAppendingString:ENDID];
        NSURL *movieURL = [NSURL URLWithString:FullID];
        
        NSURL *url = movieURL;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                self.movies = dataDictionary[@"results"][0];
                NSString *key = self.movies[@"key"];
                NSString *fullyouTubeURL = [youtubeURL stringByAppendingString:key];
                NSURL *trailerURL = [NSURL URLWithString:fullyouTubeURL];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:trailerURL
                                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                     timeoutInterval:10.0];
                [self.trailerWV loadRequest:request];
            }
        }];
        [task resume];
        
        [UIView animateWithDuration:1 animations:^{
            self.overViewLabel.alpha = 0;
            self.trailerWV.alpha = 1;
        }];
    }
    self.pressed == 1;
    
    
}



   


@end
