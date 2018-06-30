//
//  SearchViewController.m
//  Flix
//
//  Created by Trustin Harris on 6/28/18.
//  Copyright © 2018 Trustin Harris. All rights reserved.
//

#import "SearchViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *AllMovies;
@property (strong,nonatomic) NSArray *filteredMovies;

@property (nonatomic,strong) NSArray *movies;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.SearchBar.delegate =self;
    self.tableView.rowHeight = 86;
    
    [self searchBar:self.SearchBar textDidChange:self.SearchBar.text];

}

- (void)fetchMovies {
    NSString *url = @"https://api.themoviedb.org/3/search/movie?api_key=d021bba725acbc5108f58873615323a6&query=";
    NSString *searchResults = self.SearchBar.text;
    NSString *SearchURL = [url stringByAppendingString:searchResults];
    NSURL *fullURL = [NSURL URLWithString:SearchURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fullURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.movies = dataDictionary[@"results"];
            [self.tableView reloadData];
            
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
    }];
    [task resume];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self fetchMovies];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    
    NSDictionary *movieDict = self.movies[indexPath.row];
    
    cell.TitleLabel.text = movieDict[@"title"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        
    NSString *poserURLString = movieDict[@"poster_path"];
    
    if (poserURLString && ![poserURLString isEqual:[NSNull null]]) {
        NSString *fullURLString = [baseURLString stringByAppendingString:poserURLString];
        NSURL *posterURL = [NSURL URLWithString:fullURLString];
        
     
        
        cell.MovieView.image = nil;
        [cell.MovieView setImageWithURL:posterURL];
    }
    
    return cell;
}

- (IBAction)CancelButton:(id)sender {
    [self.view endEditing:YES];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell: cell];
    NSDictionary *movies = self.movies[indexPath.row];
    
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.movies = movies;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
}


@end
