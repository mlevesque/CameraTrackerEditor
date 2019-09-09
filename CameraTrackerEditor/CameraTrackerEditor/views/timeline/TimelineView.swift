//
//  TimelineView.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/3/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineView : NSView {
    // -- CONFIGURATIONS
    /** Thickness in pixels for the vertical meter bar. */
    @IBInspectable var verticalMeterThickness: CGFloat = 30
    /** Thickness in pixels for the horizontal meter bar. */
    @IBInspectable var horizontalMeterThickness: CGFloat = 20
    /** Width in pixels for the playhead. */
    @IBInspectable var playheadWidth: CGFloat = 10
    
    /** Background color for the horizontal and vertical meter bars. */
    @IBInspectable var meterBackgroundColor: NSColor = NSColor.darkGray
    /** Border color for the horizontal and vertical meter vars. */
    @IBInspectable var meterBorderColor: NSColor = NSColor.lightGray
    /** Color of the divider lines between the meters and graph. */
    @IBInspectable var meterDividerColor: NSColor = NSColor.white
    
    /** Minimal pixel space threshold between horizontal and vertical ticks. */
    @IBInspectable var tickInterval: CGFloat = 30.0
    
    /** Line width in pixels of minor ticks. */
    @IBInspectable var tMinorWidth: CGFloat = 1.0
    /** Line width in pixels of major ticks. */
    @IBInspectable var tMajorWidth: CGFloat = 1.0
    /** Line width in pixels of the horizontal and vertical ticks at zero. */
    @IBInspectable var tZeroWidth: CGFloat = 1.0
    
    /** Color for minor ticks in the graph area. */
    @IBInspectable var tMinorColor: NSColor = NSColor.lightGray
    /** Color for major ticks in the graph area. */
    @IBInspectable var tMajorColor: NSColor = NSColor.lightGray
    /** Color for the zero ticks in the graph area. */
    @IBInspectable var tZeroColor: NSColor = NSColor.red
    /** Color for minor ticks in the horizontal and vertical meter bars. */
    @IBInspectable var tMMinorColor: NSColor = NSColor.lightGray
    /** Color for major ticks in the horizontal and vertical meter bars. */
    @IBInspectable var tMMajorColor: NSColor = NSColor.lightGray
    /** Color for the zero ticks in the horizontal and vertical meter bars. */
    @IBInspectable var tMZeroColor: NSColor = NSColor.red
    
    /** Color for the X position data graph. */
    @IBInspectable var xPosColor: NSColor = NSColor.red
    /** Color for the Y position data graph. */
    @IBInspectable var yPosColor: NSColor = NSColor.green
    /** Color for the Z position data graph. */
    @IBInspectable var zPosColor: NSColor = NSColor.blue
    /** Color for the X rotation data graph. */
    @IBInspectable var xRotColor: NSColor = NSColor.systemPink
    /** Color for the Y rotation data graph. */
    @IBInspectable var yRotColor: NSColor = NSColor.yellow
    /** Color for the Z rotation data graph. */
    @IBInspectable var zRotColor: NSColor = NSColor.purple
    /** Line width in pixels for all the data graphs. */
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    /** LOD threshold in pixels for when to start using linear line drawing. */
    @IBInspectable var dataLinearThreshold: CGFloat = 1.0
    /** LOD threshold in pixels for when to start using cubic curve drawing. */
    @IBInspectable var dataCubicThreshold: CGFloat = 60.0
    /** Interval in pixels for determining subdivisions for cubic drawing. */
    @IBInspectable var subdivisionInterval: CGFloat = 20.0
    
    /** The color for the text values. */
    @IBInspectable var textColor: NSColor = NSColor.white
    /** The text size for the text values. */
    @IBInspectable var textSize: CGFloat = 10
    /** The font to use for text values. */
    @IBInspectable var textFont: String = "Helvetica Light"
    
    /** How many seconds appear in the timeline at zoom 100%. */
    @IBInspectable var durationAtZoom100: CGFloat = 10
    /** How manu units appear in the timeline at zoom 100%. */
    @IBInspectable var unitRangeAtZoom100: CGFloat = 10
    
    
    // -- POSITIONING and SCALING
    /** Start position of graph in units. */
    private var _startUnitPosition: CGPoint
    /** Graph dimensions in units. */
    private var _scale: CGSize
    /** Transform matrix for unit to pixel space. */
    private var _unitToPixelTransform: CGAffineTransform
    /** Transform matrix from pixel to unit space. */
    private var _pixelToUnitTransform: CGAffineTransform
    
    
    // -- CHANGE FLAGS
    /** Flag indicating that start position has been changed. */
    internal var _positionChange: Bool = true
    /** Flag indicating that scale has been changed. */
    internal var _scaleChange: Bool = true
    /** Flag indicating that the playhead has moved. */
    internal var _playheadChange: Bool = true
    
    
    // -- DRAW AREAS
    /** Rect in pixels that represents the draw area for the horizontal meter.*/
    internal var _horizontalMeterRect: CGRect
    /** Rect in pixels that represents the draw area for the vertical meter. */
    internal var _verticalMeterRect: CGRect
    /** Rect in pixels that represents the draw area for the graph area. */
    internal var _graphRect: CGRect
    /** Rect in pixels that represents the draw area for the playhead. */
    internal var _playheadRect: CGRect
    
    
    // -- LAYERS
    internal var _playheadLayer: CGLayer?
    
    
    // -- DATA
    /** The tracking data to be graphed. */
    var trackingData: TrackingData?
    /** Flag for whether or not to draw the X position data. */
    var showPositionX: Bool = true
    /** Flag for whether or not to draw the Y position data. */
    var showPositionY: Bool = true
    /** Flag for whether or not to draw the Z position data. */
    var showPositionZ: Bool = true
    /** Flag for whether or not to draw the X rotation data. */
    var showRotationX: Bool = true
    /** Flag for whether or not to draw the Y rotation data. */
    var showRotationY: Bool = true
    /** Flag for whether or not to draw the Z rotation data. */
    var showRotationZ: Bool = true
    
    
    // -- LEVEL OF DETAIL THRESHOLDS
    /** Threshold in units from where we can start using simple line drawing. */
    internal var _dataLinearThresholdInUnits: CGFloat
    /** Threshold in units from whete we can start using cubic curve drawing. */
    internal var _dataCubicThresholdInUnits: CGFloat
    /** Interval in units for dtermining subdivisions for cubic drawing. */
    internal var _subdivisionIntervalInUnits: CGFloat
    
    
    // -- PLAYHEAD
    /** position of playhead in unit space. */
    private var _playheadUnitPosition: CGFloat
    /** position of playhead in unit space. */
    var playheadUnitPosition: CGFloat {
        get { return _playheadUnitPosition }
        set(value) {
            let previousUnitPosition = _playheadUnitPosition
            let previousPixelPosition = playheadPixelPosition
            _playheadUnitPosition = value
            // set if playhead has changed
            _playheadChange = previousUnitPosition != _playheadUnitPosition
            // call delegate if changed
            if _playheadChange {
                changeDelegate?.didPlayheadChange(
                    sender: self,
                    previousPixelLocation: previousPixelPosition,
                    previousUnitLocation: previousUnitPosition,
                    currentPixelLocation: playheadPixelPosition,
                    currentUnitLocation: _playheadUnitPosition
                )
            }
        }
    }
    /** Position of playhead in pixel space. */
    var playheadPixelPosition: CGFloat {
        get {
            return CGPoint(
                x: playheadUnitPosition,
                y: 0
            ).applying(unitToPixelTransform).x
        }
        set(value) {
            playheadUnitPosition = CGPoint(
                x: value,
                y: 0
            ).applying(pixelToUnitTransform).x
        }
    }
    
    
    // -- DELEGATES
    /** delegate for sending mouse events. */
    weak var mouseDelegate: TimelineViewMouseDelegate?
    /** delegate for sending timeline changes. */
    weak var changeDelegate: TimelineViewChangeDelegate?
    
    
    // -- MOUSE DATA
    /** Stores what part of the timeline the mouse has clicked on. */
    internal var _mouseTarget: MouseTarget = .None
    /** mouse position in pixels when the mouse down event occurs. */
    internal var _mouseDownPixelPos: CGPoint?
    /** mouse position in units when the mouse down event occurs. */
    internal var _mouseDownUnitPos: CGPoint?
    /** flag for determining of the mouse is currently dragging. */
    internal var _mouseIsDragging: Bool = false
    /** Tracking area for mouse enter/exit events. */
    internal var _trackingArea: NSTrackingArea?
    
    
    // -- TEXT
    /** Text Font for the text values. */
    internal var _font: NSFont?
    /** Text attributes for the text values. */
    internal var _textAttributes: [NSAttributedString.Key:Any]
    /** Number formatter for converting the float values to strings. */
    internal var _numberFormatter: NumberFormatter
    
    
    /**
     The start position of the bottom left corner of the graph visual
     area of the timeline, in unit space.
     */
    var startUnitPosition: CGPoint {
        get { return _startUnitPosition }
        set(value) {
            let previousUnitPositon = _startUnitPosition
            let previousPixelPosition = startPixelPosition
            _startUnitPosition = value
            // set if positioning has changed
            _positionChange = previousUnitPositon != _startUnitPosition
            // call delegate if changed
            if _positionChange {
                changeDelegate?.didPositionChange(
                    sender: self,
                    previousPixelPosition: previousPixelPosition,
                    previousUnitPosition: previousUnitPositon,
                    currentPixelPosition: startPixelPosition,
                    currentUnitPosition: _startUnitPosition
                )
            }
        }
    }
    
    /**
     The length of the visible timeline in unit space.
    */
    var unitLength: CGSize {
        get {
            return CGSize(
                width: scale.width * durationAtZoom100,
                height: scale.height * unitRangeAtZoom100
            )
        }
        set(value) {
            endUnitPosition = _startUnitPosition + value
        }
    }
    
    /**
     The end position of the top right corner of the graph visual area of the
     timeline, in unit space
    */
    var endUnitPosition: CGPoint {
        get {
            return CGPoint(
                x: _startUnitPosition.x + scale.width * durationAtZoom100,
                y: _startUnitPosition.y + scale.height * unitRangeAtZoom100
            )
        }
        set(value) {
            // make sure that the start position is not larger than given value
            // if it is, then adjust start position
            if value.x < _startUnitPosition.x {
                _startUnitPosition.x = value.x
            }
            if value.y < _startUnitPosition.y {
                _startUnitPosition.y = value.y
            }
            scale = CGSize(
                width: (value.x - _startUnitPosition.x) / durationAtZoom100,
                height: (value.y - _startUnitPosition.y) / unitRangeAtZoom100
            )
        }
    }
    
    /**
     The start position of the bottom left corner of the graph visual area of
     the timeline, in pixel space.
    */
    var startPixelPosition: CGPoint {
        get {
            return startUnitPosition.applying(_unitToPixelTransform)
        }
        set(value) {
            startUnitPosition = value.applying(_pixelToUnitTransform)
        }
    }
    
    /**
     The end position of the top right corner of the graph visual area of the
     timeline, in pixel space.
    */
    var endPixelPosition: CGPoint {
        get {
            return endUnitPosition.applying(_unitToPixelTransform)
        }
        set(value) {
            endUnitPosition = value.applying(_pixelToUnitTransform)
        }
    }
    
    /**
     The width and height dimensions of the graph visual area of the timeline,
     in unit space.
     */
    var scale: CGSize {
        get { return _scale }
        set(value) {
            let previousScale = _scale
            _scale = value
            // determine if there is a scale change
            _scaleChange = previousScale != _scale
            // call delegate if changed
            if _scaleChange {
                changeDelegate?.didScaleChange(
                    sender: self,
                    previousScale: previousScale,
                    currentScale: _scale)
            }
        }
    }
    
    /**
     The scale multiplier to scale from unit space to pixel space.
    */
    internal var scaleTransform: CGSize {
        get {
            return CGSize(
                width: _graphRect.width / (_scale.width * durationAtZoom100),
                height: _graphRect.height / (_scale.height * unitRangeAtZoom100)
            )
        }
    }
    
    /**
     Transform matrix to transform unit space to pixel space for the timeline
     graph.
    */
    var unitToPixelTransform: CGAffineTransform {
        get { return _unitToPixelTransform }
    }
    
    /**
     Transform matrix to transform pixel space to unit space for the timeline
     graph.
    */
    var pixelToUnitTransform: CGAffineTransform {
        get { return _pixelToUnitTransform }
    }
    
    /**
     Flag for whether or not the mouse is currently dragging from the
     timeline.
    */
    var mouseIsDragging: Bool { get {return _mouseIsDragging} }
    
    
    /**
     Constructor.
    */
    required init?(coder decoder: NSCoder) {
        _startUnitPosition = CGPoint(x: 0.0, y: -5.0)
        _scale = CGSize(width: 1, height: 1)
        _unitToPixelTransform = CGAffineTransform.identity
        _pixelToUnitTransform = CGAffineTransform.identity
        _horizontalMeterRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        _verticalMeterRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        _graphRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        _playheadRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        _dataLinearThresholdInUnits = 1.0
        _dataCubicThresholdInUnits = 2.0
        _subdivisionIntervalInUnits = 1.0
        _playheadUnitPosition = 0
        
        // initialize text data
        _font = NSFont(name: textFont, size: textSize)
        if let f = _font {
            _textAttributes = [
                .font: f,
                .foregroundColor: textColor
            ]
        }
        else {
            _textAttributes = [:]
        }
        _numberFormatter = NumberFormatter()
        _numberFormatter.allowsFloats = true
        _numberFormatter.maximumFractionDigits = 2
        _numberFormatter.minimumIntegerDigits = 1
        
        super.init(coder: decoder)
    }
    
    
    /**
     Updates the timeline graph transforms using the current start position and
     scale.
    */
    func updateTransform() {
        let s = scaleTransform
        _unitToPixelTransform = CGAffineTransform.identity
            // apply offset from meters
            .translatedBy(
                x: verticalMeterThickness,
                y: 0)
            // scale unit to pixel space
            .scaledBy(x: s.width, y: s.height)
            // translate by unit space
            .translatedBy(x: -startUnitPosition.x, y: -startUnitPosition.y)
        _pixelToUnitTransform = _unitToPixelTransform.inverted()
    }
    
    /**
     Transforms the given position in unit space to a position in pixel space.
     - Parameter fromUnitPosition: The position in units.
     - Returns: The transformed position in pixels.
    */
    func getPixelPosition(fromUnitPosition unitPosition: CGPoint) -> CGPoint {
        return unitPosition.applying(_unitToPixelTransform)
    }
    
    /**
     Transforms the given position in unit space to a position in pixel space.
     - Parameter fromUnitPositionX: The position in units along the x axis.
     - Returns: The transformed position in pixels along the x axis.
    */
    func getPixelPositionX(fromUnitPositionX unitPosition: CGFloat) -> CGFloat {
        return getPixelPosition(
            fromUnitPosition: CGPoint(
                x: unitPosition,
                y: 0
            )
        ).x
    }
    
    /**
     Transforms the given position in unit space to a position in pixel space.
     - Parameter fromUnitPositionX: The position in units along the y axis.
     - Returns: The transformed position in pixels along the y axis.
     */
    func getPixelPositionY(fromUnitPositionY unitPosition: CGFloat) -> CGFloat {
        return getPixelPosition(
            fromUnitPosition: CGPoint(
                x: 0,
                y: unitPosition
            )
            ).y
    }
    
    /**
     Transforms the given position in pixel space to a position in unit space.
     - Parameter fromPixelPosition: The position in pixels.
     - Returns: The transformed position in units.
    */
    func getUnitPosition(fromPixelPosition pixelPosition: CGPoint) -> CGPoint {
        return pixelPosition.applying(_pixelToUnitTransform)
    }
    
    /**
     Transforms the given position in pixel space to a position in unit space.
     - Parameter fromPixelPosition: The position in pixels along the axis.
     - Returns: The transformed position in units along the x axis.
     */
    func getUnitPositionX(fromPixelPositionX pixelPosition: CGFloat) -> CGFloat{
        return getUnitPosition(
            fromPixelPosition: CGPoint(
                x: pixelPosition,
                y: 0
            )
        ).x
    }
    
    /**
     Transforms the given position in pixel space to a position in unit space.
     - Parameter fromPixelPosition: The position in pixels along the y axis.
     - Returns: The transformed position in units along the y axis.
     */
    func getUnitPositionY(fromPixelPositionY pixelPosition: CGFloat) -> CGFloat{
        return getUnitPosition(
            fromPixelPosition: CGPoint(
                x: 0,
                y: pixelPosition
            )
        ).y
    }
    
    
    /**
     Returns a rect in unit space from the given rect in pixel space using the
     given transform.
     - Parameter fromPixelRect: The rect in pixel space to transform.
     - Parameter withTransform: The transform matrix to use to transform the
        given rect.
     - Returns: The transformed rect in unit space.
    */
    internal func buildUnitRect( fromPixelRect pixelRect: CGRect,
                                withTransform transform: CGAffineTransform
                                ) -> CGRect {
        // we will be adding a small buffer to the size of the rect to
        // counteract floating point precision error when drawing the last tick
        // or value text
        let adjustedRect = CGRect(
            origin: pixelRect.origin,
            size: CGSize(
                width: pixelRect.size.width + 5.0,
                height: pixelRect.size.height + 5.0
            )
        )
        return adjustedRect.applying(transform)
    }
}
