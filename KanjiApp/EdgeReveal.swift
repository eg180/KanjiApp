import Foundation
import UIKit
import SpriteKit

public enum EdgeRevealType {
    case Left
    case Right
}

public enum AnimationState {
    case Closed
    case Opening
    case Open
    case Closing
    case DraggingOpen
    case DraggingClosed
    
    public func IsOpenOrClosed() -> Bool {
        switch self {
        case Open:
            return true
        case Closed:
            return true
        default:
            return false
        }
    }
    
    public func IsAnimating() -> Bool {
        switch self {
        case Opening:
            return true
        case Closing:
            return true
        default:
            return false
        }
    }
    
    public func IsDragging() -> Bool {
        switch self {
        case DraggingOpen:
            return true
        case DraggingClosed:
            return true
        default:
            return false
        }
    }
    
    public func AnyOpen() -> Bool {
        switch self {
        case Open:
            return true
        case Opening:
            return true
        case DraggingOpen:
            return true
        default:
            return false
        }
    }
    
    public static func GetFinished(isOpen: Bool) -> AnimationState {
        if isOpen {
            return AnimationState.Open
        } else {
            return AnimationState.Closed
        }
    }
    
    public static func GetAnimating(isOpen: Bool) -> AnimationState {
        if isOpen {
            return AnimationState.Opening
        } else {
            return AnimationState.Closing
        }
    }
    
    public static func GetDrag(isDraggingOpen: Bool) -> AnimationState {
        if isDraggingOpen {
            return AnimationState.DraggingOpen
        } else {
            return AnimationState.DraggingClosed
        }
    }
}

public class EdgeReveal: UIButton {
    
    let revealType: EdgeRevealType
    let maxReveal: CGFloat
    let animationTime: Double
    let animationEasing = UIViewAnimationOptions.CurveEaseOut
    let transitionThreshold: CGFloat
    let maxYTravel: CGFloat
    var swipeAreaWidth: CGFloat
//    var swipeArea: UIButton!
    var maxRevealInteractInset: CGFloat = 0
    
    var onUpdate: ((offset: CGFloat) -> ())?
    var setVisible: ((open: Bool, completed: Bool) -> ())?
    var onAnimationCompleted: ((open: Bool) -> ())?
    var onTap: ((open: Bool) -> ())?
    var onOpenClose: ((shouldOpen: Bool) -> ())?
    
    var animationState: AnimationState = AnimationState.Closed
    
    var allowOpen: Bool = true
    
    public init(
        parent: UIView,
        revealType: EdgeRevealType,
        maxOffset: CGFloat = 202,
        autoAddToParent: Bool = true,
        swipeAreaWidth: CGFloat = 13,
        transitionThreshold: CGFloat = 30,
        maxYTravel: CGFloat = CGFloat.max,
        autoHandlePanEvent: Bool = true,
        animationTime: Double = 0.17,
        onUpdate: ((offset: CGFloat) -> ())?,
        setVisible: ((visible: Bool, completed: Bool) -> ())?) {
            
        self.revealType = revealType
        self.maxReveal = maxOffset
        self.maxYTravel = maxYTravel
        self.onUpdate = onUpdate
        self.setVisible = setVisible
        self.swipeAreaWidth = swipeAreaWidth
        self.transitionThreshold = transitionThreshold
        self.animationTime = animationTime
            
        super.init(frame: getSwipeAreaFrame(false))
            
//        swipeArea = UIButton(frame: )
        
//        backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2)
            
        if autoAddToParent {
            parent.addSubview(self)
//            parent.bringSubviewToFront(swipeArea)
        }
        
        if autoHandlePanEvent {
            var gesture = UIPanGestureRecognizer(target: self, action: "respondToPanGesture:")
            addGestureRecognizer(gesture)
        }
        
        var tap = UITapGestureRecognizer(target: self, action: "respondToTap:")
        addGestureRecognizer(tap)
            
        if let setVisible = setVisible {
            setVisible(visible: false, completed: false)
        }
    }
    
    private func getSwipeAreaFrame(isOpen: Bool) -> CGRect {
        switch revealType {
        case .Left:
            if isOpen {
                return CGRectMake(maxReveal - maxRevealInteractInset, 0, Globals.screenSize.width - maxReveal + maxRevealInteractInset, Globals.screenSize.height)
            } else { 
                return CGRectMake(0, 0, swipeAreaWidth, Globals.screenSize.height)
            }
        case .Right:
            if isOpen {
                return CGRectMake(0, 0, Globals.screenSize.width - self.maxReveal + maxRevealInteractInset, Globals.screenSize.height)
            } else {
                return CGRectMake(Globals.screenSize.width - swipeAreaWidth, 0, swipeAreaWidth, Globals.screenSize.height)
            }
        }
    }
    
