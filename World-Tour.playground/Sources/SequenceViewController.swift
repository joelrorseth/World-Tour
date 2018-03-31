import UIKit

class SequenceViewController: UIViewController {
    
    let tour: Tour!
    let textView: UITextView!
    
    init(frame: CGRect, tour: Tour, generation: Int) {
        
        self.tour = tour
        
        textView = UITextView(frame: frame)
        textView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4)
        textView.text = "\(tour)"
        textView.isEditable = false
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.isScrollEnabled = true
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Generation \(generation)"
        self.view = UIView(frame: frame)
        self.view.backgroundColor = .white
        
        view.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
