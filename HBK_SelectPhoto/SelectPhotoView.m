//
//  SelectPhotoView.m
//  HBK_SelectPhoto
//
//  Created by 黄冰珂 on 2018/4/27.
//  Copyright © 2018年 KK. All rights reserved.
//

#import "SelectPhotoView.h"
/**
 * 获取mainScreen的bounds的宽度
 */
#define SCREEN_W            [UIScreen mainScreen].bounds.size.width
/**
 * 获取mainScreen的bounds的高度
 */
#define SCREEN_H            [UIScreen mainScreen].bounds.size.height



static NSString *cellID = @"PhotoCellID";

@class PhotoCell;
@interface SelectPhotoView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray<UIImage *> *dataSource;
@end

@implementation SelectPhotoView


- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.photoCollectionView];
        [self.photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    cell.image = self.dataSource[indexPath.row];
    if (self.dataSource.count == indexPath.row + 1) {
        cell.deleteBtn.hidden = YES;
    } else {
        cell.deleteBtn.hidden = NO;
    }
    cell.DeletePhotoBlock = ^{
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self updateUIWithDataSource:self.dataSource];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataSource.count - 1) {
        if (self.delegeate && [self.delegeate respondsToSelector:@selector(addPhoto)]) {
            [self.delegeate addPhoto];
        }
    } else {
        if (self.delegeate && [self.delegeate respondsToSelector:@selector(clickPhotoWithIndex:dataSorce:)]) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataSource];
            [tempArray removeLastObject];
            [self.delegeate clickPhotoWithIndex:indexPath.row dataSorce:tempArray];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width-25)/4, (collectionView.frame.size.width-25)/4);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (void)sendPhotos:(NSArray *)photoArray {
    [self.dataSource removeLastObject];
    [self.dataSource addObjectsFromArray:photoArray];
    [self.dataSource insertObject:[UIImage imageNamed:@"add"] atIndex:self.dataSource.count];
    [self updateUIWithDataSource:self.dataSource];
}

- (void)updateUIWithDataSource:(NSMutableArray *)dataSource {
    NSInteger line = (dataSource.count % 4 == 0) ? (dataSource.count / 4) : (dataSource.count / 4 + 1);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo((SCREEN_W-25)/4 * line + (line+1)*5);
    }];
    [self.photoCollectionView reloadData];
}



#pragma mark - Lazy -
- (NSMutableArray<UIImage *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
        [_dataSource addObject:[UIImage imageNamed:@"add"]];
    }
    return _dataSource;
}
- (UICollectionView *)photoCollectionView {
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _photoCollectionView.dataSource = self;
        _photoCollectionView.delegate = self;
        _photoCollectionView.backgroundColor = [UIColor greenColor];
        [_photoCollectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:cellID];
    }
    return _photoCollectionView;
}

@end


#pragma mark - Cell - -------------------------

@interface PhotoCell ()
@property (nonatomic, strong) UIImageView *photoImageView;

@end
@implementation PhotoCell


- (void)setImage:(UIImage *)image {
    _image = image;
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(5);
            make.top.mas_equalTo(self.contentView.mas_top).offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
            
        }];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self.contentView).offset(0);
            make.width.height.mas_equalTo(20);
        }];
    self.photoImageView.image = image;
    
}


- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.photoImageView];
    }
    return _photoImageView;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        self.deleteBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.deleteBtn setTitle:@"-" forState:(UIControlStateNormal)];
        [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:25];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        self.deleteBtn.backgroundColor = [UIColor redColor];
        self.deleteBtn.layer.cornerRadius = 10;
        self.deleteBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.deleteBtn];
    }
    return _deleteBtn;
}

- (void)deleteBtnAction {
    if (self.DeletePhotoBlock) {
        self.DeletePhotoBlock();
    }
}

@end














