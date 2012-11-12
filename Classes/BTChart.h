//
//  BTChart.h
//  ChartTest
//
//  Created by Cameron Cooke on 08/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "BTPlotDataItem.h"
#import "BTChartStyle.h"


@protocol BTChartDataSource;


@interface BTChart : CPTGraphHostingView
@property (nonatomic, weak) IBOutlet id<BTChartDataSource>dataSource;
@property (nonatomic, copy) NSString *chartTitle;
@property (nonatomic, strong) CPTGraph *graph;
@property (nonatomic, strong) BTChartStyle *style;
@property (nonatomic, copy) NSString *styleClassName;


// configures basic aspects of the graph that is common to all
// kinds of graphs. All subclasses should implement this method
// and be sure to call the superclass implementation. It's also
// important that at the bottom of the subclass's implementation
// of this method that setupPlotSpace: is called.
- (void)setupGraph;

// setups up the plot space so that plot labels are never clipped
- (void)setupPlotSpace;

// axis
- (CPTXYAxis *)xAxis;
- (CPTXYAxis *)yAxis;
- (NSSet *)xAxisLabels;

// legends
- (void)addHorizontalLegendAtPosition:(CPTRectAnchor)position;
- (void)addVerticalLegendAtPosition:(CPTRectAnchor)position;

@end


@protocol BTChartDataSource <NSObject>

- (NSInteger)numberOfPlotGroupsInChart:(BTChart*)chart;
- (NSInteger)chart:(BTChart *)chart numberOfPlotsInGroup:(NSInteger)group;
- (NSString *)chart:(BTChart *)chart titleForGroup:(NSInteger)group;
- (id<BTPlotDataItem>)chart:(BTChart *)chart dataItemForIndexPath:(NSIndexPath *)indexPath;

@end