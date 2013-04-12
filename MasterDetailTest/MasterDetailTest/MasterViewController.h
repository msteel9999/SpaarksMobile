//
//  MasterViewController.h
//  MasterDetailTest
//
//  Created by martin steel on 25/02/2013.
//  Copyright (c) 2013 martin steel. All rights reserved.
//
//
#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSMutableArray *footballers;
@property (strong, nonatomic) NSMutableArray *footballerPics;

@end
