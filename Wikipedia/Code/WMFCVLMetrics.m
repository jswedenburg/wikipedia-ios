#import "WMFCVLMetrics.h"
@import UIKit;

@interface WMFCVLMetrics ()
@property (nonatomic) CGSize boundsSize;
@property (nonatomic) CGFloat readableWidth;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) UIEdgeInsets readableMargins;
@property (nonatomic) UIEdgeInsets margins;
@property (nonatomic) UIEdgeInsets sectionMargins;
@property (nonatomic) CGFloat interColumnSpacing;
@property (nonatomic) CGFloat interSectionSpacing;
@property (nonatomic) CGFloat interItemSpacing;
@property (nonatomic, copy) NSArray<NSNumber *> *columnWeights;
@end

@implementation WMFCVLMetrics

- (id)copyWithZone:(NSZone *)zone {
    WMFCVLMetrics *copy = [[WMFCVLMetrics allocWithZone:zone] init];
    copy.boundsSize = self.boundsSize;
    copy.readableWidth = self.readableWidth;
    copy.numberOfColumns = self.numberOfColumns;
    copy.margins = self.margins;
    copy.readableMargins = self.readableMargins;
    copy.sectionMargins = self.sectionMargins;
    copy.interColumnSpacing = self.interColumnSpacing;
    copy.interSectionSpacing = self.interSectionSpacing;
    copy.interItemSpacing = self.interItemSpacing;
    copy.columnWeights = self.columnWeights;
    copy.shouldMatchColumnHeights = self.shouldMatchColumnHeights;
    return copy;
}

+ (nonnull WMFCVLMetrics *)metricsWithBoundsSize:(CGSize)boundsSize readableWidth:(CGFloat)readableWidth layoutMargins:(UIEdgeInsets)layoutMargins layoutDirection:(UIUserInterfaceLayoutDirection)layoutDirection {
    return [self metricsWithBoundsSize:boundsSize readableWidth:readableWidth layoutMargins:layoutMargins firstColumnRatio:1 secondColumnRatio:1 layoutDirection:layoutDirection];
}

+ (nonnull WMFCVLMetrics *)metricsWithBoundsSize:(CGSize)boundsSize readableWidth:(CGFloat)readableWidth layoutMargins:(UIEdgeInsets)layoutMargins firstColumnRatio:(CGFloat)firstColumnRatio secondColumnRatio:(CGFloat)secondColumnRatio layoutDirection:(UIUserInterfaceLayoutDirection)layoutDirection {
    WMFCVLMetrics *metrics = [[WMFCVLMetrics alloc] init];
    metrics.boundsSize = boundsSize;
    metrics.readableWidth = readableWidth;

    BOOL isRTL = layoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    BOOL isPad = boundsSize.width >= 600;
    BOOL useTwoColumns = isPad || (boundsSize.width > boundsSize.height && readableWidth >= 500);

    metrics.numberOfColumns = useTwoColumns ? 2 : 1;
    metrics.columnWeights = useTwoColumns ? isRTL ? @[@(secondColumnRatio), @(firstColumnRatio)] : @[@(firstColumnRatio), @(secondColumnRatio)] : @[@1];
    metrics.interColumnSpacing = useTwoColumns ? 20 : 0;
    metrics.interItemSpacing = 0;
    metrics.interSectionSpacing = useTwoColumns ? 20 : 30;

    if (useTwoColumns) {
        CGFloat marginWidth = MAX(MAX(layoutMargins.left, layoutMargins.right), round(0.5 * (boundsSize.width - (readableWidth * metrics.numberOfColumns))));
        metrics.margins = UIEdgeInsetsMake(20, marginWidth, 20, marginWidth);
    } else {
        CGFloat marginWidth = MAX(layoutMargins.left, layoutMargins.right);
        metrics.margins = UIEdgeInsetsMake(0, marginWidth, 0, marginWidth);
    }

    metrics.sectionMargins = UIEdgeInsetsZero;
    metrics.readableMargins = UIEdgeInsetsMake(15, 13, 15, 13);
    metrics.shouldMatchColumnHeights = YES;
    return metrics;
}

+ (nonnull WMFCVLMetrics *)singleColumnMetricsWithBoundsSize:(CGSize)boundsSize readableWidth:(CGFloat)readableWidth layoutMargins:(UIEdgeInsets)layoutMargins interItemSpacing:(CGFloat)interItemSpacing interSectionSpacing:(CGFloat)interSectionSpacing {
    WMFCVLMetrics *metrics = [[WMFCVLMetrics alloc] init];
    metrics.boundsSize = boundsSize;
    metrics.readableWidth = readableWidth;
    metrics.numberOfColumns = 1;
    metrics.columnWeights = @[@1];
    metrics.interColumnSpacing = 0;
    metrics.interItemSpacing = interItemSpacing;
    metrics.interSectionSpacing = interSectionSpacing;
    metrics.margins = UIEdgeInsetsZero;
    metrics.sectionMargins = UIEdgeInsetsZero;
    CGFloat marginWidth = MAX(MAX(layoutMargins.left, layoutMargins.right), round(0.5 * (boundsSize.width - readableWidth)));
    metrics.readableMargins = UIEdgeInsetsMake(10, marginWidth, 10, marginWidth);
    metrics.shouldMatchColumnHeights = NO;
    return metrics;
}

+ (nonnull WMFCVLMetrics *)singleColumnMetricsWithBoundsSize:(CGSize)boundsSize readableWidth:(CGFloat)readableWidth layoutMargins:(UIEdgeInsets)layoutMargins {
    return [self singleColumnMetricsWithBoundsSize:boundsSize readableWidth:readableWidth layoutMargins:layoutMargins interItemSpacing:0 interSectionSpacing:0];
}

@end
