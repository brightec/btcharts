//
//  BTBarChart.h
//  ChartTest
//
//  Created by Cameron Cooke on 07/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import "BTChart.h"

@protocol BTBarChartDelegate;


@interface BTBarChart : BTChart <CPTBarPlotDataSource, CPTBarPlotDelegate>
@property (nonatomic, copy) NSString *chartTitle;
@property (nonatomic, weak) IBOutlet id<BTBarChartDelegate>delegate;
@end


@protocol BTBarChartDelegate <NSObject>
@optional

// should return an array with two UIColor objects. The first item is the gradient start colour and the
// last item is the gradient end colour.
- (NSArray *)barChart:(BTChart *)barChart startAndEndGradientColorsForPlotItem:(NSInteger)item;

- (void)barChart:(BTChart *)barChart willDisplayPlotItem:(CPTBarPlot *)barPlot;

@end