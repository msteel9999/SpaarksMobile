//
//  DetailViewController.h
//  MasterDetailTest
//
//  Created by martin steel on 25/02/2013.
//  Copyright (c) 2013 martin steel. All rights reserved.
//
//
#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) id detailImage;
@property (strong, nonatomic) id detailButton;

@property int itemNumber;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailDescriptionImage;
@property (weak, nonatomic) IBOutlet UIButton *detailDescriptionButton;

//---web service access---
//@property (strong, nonatomic) NSMutableData *webData;
//@property (strong, nonatomic) NSMutableString *soapResults;
//@property (strong, nonatomic) NSURLConnection *conn;

@property (strong, nonatomic) NSMutableData *responseData;
@end
