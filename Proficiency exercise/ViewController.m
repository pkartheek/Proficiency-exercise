//
//  ViewController.m
//  Proficiency exercise
//
//  Created by Kartheek P. on 23/11/15.
//  Copyright (c) 2015 Kartheek P. All rights reserved.
//

#import "ViewController.h"
#import "AppRecords.h"
#import "NullCheck.h"
#import "TableViewCell.h"
#import "DomainURL.h"

#define TEXT_START_X 12
#define TEXT_START_Y 6
#define ICON_WIDTH 120
#define ICON_HEIGHT 120
#define ICON_GAP 10

@interface ViewController ()
@end
@implementation ViewController
@synthesize mImageDownloadsInProgress;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor=[UIColor whiteColor];
    mImageCache = [[NSCache alloc]init];
    mArrayRecord = [[NSMutableArray alloc] init];
    mImageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    /////////////////////////////////  Creating Table view Programatically ////////////////////////////
    
    mTableView.backgroundColor=[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    
    mTableView=[[UITableView alloc] initWithFrame:self.view.frame];
    
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    mTableView.dataSource = self;
    mTableView.delegate = self;
    [self.view addSubview:mTableView];
    
   ///////////////////////////////////  Creating Refresh controll Programatically ///////////////
    refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(Refresh) forControlEvents:UIControlEventValueChanged];
    [mTableView addSubview:refreshControl];
    
    [self Refresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

///////////////////////////// Table view Delegate methods ///////////////////////////////////////////.
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TableViewCell class]])
    {
        TableViewCell *tableViewCell = (TableViewCell *)cell;
        AppRecords *appRecord=[mArrayRecord objectAtIndex:indexPath.row];
        [tableViewCell setTitleText: appRecord.mTitleName];
        [tableViewCell setDescryptionText: appRecord.mDescription];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mArrayRecord count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat: @"%ld", (long)indexPath.row];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        float width = mTableView.frame.size.width;
        float iconTotalWidth = ICON_GAP + ICON_WIDTH + ICON_GAP;
        
        cell.mTitleLabel.frame = CGRectMake(10.0, 10.0, width, 25.0);
        cell.mDescryptionLabel.frame = CGRectMake(10.0,40.0, width - iconTotalWidth, 25.0);
        cell.mImageIcon.frame = CGRectMake(width - ICON_GAP, 10.0, ICON_WIDTH, ICON_HEIGHT);
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    AppRecords *appRecord=[mArrayRecord objectAtIndex:indexPath.row];
    NSString *imageName = appRecord.mImageURLString;
    if ([[NullCheck checknull:imageName] isEqualToString:@""]) {
        imageName = @"";
    }
    
    return [cell getHeight : imageName];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat: @"%ld", (long)indexPath.row];
    AppRecords *appRecord=[mArrayRecord objectAtIndex:indexPath.row];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    float width = mTableView.frame.size.width;
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        float iconTotalWidth = ICON_GAP + ICON_WIDTH + ICON_GAP;
        
        cell.mTitleLabel.frame = CGRectMake(10.0, 10.0, width, 25.0);
        cell.mDescryptionLabel.frame = CGRectMake(10.0,40.0, width - iconTotalWidth, 25.0);
    }
    
    cell.mImageIcon.frame = CGRectMake( width - ICON_WIDTH - ICON_GAP, 10.0, ICON_WIDTH, ICON_HEIGHT);
    CGRect frame = cell.mLoadingView.frame;
    frame.origin = CGPointMake(cell.mImageIcon.frame.origin.x + ((ICON_WIDTH - frame.size.width)/2), cell.mImageIcon.frame.origin.y + ((ICON_HEIGHT - frame.size.height)/2));
    cell.mLoadingView.frame = frame;
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    
    NSString *imageName = appRecord.mImageURLString;
    if ([[NullCheck checknull:imageName] isEqualToString:@""]) {
        imageName = @"";
    }
    if(imageName.length > 0) {
        
        UIImageView *imageView = cell.mImageIcon;
        
        UIImage *image = [mImageCache objectForKey:imageName];
        
        if(image){
            imageView.image = image;
        } else {
            [cell.mLoadingView startAnimating];
            imageView.image = nil;
            
            dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
            dispatch_async(downloadQueue, ^{
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]];
                UIImage *image = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(!image) {
                        imageView.image = [UIImage imageNamed: @"no_photo_icon.jpeg"];
                    } else {
                        imageView.image = image;
                    }
                    //if(image)
                    {
                        [mImageCache setObject:imageView.image forKey:imageName];
                        
                        
                    }
                    [cell.mLoadingView stopAnimating];
                    
                });
                
            });
        }
    } else {
        [cell.mLoadingView stopAnimating];
    }
    
    return cell;
}
////////////////////////////////// Orientation //////////////////////////////////////////////////

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
    [mTableView reloadData];
}
////////////////////////////////////// Service layer /////////////////////////////////////////////////

-(void)Refresh
{
    NSString *str_url=kAPIEndpointHost;
    
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:str_url] encoding:NSISOLatin2StringEncoding error:nil];
    if(string) {
        NSData *metOfficeData = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:metOfficeData options:kNilOptions error:nil];

        for (NSDictionary *dict in [jsonObject valueForKey:@"rows"])
        {
            AppRecords *record=[[AppRecords alloc]init];
            record.mImageURLString=[dict valueForKey:@"imageHref"];
            record.mTitleName=[dict valueForKey:@"title"];
            record.mDescription=[dict valueForKey:@"description"];
            
            if ([[NullCheck checknull:record.mImageURLString] isEqualToString:@""])
            {
                record.mImageURLString = @"";
            }
            
            if ([[NullCheck checknull:record.mTitleName] isEqualToString:@""])
            {
                record.mTitleName = @"";
            }
            
            if ([[NullCheck checknull:record.mDescription] isEqualToString:@""])
            {
                record.mDescription = @"";
            }
            
            if(!(record.mTitleName.length == 0 && record.mImageURLString.length == 0 && record.mDescription.length == 0)) {
                
                [mArrayRecord addObject:record];
            }
        }

        [refreshControl endRefreshing];
    } else {
        
        UIAlertView *mAlertView = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Network Failure to load Data" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [mAlertView show];
        
        mAlertView = nil;
    }
}

@end
