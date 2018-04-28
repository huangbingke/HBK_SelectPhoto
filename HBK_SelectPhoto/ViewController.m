//
//  ViewController.m
//  HBK_SelectPhoto
//
//  Created by 黄冰珂 on 2018/4/27.
//  Copyright © 2018年 KK. All rights reserved.
//

#import "ViewController.h"
#import "SelectPhotoView.h"

/**
 * 获取mainScreen的bounds的宽度
 */
#define SCREEN_W            [UIScreen mainScreen].bounds.size.width
/**
 * 获取mainScreen的bounds的高度
 */
#define SCREEN_H            [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<SelectPhotoViewDelegate>
@property (nonatomic, strong) SelectPhotoView *photoView;

@property (nonatomic, strong) ZLPhotoActionSheet *photoSheet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.photoView = [[SelectPhotoView alloc] init];
    self.photoView.delegeate = self;
    [self.view addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(self.view).offset(200);
        make.height.mas_equalTo((SCREEN_W-25)/4+10);
    }];
}

- (void)addPhoto {
    NSLog(@"添加照片");
    [self.photoSheet showPhotoLibrary];
}

- (void)clickPhotoWithIndex:(NSInteger)index dataSorce:(NSMutableArray *)dataSoure {
    NSLog(@"浏览图片----%ld-----%@", index, dataSoure);
    
    
}

- (ZLPhotoActionSheet *)photoSheet {
    if (!_photoSheet) {
        _photoSheet = [[ZLPhotoActionSheet alloc] init];
        _photoSheet.sender = self;
        __weak typeof(self) weakSelf = self;
        [weakSelf.photoSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            [weakSelf.photoView sendPhotos:images];
        }];
    }
    return _photoSheet;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