    public required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    private func setVisibility(value: Bool, completed: Bool) {
        if let setVisible = self.setVisible {
            setVisible(open: value, completed: completed)
        }
    }
    
    public func animateSelf(var isOpen: Bool) {
        if animationState.IsAnimating() {
            return
        }
        if animationState.IsOpenOrClosed() && animationState.AnyOpen() == isOpen {
            return
        }
        
        if let onOpenClose = onOpenClose {
            onOpenClose(shouldOpen: isOpen)
        }
        
        if !allowOpen {
            isOpen = false
        }
        
        let lastAnimationState = animationState
        animationState = AnimationState.GetAnimating(isOpen)
        
        let viewVisibleWidth = Globals.screenSize.width - self.maxReveal
        
        if isOpen {
            if lastAnimationState == .Closed {
                setVisibility(true, completed: false)
            }
            
            UIView.animateWithDuration(animationTime,
                delay: 0,
                options: animationEasing,
                {
                    self.frame = self.getSwipeAreaFrame(true)
                    if let onUpdate = self.onUpdate {
                        onUpdate(offset: self.maxReveal)
                    }
                },
                completion: { (_) -> () in
                    self.animationState = .Open
                    if let callback = self.onAnimationCompleted {
                        callback(open: true)
                    }
            })
        } else {
            if lastAnimationState == .Open {
                self.frame = self.getSwipeAreaFrame(true)
                if let onUpdate = self.onUpdate {
                    onUpdate(offset: self.maxReveal)
                }
            }
            
            UIView.animateWithDuration(animationTime,
                delay: 0,
                options: animationEasing,
                {
                    self.frame = self.getSwipeAreaFrame(false)
                    if let onUpdate = self.onUpdate {
                        onUpdate(offset: 0)
                    }
                },
                completion: { (_) -> () in
                    self.setVisibility(false, completed: true)
                    self.animationState = .Closed
                    if let callback = self.onAnimationCompleted {
                        callback(open: false)
                    }
            })
        }
    }
    
    func respondToTap(gesture: UITapGestureRecognizer) {
        if animationState.IsAnimating() {
            return
        }
        
        if let onTap = self.onTap {
            onTap(open: animationState.AnyOpen())
        }
        
        animateSelf(false)
    }
    
    func respondToPanGesture(gesture: UIPanGestureRecognizer) {
        if animationState.IsAnimating() {
            return
        }
        
        var xSign: CGFloat = 1
        if revealType == .Right {
            xSign = -1
        }
        
        switch gesture.state {
        case .Began:
            if animationState == .Closed {
                animationState = .DraggingOpen
                setVisibility(true, completed: false)
            } else {
                animationState = .DraggingClosed
            }
        default:
            break
        }
        
        var xOffset = gesture.translationInView(superview).x * xSign
        
        if !animationState.AnyOpen() {
            xOffset += maxReveal
        }
        xOffset = max(0, xOffset)
        xOffset = min(xOffset, maxReveal)
        
        if let onUpdate = onUpdate {
            onUpdate(offset: xOffset)
        }
        
        var x = xOffset
        
        if revealType == .Right {
            x = Globals.screenSize.width - x
        
            frame.origin.x = x - frame.width
        } else {
            frame.origin.x = x
        }
        
        switch gesture.state {
        case .Ended:
            let translation = gesture.translationInView(superview)
            var xDelta = translation.x
            
            if revealType == EdgeRevealType.Right {
                xDelta = -xDelta
            }
            
//            if immediatelyClose {
//                
//                
//                
//                animateSelf(false)
//            }
//            else {
            if abs(translation.y) < maxYTravel {
                if xDelta > transitionThreshold {
                    animateSelf(true)
                } else if xDelta < transitionThreshold {
                    animateSelf(false)
                } else {
                    animateSelf(!animationState.AnyOpen())
                }
            }
            else {
                animateSelf(!animationState.AnyOpen())
            }
//            }
        default:
            break
        }
    }
    
    /// Note that this method does not save the context
    func editCardProperties(card: Card?, value: CardPropertiesEdit) {
        if let card = card {
            switch value {
            case .Add:
                card.suspended = false
                card.known = false
            case .Remove:
                card.suspended = true
            case .Known:
                card.suspended = false
                card.known = true
            }
        }
        
        animateSelf(false)
    }
    
    public func toggleOpenClose() {
        if animationState.IsOpenOrClosed() {
            animateSelf(!animationState.AnyOpen())
        }
    }
}