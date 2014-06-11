//
//  GalleryViewController.m
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 09/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryCell.h"
#import "PhotoViewController.h"

@interface GalleryViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    NSArray *filelist;
}

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navBar setBounds:CGRectMake(0, 0, 320, 81)];
    [self.navBar setBarTintColor:[UIColor blackColor]];
    
    UIButton *btnAddPic = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
    [btnAddPic setBackgroundImage:[UIImage imageNamed:@"a_icon1.png"] forState:UIControlStateNormal];
    [btnAddPic addTarget:self action:@selector(addPic) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:btnAddPic];
    self.navItem.rightBarButtonItem = addButton;
    
    [self loadImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    [self loadImages];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadImages {
    // get the count of files in gallery folder
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[docPaths objectAtIndex:0] stringByAppendingPathComponent:@"/gallery"];
    filelist= [fm contentsOfDirectoryAtPath:dataPath error:nil];
    int filesCount = [filelist count];
    
    if (filesCount == 0) {
        self.collectionView.hidden = YES;
    } else {
        self.imageView.hidden = YES;
    }
    [self.collectionView reloadData];
}

-(void)addPic {
    UIActionSheet *picPicker = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil];
    picPicker.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [picPicker showInView:self.view];
}

#pragma mark - UIActionSheet Delegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"%d", buttonIndex);
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    } else if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - UIImagePicker Delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //resize image
    //UIImage *myIcon = [DatabaseExtra imageWithImage:chosenImage scaledToSize:CGSizeMake(74, 74)];
    
    // save image locally
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/gallery"];
    NSString *savedImagePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", [dateFormat stringFromDate:date]]];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - collection view data source

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return filelist.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryCell *cell = (GalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/gallery"];
    NSString *getImagePath = [dataPath stringByAppendingPathComponent:filelist[indexPath.row]];
    UIImage *myIcon = [UIImage imageWithContentsOfFile:getImagePath];
    
    cell.imageView.image = myIcon;
    cell.descLabel.text = [filelist[indexPath.row] substringToIndex:([filelist[indexPath.row] length] - 4)];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"photoSegue"]) {
        NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems objectAtIndex:0];
        PhotoViewController *viewController = (PhotoViewController *)segue.destinationViewController;
        viewController.imagePosition = indexPath.row;
    }
}

@end
