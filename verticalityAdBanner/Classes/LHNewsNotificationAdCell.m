//
//  LHNewsNotificationAdCell.m
//  EssayExperience
//
//  Created by luhua-mac on 2020/11/21.
//

#import "LHNewsNotificationAdCell.h"

@interface LHNewsNotificationCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView  * iconImageView;
@property(nonatomic,strong) UILabel      * titleNameLabel;

@end

@implementation LHNewsNotificationCollectionViewCell

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageNamed:@"tab_home_20"];
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}
-(UILabel *)titleNameLabel{
    if (!_titleNameLabel) {
        _titleNameLabel = [UILabel new];
        _titleNameLabel.font= [UIFont systemFontOfSize:13];
        [self addSubview:_titleNameLabel];
    }
    return _titleNameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
//        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).with.offset(15);
//            make.centerY.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(22, 22));
//        }];
//
//        [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.iconImageView.mas_right).with.offset(15);
//            make.centerY.equalTo(self);
//            make.right.equalTo(self.mas_right).with.offset(-10);
//            make.height.mas_equalTo(25);
//        }];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView setFrame:CGRectMake(15, (self.frame.size.height / 2) - 11, 22, 22)];
    [self.titleNameLabel setFrame:CGRectMake(52, (self.frame.size.height / 2) - 11, 200, 25)];
    
}


@end

@interface LHNewsNotificationAdCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LHNewsNotificationAdCell
static NSInteger const advertScrollViewMaxSections = 100;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initialization];
        [self setupSubviews];
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self removeTimer];
    }
}
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)initialization {
    _scrollTimeInterval = 2.0;
    
    [self addTimer];
}
-(void)addTimer{
    [self removeTimer];
    self.timer = [NSTimer timerWithTimeInterval:self.scrollTimeInterval target:self selector:@selector(beginUpdateUI) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)beginUpdateUI{
    if (self.dataSourceArray.count == 0) return;
    // 1、当前正在展示的位置
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    // 马上显示回最中间那组的数据
    NSIndexPath *resetCurrentIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:0.5 * advertScrollViewMaxSections];
    [self.collectionView scrollToItemAtIndexPath:resetCurrentIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    
    // 2、计算出下一个需要展示的位置
    NSInteger nextItem = resetCurrentIndexPath.item + 1;
    NSInteger nextSection = resetCurrentIndexPath.section;
    if (nextItem == self.dataSourceArray.count) {
        nextItem = 0;
        nextSection++;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    // 3、通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}
-(void)removeTimer{
    [_timer invalidate];
    _timer = nil;
}

-(void)setupSubviews{
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tempView];
    [self addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LHNewsNotificationCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LHNewsNotificationCollectionViewCell class])];
    }
    return _collectionView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    _collectionView.frame = self.bounds;
    
    if (self.dataSourceArray.count > 1) {
        [self defaultSelectedScetion];
    }
}
-(void)setDataSourceArray:(NSArray *)dataSourceArray{
    _dataSourceArray = dataSourceArray;
    if (dataSourceArray.count > 1) {
        [self addTimer];
    } else {
        [self removeTimer];
    }
    [self.collectionView reloadData];
}
-(void)defaultSelectedScetion{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0.5 * advertScrollViewMaxSections] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}
#pragma mark - - - UICollectionView 的 dataSource、delegate方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return advertScrollViewMaxSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LHNewsNotificationCollectionViewCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LHNewsNotificationCollectionViewCell class]) forIndexPath:indexPath];
    cell.titleNameLabel.text = self.dataSourceArray[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsNotificationAdCell:didSelectedItemAtIndex:)]) {
        [self.delegate newsNotificationAdCell:self didSelectedItemAtIndex:indexPath.item];
    }
}
- (void)setScrollTimeInterval:(CFTimeInterval)scrollTimeInterval {
    _scrollTimeInterval = scrollTimeInterval;
    if (scrollTimeInterval) {
        [self addTimer];
    }
}


@end
