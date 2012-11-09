//
//  BTChart.m
//  ChartTest
//
//  Created by Cameron Cooke on 08/11/2012.
//  Copyright (c) 2012 Brightec Ltd. All rights reserved.
//

#import "BTChart.h"


@implementation BTChart


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = [[BTChartStyle alloc] init];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.style = [[BTChartStyle alloc] init];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    if (self.hostedGraph == nil) {
        [self setupGraph];
    }
}


- (void)setupGraph
{
    // create graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];    
    self.graph.paddingBottom = 10.0f;
    self.graph.paddingTop = 10.0f;
    self.graph.paddingLeft = 10.0f;
    self.graph.paddingRight = 10.0f;
    self.graph.title  = self.chartTitle;
    self.graph.titleTextStyle = [self.style graphTitleTextStyle];
    self.graph.titleDisplacement = CGPointMake(0, -30);
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostedGraph = self.graph;

    // add some padding to allow space for axis, title and legend
    self.graph.plotAreaFrame.paddingLeft = 70.0f;
    self.graph.plotAreaFrame.paddingTop = 60.0f;
    self.graph.plotAreaFrame.paddingBottom = 50.0f;
    self.graph.plotAreaFrame.paddingRight = 50.0f;
}


- (NSSet *)xAxisLabels
{
    NSInteger numberOfGroups = [self.dataSource numberOfPlotGroupsInChart:self];
    NSMutableSet *xAxisLabels = [NSMutableSet set];
    for (NSInteger i = 0; i < numberOfGroups; i++) {
        NSString *title = [self.dataSource chart:self titleForGroup:i];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:title textStyle:[self.style axisLabelTextStyle]];
        label.tickLocation = CPTDecimalFromInt(i);
        label.alignment = CPTAlignmentCenter;
        [xAxisLabels addObject:label];
    }
    return xAxisLabels;
}


- (void)setupPlotSpace
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    [plotSpace scaleToFitPlots:self.graph.allPlots];

	// Adjust visible ranges so plot symbols along the edges are not clipped
	CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
	CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    xRange.location = CPTDecimalFromFloat(-0.5f);
    xRange.length = CPTDecimalAdd(xRange.length, CPTDecimalFromFloat(1.0f));

    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    CPTXYAxis *y = axisSet.yAxis;

	x.orthogonalCoordinateDecimal = yRange.location;
	y.orthogonalCoordinateDecimal = xRange.location;

    // use the visible range to restrict the drawing of the axsises
    // to the calculated scale.
	x.visibleRange = xRange;
	y.visibleRange = yRange;

	x.gridLinesRange = yRange;
	y.gridLinesRange = xRange;

    // grow the range so that plot labels are not clipped but the
    // range is not disabled any bigger as we restricted it using he
    // visible range property.
	[xRange expandRangeByFactor:CPTDecimalFromDouble(1.05)];
	[yRange expandRangeByFactor:CPTDecimalFromDouble(1.1)];
	plotSpace.xRange = xRange;
	plotSpace.yRange = yRange;
}

- (void)addHorizontalLegendAtPosition:(CPTRectAnchor)position
{
    CPTLegend *legend = [CPTLegend legendWithGraph:self.graph];
    legend.numberOfRows = 1;
    legend.equalColumns = NO;
    legend.textStyle = [self.style legendTextStyle];

    self.graph.legend = legend;
    self.graph.legendAnchor = position;

    switch (position) {
        case CPTRectAnchorTop:
            self.graph.plotAreaFrame.paddingTop += 35.0f;
            self.graph.legendDisplacement = CGPointMake(0, -60);
            break;

        case CPTRectAnchorBottom:
            self.graph.plotAreaFrame.paddingBottom += 35.0f;
            self.graph.legendDisplacement = CGPointMake(0, 30);
            break;

        default:
            break;
    }
}


- (void)addVerticalLegendAtPosition:(CPTRectAnchor)position
{
    CPTLegend *legend = [CPTLegend legendWithGraph:self.graph];
    legend.numberOfColumns = 1;
    legend.equalColumns = NO;
    legend.textStyle = [self.style legendTextStyle];
    
    self.graph.legend = legend;
    self.graph.legendAnchor = position;

    switch (position) {
        case CPTRectAnchorLeft:
            self.graph.plotAreaFrame.paddingLeft += 100.0f;
            self.graph.legendDisplacement = CGPointMake(40, 0);
            break;

        case CPTRectAnchorRight:
            self.graph.plotAreaFrame.paddingRight += 100.0f;
            self.graph.legendDisplacement = CGPointMake(-40, 0);
            break;

        default:
            break;
    }
}


- (CPTXYAxis *)xAxis
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    {
        x.majorIntervalLength		  = CPTDecimalFromInteger(1);
        x.majorTickLength             = 25;
        x.minorTicksPerInterval		  = 0;
        x.axisLineStyle				  = [self.style axisLineStyle];
        x.majorTickLineStyle		  = [self.style axisMajorTickLineStyle];
        x.minorTickLineStyle		  = [self.style axisMinorTickLineStyle];
        x.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    }

    return x;
}


- (CPTXYAxis *)yAxis
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *y = axisSet.yAxis;
    {
        y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
        y.majorTickLength             = 25;
        y.minorTicksPerInterval       = 0;
        y.axisLineStyle				  = [self.style axisLineStyle];
        y.majorTickLineStyle		  = [self.style axisMajorTickLineStyle];
        y.minorTickLineStyle		  = [self.style axisMinorTickLineStyle];
        y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    }

    return y;
}


@end
