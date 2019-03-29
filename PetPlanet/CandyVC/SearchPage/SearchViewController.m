//
//  SearchViewController.m
//  PetPlanet
//
//  Created by Overloop on 2019/3/29.
//  Copyright © 2019 Chiru. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needNavBar = YES;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 236, 26)];
    self.navigationItem.titleView = searchBar;
}


@end
