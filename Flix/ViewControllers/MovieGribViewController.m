//
//  MovieGribViewController.m
//  Flix
//
//  Created by Trustin Harris on 6/28/18.
//  Copyright © 2018 Trustin Harris. All rights reserved.
//

#import "MovieGribViewController.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface MovieGribViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *movies;
@end

@implementation MovieGribViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 7;
    layout.minimumLineSpacing = 7;
    
    CGFloat moviePerRow = 2;
    CGFloat width = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (moviePerRow-1)) / moviePerRow;
    CGFloat height = width * 1.5;
    layout.itemSize = CGSizeMake(width, height);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMovies {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/top_rated?api_key=d021bba725acbc5108f58873615323a6"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.movies = dataDictionary[@"results"];
            [self.collectionView reloadData];

          
        }
    }];
    [task resume];
}

#pragma mark - Navigation


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movieDict = self.movies[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *poserURLString = movieDict[@"poster_path"];
    NSString *fullURLString = [baseURLString stringByAppendingString:poserURLString];
    NSURL *posterURL = [NSURL URLWithString:fullURLString];
    
    cell.MovieView.image = nil;
    [cell.MovieView setImageWithURL:posterURL];
    
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *cell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSDictionary *movies = self.movies[indexPath.item];
    
    DetailViewController *detailViewController = [segue  destinationViewController];
    detailViewController.movies = movies;
   
    
}



@end
