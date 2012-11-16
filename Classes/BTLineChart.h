//
//  BTLineChart.h
//  ChartTest
//
//  Created by Cameron Cooke on 08/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTChart.h"

@interface BTLineChart : BTChart <CPTScatterPlotDataSource>
@end


@protocol BTLineChartDataSource <BTChartDataSource>
@optional
- (UIColor *)lineChart:(BTLineChart *)lineChart lineColourForPlotItem:(NSInteger)item;
@end