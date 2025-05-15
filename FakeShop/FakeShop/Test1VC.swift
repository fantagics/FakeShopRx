//
//  Test1VC.swift
//  FakeShop
//
//  Created by 이태형 on 2024/12/02.
//

import UIKit

class Test1VC: UIViewController {
    
    var vm: TestVM = TestVM()
    private let btn1: UIButton = UIButton()
    private let lb1: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewConfig()
    }
    
}

#Preview("Test1VC"){
    return Test1VC()
}

//MARK: - Function
extension Test1VC{
    @objc func didTapButton(_ sender: UIButton){
//        let nextvc = Test2VC()
//        self.navigationController?.pushViewController(nextvc, animated: true)
        vm.addCount()
//        lb1.text = "\(vm.count)"
        lb1.text = "test: %@ , %@".localized(a: "ABC", b: "abc")
    }
}

//MARK: - SETUP
extension Test1VC{
    private func setViewConfig(){
        setAttribute()
        setUI()
    }
    
    private func setAttribute(){
        self.navigationItem.title = "AAAA"
        view.backgroundColor = UIColor.brown
        
        [btn1].forEach{
            $0.setTitle("Next", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.setTitleColor(.blue, for: .normal)
            $0.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        }
        
        [lb1].forEach{
            $0.font = .boldSystemFont(ofSize: 30)
            $0.textColor = .green
            $0.text = "\(vm.count)"
        }
    }
    
    private func setUI(){
        [btn1, lb1].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            btn1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btn1.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lb1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lb1.bottomAnchor.constraint(equalTo: btn1.topAnchor, constant: -16)
        ])
    }
}

class TestVM{
    var count: Int = 0
    
    func addCount(){
        self.count += 1
    }
}
