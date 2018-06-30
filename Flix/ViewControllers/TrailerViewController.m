//
//  TrailerViewController.m
//  Flix
//
//  Created by Trustin Harris on 6/29/18.
//  Copyright © 2018 Trustin Harris. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()
@property (strong,nonatomic) NSString *urlString;
@property (weak, nonatomic) IBOutlet WKWebView *trailerWV;




@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self GetKEY];
}

- (void)GetKEY {
    
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
