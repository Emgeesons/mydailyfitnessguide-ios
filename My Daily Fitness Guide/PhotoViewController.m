//
//  PhotoViewController.m
//  My Daily Fitness Guide
//
//  Created by Yogesh Suthar on 10/06/2014.
//  Copyright (c) 2014 Yogesh Suthar. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCell.h"
#import "CustomButton.h"

@interface PhotoViewController () {
    CustomButton *btnDelete;
    float imageHeight;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation PhotoViewController

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
    
    [self loadImages];
    [self setupCollectionView];
    
    if (IsIphone5) {
        imageHeight = 548;
    } else {
        imageHeight = 460;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [flowLayout setItemSize:CGSizeMake(320, imageHeight)];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    NSIndexPath *indexPathTo = [NSIndexPath indexPathForRow:self.imagePosition inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPathTo atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDoneClicked)];
    self.navItem.rightBarButtonItem = btnDone;
    
    UIBarButtonItem *lblName = [[UIBarButtonItem alloc] initWithTitle:self.dataArray[self.imagePosition] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navItem.leftBarButtonItem = lblName;
    
    // Do any additional setup after loading the view.
    
    btnDelete = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    [btnDelete setBackgroundImage:[UIImage imageNamed:@"ic_trash.png"] forState:UIControlStateNormal];
    btnDelete.fbTitle = self.dataArray[self.imagePosition];
    [btnDelete addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonDelete = [[UIBarButtonItem alloc] initWithCustomView:btnDelete];
    self.navItemBottom.rightBarButtonItem = buttonDelete;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnDoneClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadImages {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [[docPaths objectAtIndex:0] stringByAppendingPathComponent:@"/gallery"];
    self.dataArray = [NSMutableArray arrayWithArray:[fm contentsOfDirectoryAtPath:dataPath error:nil]];
}

#pragma mark - UICollectionView Delegate methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

-(void)setupCollectionView {
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSString *imageName = [self.dataArray objectAtIndex:indexPath.row];
    [cell setImageName:imageName];
    
    [cell updateCell];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(320, imageHeight);
}

#pragma mark - UIscrollView Delegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        UIBarButtonItem *lblName = [[UIBarButtonItem alloc] initWithTitle:self.dataArray[indexPath.row] style:UIBarButtonItemStylePlain target:self action:nil];
        self.navItem.leftBarButtonItem = lblName;
    }
}

#pragma mark - Delete Functionality Function

-(void) deleteImage:(CustomButton *)sender {
    CustomButton *btn = (CustomButton *)sender;
    
    // integer for current item
    int row = 0;
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        btn.fbTitle = self.dataArray[indexPath.row];
        row = indexPath.row;
    }
    
    [self.collectionView performBatchUpdates:^{
        // remove item from array
        [_dataArray removeObjectAtIndex:row];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:row inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        
        // remove image from gallery folder as well
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dataPath = [documentsPath stringByAppendingPathComponent:@"/gallery"];
        NSString *filePath = [dataPath stringByAppendingString:[NSString stringWithFormat:@"/%@",btn.fbTitle]];
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        
    } completion:^(BOOL finished) {
        // reset name of image
        for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            UIBarButtonItem *lblName = [[UIBarButtonItem alloc] initWithTitle:self.dataArray[indexPath.row] style:UIBarButtonItemStylePlain target:self action:nil];
            self.navItem.leftBarButtonItem = lblName;
        }
    }];
    
    if (self.dataArray.count == 0) {
        [self btnDoneClicked];
    }
}

@end
