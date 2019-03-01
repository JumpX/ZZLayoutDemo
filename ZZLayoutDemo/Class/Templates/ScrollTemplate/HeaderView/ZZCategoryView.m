//
//  ZZCategoryView.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZCategoryView.h"
#import "ZZSectionModel.h"
#import "ZZTabModel.h"
#import "UIView+Addtion.h"
#import "ZZTabCollectionViewCell.h"
#import "UIColor+ZZ.h"

@interface ZZCategoryView ()<UICollectionViewDataSource, UICollectionViewDelegate>

//@property (nonatomic, strong)   UIImageView *imageView;
@property (nonatomic, strong)   ZZSectionModel        *sectionModel;
@property (nonatomic, assign)   NSInteger             currnetIndex;
@property (nonatomic, strong)   UICollectionView      *tabCollectionView;
@property (nonatomic, assign)   CGFloat               paddingItemSpacing;

@property (nonatomic, strong)   UIView                *selectedView;

@end

@implementation ZZCategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self addSubview:self.imageView];
        self.paddingItemSpacing = 0.0;
        self.currnetIndex = 1;
        [self addSubview:self.tabCollectionView];
        [self addSubview:self.selectedView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerDidScroll:) name:kCellHeaderDidScroll object:nil];
    }
    return self;
}

- (void)headerDidScroll:(NSNotification *)noti
{
    [self collectionView:self.tabCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:[noti.object integerValue] inSection:0]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tabCollectionView.frame = self.bounds;
}

- (void)bindDataWithViewModel:(ZZSectionModel *)viewData
{
//    self.imageView.image = [UIImage imageNamed:@"category.png"];
    self.sectionModel = viewData;
    self.tabCollectionView.backgroundColor = [UIColor greenColor];
    [self p_adjustCollectionViewPadding];
    [self.tabCollectionView reloadData];
    CGFloat tabWidth = self.sectionModel.tabList.firstObject.tabWidth.floatValue;
    self.selectedView.frame = CGRectMake(self.currnetIndex*tabWidth, self.height-2, tabWidth, 2);

    if (self.sectionModel.tabIndex < [self.sectionModel.tabList count]) {
        [self.tabCollectionView performBatchUpdates:^{
            self.currnetIndex = self.sectionModel.tabIndex;
            [self.tabCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.sectionModel.tabIndex inSection:0]
                                                 animated:NO
                                           scrollPosition:UICollectionViewScrollPositionNone];
        } completion:^(BOOL finished) {
            [self.tabCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.sectionModel.tabIndex inSection:0]
                                           atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                   animated:NO];
        }];
    }
}

- (void)p_adjustCollectionViewPadding
{
    __block CGFloat totoalWidth = 0.0;
    [self.sectionModel.tabList enumerateObjectsUsingBlock:^(__kindof ZZTabModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totoalWidth += obj.tabWidth.floatValue;
    }];
    CGFloat screenWidth = CGRectGetWidth(self.tabCollectionView.frame);
    if (totoalWidth < screenWidth) {
        CGFloat space = (screenWidth - totoalWidth) / (self.sectionModel.tabList.count + 1);
        self.paddingItemSpacing = space;
    } else {
        self.paddingItemSpacing = 0.0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateSelectView];
}

- (void)updateSelectView
{
    ZZTabCollectionViewCell *cell = (ZZTabCollectionViewCell *)[self.tabCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currnetIndex inSection:0]];
    CGRect rect = [cell convertRect:cell.bounds toView:self];
    rect.size.width = self.selectedView.width;
    rect.size.height = self.selectedView.height;
    rect.origin.y = self.selectedView.top;
    [UIView animateWithDuration:0.1 animations:^{
        self.selectedView.frame = rect;
    }];
}

#pragma  mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTabModel *tabModel = self.sectionModel.tabList[indexPath.item];
    return CGSizeMake([tabModel.tabWidth floatValue], self.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, self.paddingItemSpacing, 0, self.paddingItemSpacing);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.paddingItemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.paddingItemSpacing;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sectionModel.tabList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTabCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZZTabCollectionViewCell" forIndexPath:indexPath];
    ZZTabModel *tabModel = self.sectionModel.tabList[indexPath.item];
    cell.isSelected = self.currnetIndex==indexPath.row;
    [cell bindDataWithViewModel:tabModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.currnetIndex)
    {
        
    }
    else
    {
        if ([self.sectionModel.templateID isEqualToString:kZZCellReuseIDCategory])
        {
            self.currnetIndex = indexPath.item;
            self.sectionModel.tabIndex = indexPath.item;
        }
        else if ([self.sectionModel.templateID isEqualToString:kZZCellReuseIDScroll])
        {
            self.currnetIndex = indexPath.item;
            self.sectionModel.tabIndex = indexPath.item;
        }
        
        [self.tabCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.item inSection:0]
                                             animated:YES
                                       scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self updateSelectView];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCellItemDidScroll object:@(indexPath.item)];
    }
}

- (UICollectionView *)tabCollectionView
{
    if (!_tabCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.itemSize = CGSizeMake(90.0, 25.0);
        flowLayout.minimumLineSpacing = self.paddingItemSpacing;  //水平方向横竖参数相反
        flowLayout.sectionInset = UIEdgeInsetsMake(0, self.paddingItemSpacing, 0, self.paddingItemSpacing);
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _tabCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, self.height) collectionViewLayout:flowLayout];
        _tabCollectionView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
        _tabCollectionView.showsHorizontalScrollIndicator = NO;
        _tabCollectionView.delegate = self;
        _tabCollectionView.dataSource = self;
        _tabCollectionView.scrollsToTop = NO;
        [_tabCollectionView registerClass:[ZZTabCollectionViewCell class] forCellWithReuseIdentifier:@"ZZTabCollectionViewCell"];
    }
    return _tabCollectionView;
}

- (UIView *)selectedView
{
    if (!_selectedView) {
        _selectedView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectedView.backgroundColor = [UIColor brownColor];
    }
    return _selectedView;
}

//- (UIImageView *)imageView
//{
//    if (!_imageView) {
//        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//    }
//    return _imageView;
//}

@end
