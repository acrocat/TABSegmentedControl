//
//  TABSegmentedControl.swift
//  TABSegmentedControl
//
//  Created by Dale Webster on 09/12/2016.
//  Copyright © 2016 TabApps. All rights reserved.
//

import UIKit

@objc public protocol TABSegmentControlDelegate
{
    func segmentedControl (_ segmentedControl : TABSegmentedControl , didSelectSegmentAtIndex index : Int)
}

open class TABSegmentedControl : UIScrollView
{
    // ---------------------------------------------------------------------------
    // MARK: - Properties
    // ---------------------------------------------------------------------------

    private static let DEFAULT_SEGMENT_WIDTH_PROPORTION : CGFloat = 0.4
    private static let DEFAULT_TINT_COLOR : UIColor = .blue
    
    private var _controlDelegate : TABSegmentControlDelegate?
    private var _segmentTitles : Array<String> = []
    private var _index : Int = 0
    private var _font : UIFont = UIButton().titleLabel!.font
    
    // ---------------------------------------------------------------------------
    // MARK: - Getters / Setters
    // ---------------------------------------------------------------------------
    
    open var controlDelegate : TABSegmentControlDelegate? {
        get { return self._controlDelegate }
        set { self._controlDelegate = newValue }
    }
    
    public var segmentTitles : Array<String> {
        get { return self._segmentTitles }
        set { self._segmentTitles = newValue ; self.reloadSegments() }
    }
    
    public var index : Int {
        get { return self._index }
        set {
            self._index = newValue
            self.updateIndicator(animated: true , completion: {
                self.updatePositionForCurrentIndex(animated: true)
            })
        }
    }
    
    open override var tintColor : UIColor? {
        get { return super.tintColor }
        set { super.tintColor = newValue ; self.reloadSegments() }
    }
    
    public var font : UIFont {
        get {
            return self._font
        }
        set {
            self._font = newValue
            
            for seg in self.segments
            {
                seg.titleLabel?.font = font
            }
        }
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - UI Components
    // ---------------------------------------------------------------------------
    
    private var segments : Array<UIButton> = []
    private let indicator : UIView = UIView()
    
    // ---------------------------------------------------------------------------
    // MARK: - Init
    // ---------------------------------------------------------------------------
    
    /**
     Init with segment titles
     */
    convenience init (withSegmentTitles titles : Array<String>)
    {
        self.init()
        
        self.segmentTitles = titles
        self.setup()
    }
    
    override open func layoutSubviews ()
    {
        super.layoutSubviews()
        
        // Set the frames for the segments
        let segmentWidth : CGFloat = self.frame.width * TABSegmentedControl.DEFAULT_SEGMENT_WIDTH_PROPORTION
        
        for (index , segment) in self.segments.enumerated()
        {
            let segmentLeft : CGFloat = segmentWidth * CGFloat(index)
            
            segment.frame = CGRect(x: segmentLeft, y: 0, width: segmentWidth, height: self.frame.height)
        }
        
        // Set the contentSize
        self.contentSize = CGSize(width: segmentWidth * CGFloat(self.segments.count), height: self.frame.height)
        
        // Set indicator frame
        self.updateIndicator(animated: false , completion: nil)
    }

    /**
     Config properties
     */
    private func setup ()
    {
        // Set scrollView properties
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        // Default tint color
        self.tintColor = TABSegmentedControl.DEFAULT_TINT_COLOR
    }
    
    /**
     Move the indicator to the current index
     */
    private func updateIndicator (animated : Bool , completion : (() -> Void)?)
    {
        let duration = (animated) ? 0.3 : 0
        let segmentWidth : CGFloat = self.frame.width * TABSegmentedControl.DEFAULT_SEGMENT_WIDTH_PROPORTION
        
        UIView.animate(withDuration: duration, animations: {
            self.indicator.frame = CGRect(x: segmentWidth * CGFloat(self.index), y: self.frame.height - 3, width: segmentWidth, height: 3)
        } , completion: {completed in
            completion?()
        })
    }
    
    /**
     Scroll the scrollView so that the current index segment is in view
     */
    private func updatePositionForCurrentIndex (animated : Bool)
    {
        let segmentWidth : CGFloat = self.frame.width * TABSegmentedControl.DEFAULT_SEGMENT_WIDTH_PROPORTION
        let rect : CGRect = CGRect(x: segmentWidth * CGFloat(self.index), y: 0, width: segmentWidth, height: self.frame.height)
        
        self.scrollRectToVisible(rect, animated: animated)
    }
    
    /**
     Re-add the segments to the superview if they have been updated
     */
    public func reloadSegments ()
    {
        // Remove all subview from the supervew
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
        
        // Clear the segments
        self.segments = []
        
        // Add buttons for each of the segment titles
        for (index , title) in self.segmentTitles.enumerated()
        {
            let btn : UIButton = UIButton()
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(self.tintColor, for: .normal)
            btn.titleLabel?.font = self.font
            btn.addTarget(self, action: #selector(segmentTapped(segment:)), for: .touchUpInside)
            btn.tag = index
            
            self.addSubview(btn)
            self.segments.append(btn)
        }
        
        // Add indicator
        self.addSubview(self.indicator)
        self.indicator.backgroundColor = self.tintColor
        
        // Reset the index
        self.index = 0
        
        self.layoutSubviews()
    }
    
    // ---------------------------------------------------------------------------
    // MARK: - Segment Events
    // ---------------------------------------------------------------------------
    
    @objc func segmentTapped (segment : UIButton)
    {
        self.index = segment.tag
        
        self.controlDelegate?.segmentedControl(self, didSelectSegmentAtIndex: segment.tag)
    }
    
    // ---------------------------------------------------------------------------
    // ---------------------------------------------------------------------------
}
