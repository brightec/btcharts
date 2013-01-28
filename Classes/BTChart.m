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
        _allowDecimalsOnAxis = YES;
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.style = [[BTChartStyle alloc] init];
        _allowDecimalsOnAxis = YES;        
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
    self.graph = (CPTXYGraph *)[self.style newGraph];
    self.graph.title  = self.chartTitle;
    self.graph.titleTextStyle = [self.style graphTitleTextStyle];
//    self.graph.titleDisplacement = CGPointMake(0, -20);
    self.hostedGraph = self.graph;
    
    if (self.chartTitle.length > 0) {
        self.graph.plotAreaFrame.paddingTop += 30.0f;
    }

    CPTXYAxis *y = [self yAxis];
    y.majorGridLineStyle = [self.style gridLineStyle];
    y.delegate = self;

    if (self.yAxisLabelFormatter != nil) {
        y.labelFormatter = self.yAxisLabelFormatter;
    }
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
    xRange.location = CPTDecimalFromFloat(-0.5f);
    xRange.length = CPTDecimalAdd(xRange.length, CPTDecimalFromFloat(1.0f));

	CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];

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
	[yRange expandRangeByFactor:CPTDecimalFromDouble(1.3)];
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
            self.graph.plotAreaFrame.paddingBottom += 65.0f;
            self.graph.legendDisplacement = CGPointMake(0, 0);
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
            self.graph.plotAreaFrame.paddingLeft += 70.0f;
            self.graph.legendDisplacement = CGPointMake(0, 0);
            break;

        case CPTRectAnchorRight:
            self.graph.plotAreaFrame.paddingRight += 70.0f;
            self.graph.legendDisplacement = CGPointMake(0, 0);
            break;

        default:
            break;
    }
}


- (CPTXYAxis *)xAxis
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    return x;
}


- (CPTXYAxis *)yAxis
{
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    CPTXYAxis *y = axisSet.yAxis;
    return y;
}


- (void)reloadData
{
    CPTXYAxis *x = [self xAxis];
    x.axisLabels = [self xAxisLabels];

    CPTXYAxis *y = [self yAxis];
    if (!self.allowDecimalsOnAxis) {
        y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    }

    [self.graph reloadData];
    [self setupPlotSpace];
}

# pragma mark -
# pragma mark CPTAxisDelegate

-(void)axisDidRelabel:(CPTAxis *)axis
{
    if (self.allowDecimalsOnAxis || axis != [self yAxis]) {
        return;
    }

    NSMutableSet *newLocations = [@[] mutableCopy];
    for (NSDecimalNumber *l in axis.majorTickLocations) {
        float lf = [l floatValue];
        if (lf == (int)lf) {
            [newLocations addObject:l];
        }
    }

    if (newLocations.count < axis.majorTickLocations.count) {
        axis.labelingPolicy = CPTAxisLabelingPolicyLocationsProvided;
        axis.majorTickLocations = newLocations;
    }
}

@end
