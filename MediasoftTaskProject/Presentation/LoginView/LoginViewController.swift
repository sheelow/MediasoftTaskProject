//
//  LoginViewController.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit
import SnapKit
import WebKit

//MARK: - LoginViewController
final class LoginViewController: UIViewController {

    //MARK: - Properties
    private var token:Token?

    private var networkService: NetworkServiceProtocol

    private lazy var webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        return webView
    }()

    //MARK: - Init
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureURL()
        configureLoginView()
    }

    //MARK: - Methods
    private func configureURL() {

        guard let url = URL(string: "https://unsplash.com/oauth/authorize?client_id=\(AppConstants.clientID)&redirect_uri=\(AppConstants.redirectURL)&response_type=code&scope=public") else { return }

        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }

    private func configureLoginView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - WKNavigationDelegate
extension LoginViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let absoluteURL = webView.url?.absoluteString.components(separatedBy: "?"),
              absoluteURL[0] == AppConstants.redirectURL else {
            return
        }
        let keyAndCode = absoluteURL[1].components(separatedBy: "=")
        let code = keyAndCode[1]

        self.networkService.getTocken(code: code) { [weak self] data in
            self?.token = data
            let mainTabBarController = MainTabBarController()
            mainTabBarController.modalPresentationStyle = .fullScreen
            self?.present(mainTabBarController, animated: true)
        }
    }
}
