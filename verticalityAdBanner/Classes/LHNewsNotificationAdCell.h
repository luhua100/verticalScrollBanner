//
//  LHNewsNotificationAdCell.h
//  EssayExperience
//
//  Created by luhua-mac on 2020/11/21.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class LHNewsNotificationAdCell;
@protocol newsNotificationAdCellDelegate <NSObject>
/// delegate 方法
- (void)newsNotificationAdCell:(LHNewsNotificationAdCell *)advertScrollView didSelectedItemAtIndex:(NSInteger)index;
@end

@interface LHNewsNotificationAdCell : UITableViewCell
@property(nonatomic,weak) id <newsNotificationAdCellDelegate>delegate;
/** 滚动时间间隔，默认为3s */
@property (nonatomic, assign) CFTimeInterval scrollTimeInterval;
/*数据源的*/
@property(nonatomic,strong) NSArray<NSString *>  * dataSourceArray;
@end

NS_ASSUME_NONNULL_END
