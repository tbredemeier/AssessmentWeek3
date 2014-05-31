//
//  ViewController.m
//  AssessmentWeek3
//
//  Created by tbredemeier on 5/31/14.
//  Copyright (c) 2014 Mobile Makers Academy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property NSArray *divvyLocations;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

// retrieve and load the JSON data into an array
- (void)loadData
{
    NSURL *url = [NSURL URLWithString: @"http://www.divvybikes.com/stations/json/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError)
     {
         if(data)
         {
             NSDictionary *divvyData = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingAllowFragments
                                                                          error:&connectionError];
             self.divvyLocations = [divvyData objectForKey:@"stationBeanList"];
             [self.tableView reloadData];
        }
     }];
    self.title = @"Divvy Bike Locations";
}

- (IBAction)onSearchButtonPressed:(id)sender
{
    if(self.searchTextField.text.length > 0)
    {
        NSString *search = [self.searchTextField.text lowercaseString];
        NSMutableArray *results = [[NSMutableArray alloc]init];
        for(NSDictionary *location in self.divvyLocations)
        {
            NSString *name = [location[@"stationName"] lowercaseString];
            if ([name rangeOfString:search].location != NSNotFound)
            {
                [results addObject:location];
            }
        }
        self.divvyLocations = results;
        [self.view endEditing:YES];
        [self.tableView reloadData];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.divvyLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *location = [self.divvyLocations objectAtIndex:indexPath.row];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DivvyCellID"];
    NSNumber *availableBikes = [location objectForKey:@"availableBikes"];
    NSNumber *availableDocks = [location objectForKey:@"availableDocks"];
    NSString *details = [NSString stringWithFormat:@"Available bikes: %@   Open bike docks: %@",
                         availableBikes, availableDocks];

    cell.textLabel.text = location[@"stationName"];
    cell.detailTextLabel.text = details;
    return cell;
}


@end
