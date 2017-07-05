//
//  WebViewController.swift
//  LoveFreshBeen


import UIKit

// MARK: - WebViewController
class WebViewController: UIViewController {
    // MARK: - 属性
    fileprivate var webView = UIWebView(frame: .zero)
    fileprivate var urlStr: String?
    fileprivate let loadProgressAnimationView: LoadProgressAnimationView = LoadProgressAnimationView(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: 3))
    
    // MARK: - 生命周期
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.addSubview(webView)
        webView.addSubview(loadProgressAnimationView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(navigationTitle: String, urlStr: String) {
        self.init(nibName: nil, bundle: nil)
        navigationItem.title = navigationTitle
        webView.loadRequest(URLRequest(url: URL(string: urlStr)!))
        self.urlStr = urlStr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = MGScreenBounds
        automaticallyAdjustsScrollViewInsets = true
        view.backgroundColor = UIColor.white
        webView.frame = CGRect(x: 0, y: MGNavHeight, width: MGScreenW, height: view.mg_height)
        buildRightItemBarButton()
        
        view.backgroundColor = UIColor.colorWithCustom(r: 230, g: 230, b: 230)
        webView.backgroundColor = UIColor.colorWithCustom(r: 230, g: 230, b: 230)
        webView.delegate = self
        webView.scrollView.contentInset = UIEdgeInsets(top: -MGNavHeight, left: 0, bottom: MGNavHeight, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - 导航栏
    private func buildRightItemBarButton() {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        rightButton.setImage(UIImage(named: "restart"), for: UIControlState.normal)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -53)
        rightButton.addTarget(self, action: #selector(WebViewController.refreshClick), for: UIControlEvents.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    // MARK: - Action
    func refreshClick() {
        if urlStr != nil && urlStr!.characters.count > 1 {
            webView.loadRequest(URLRequest(url: URL(string: urlStr!)!))
        }
    }
}

// MARK: - UIWebViewDelegate
extension WebViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadProgressAnimationView.startLoadProgressAnimation()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadProgressAnimationView.endLoadProgressAnimation()
    }
}


// MARK: - 
// MARK: - LoadProgressAnimationView
class LoadProgressAnimationView: UIView {
    
    var viewWidth: CGFloat = 0
    override var frame: CGRect {
        willSet {
            if frame.size.width == viewWidth {
                self.isHidden = true
            }
            super.frame = frame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.size.width
        backgroundColor = UIColor.randomColor()
        self.frame.size.width = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("LoadProgressAnimationView-deinit")
    }
    
    // MARK: - 加载进度动画
    func startLoadProgressAnimation() {
        self.frame.size.width = 0
        isHidden = false
        UIView.animate(withDuration: 0.8, animations: { () -> Void in
            self.frame.size.width = self.viewWidth * 0.70
            
        }) { (finish) -> Void in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08, execute: {
                UIView.animate(withDuration: 0.3, animations: {
                    self.frame.size.width = self.viewWidth * 0.85
                })
            })
        }
    }
    
    func endLoadProgressAnimation() {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.frame.size.width = self.viewWidth*0.99
        }) { (finish) -> Void in
            self.isHidden = true
        }
    }
}
