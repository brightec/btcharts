//
//  BTLineChart.h
//  ChartTest
//
//  Created by Cameron Cooke on 08/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTChart.h"

@protocol BTLineChartDelegate;


@interface BTLineChart : BTChart <CPTScatterPlotDataSource>
@property (nonatomic, weak) IBOutlet id<BTLineChartDelegate>delegate;
@end


@protocol BTLineChartDelegate <NSObject>
@optional
- (UIColor *)lineChart:(BTLineChart *)lineChart lineColourForPlotItem:(NSInteger)item;
- (void)lineChart:(BTLineChart *)barChart willDisplayPlotItem:(CPTScatterPlot *)scatterPlot;
@end