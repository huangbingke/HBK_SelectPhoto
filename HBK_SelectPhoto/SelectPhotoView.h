//
//  SelectPhotoView.h
//  HBK_SelectPhoto
//
//  Created by 黄冰珂 on 2018/4/27.
//  Copyright © 2018年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectPhotoViewDelegate <NSObject>
/*
 *添加照片
 */
- (void)addPhoto;
/**
 选好照片之后, 点击照片, 进入预览模式
 @param index 点击的第几张
 @param dataSoure 总照片
 */
- (void)clickPhotoWithIndex:(NSInteger)index dataSorce:(NSMutableArray *)dataSoure;

@end

@interface SelectPhotoView : UIView

@property (nonatomic, weak) id<SelectPhotoViewDelegate>delegeate;

/**
 从相册选好之后显示出来缩略图
 */
- (void)sendPhotos:(NSArray<UIImage *> *)photoArray;

@end

//-----------------------展示照片的cell-------------------------------
@interface PhotoCell: UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void(^DeletePhotoBlock)(void);
@property (nonatomic, strong) UIButton *deleteBtn;
@end











