//
//  LoginViewController.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    //MARK: - Properties
    var model: LoginViewModelProtocol?
    
    private lazy var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Hello! Please login"
        welcomeLabel.textColor = .black
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = .systemFont(ofSize: 26)
        return welcomeLabel
    }()
    
    private lazy var wrongLabel: UILabel = {
        let wrongLabel = UILabel()
        wrongLabel.text = "Invalid login or password"
        wrongLabel.textColor = .clear
        return wrongLabel
    }()

    private lazy var loginTextField: UITextField = {
        let loginTextField = UITextField()
        loginTextField.placeholder = "Your login"
        loginTextField.borderStyle = .roundedRect
        return loginTextField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Your password"
        passwordTextField.borderStyle = .roundedRect
        return passwordTextField
    }()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .system)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 10
        loginButton.setTitle("Login", for: .normal)
        loginButton.tintColor = UIColor.systemGray5
        loginButton.titleLabel?.font = .systemFont(ofSize: 20)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return loginButton
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 241/255, green: 238/255, blue: 228/255, alpha: 1)
        configureView()
    }
    
    //MARK: - Methods
    private func configureView() {
        configureWelcomeLabel()
        configureLoginTextField()
        configurePasswordTextField()
        configureWrongLabel()
        configureLoginButton()
    }
    
    private func configureWelcomeLabel() {
        view.addSubview(welcomeLabel)
        
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(200)
        }
    }
    
    private func configureLoginTextField() {
        view.addSubview(loginTextField)
        
        loginTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(60)
            make.width.equalTo(300)
        }
    }
    
    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginTextField.snp.bottom).offset(30)
            make.width.equalTo(300)
        }
    }
    
    private func configureWrongLabel() {
        view.addSubview(wrongLabel)
        
        wrongLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
        }
    }
    
    private func configureLoginButton() {
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(80)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    @objc
    private func loginButtonTapped() {
        wrongLabel.textColor = .red
//        let vc = MainTabBarController()
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
    }
}
