//
//  StudentManagerVC.swift
//  BaseProject
//
//  Created by Michael Seven on 3/28/20.
//  Copyright © 2020 Michael Seven. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

let realm = try! Realm()

class StudentManagerVC: UIViewController, UITextViewDelegate {

    let disposeBag = DisposeBag()
    var countId: Int = 0
    var countAge: Int = 0
    
    let headerView = UIStackView()
    let textView = UITextView()
    let addBtn = UIButton()
    let tableView = UITableView()
    let students = Variable<[StudentModel]>([])
    var checkStudent = StudentModel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initData()
        subscribeEvents()
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkStudent = realm.objects(StudentModel.self).first ?? StudentModel()
        students.value = realm.objects(StudentModel.self).compactMap { $0 as? StudentModel}
        print("student list: \(students.value)")
    }
    
    
    func initComponents() {
        let contentView = UIView()
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.left.right.bottom.equalToSuperview()
        }
        contentView.backgroundColor = .gray
        
        let stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(headerView)
        headerView.axis = .horizontal
        headerView.addArrangedSubview(textView)
        headerView.addArrangedSubview(addBtn)
        headerView.alignment = .fill
        headerView.distribution = .fillEqually
        addBtn.setTitle("Add new student", for: .normal)
        
        stackView.addArrangedSubview(tableView)
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseIdentifier)
    }
    
    func initData() {
        
    }
    
    func subscribeEvents() {
        students.asDriver().drive(self.tableView.rx.items(cellIdentifier: StudentCell.reuseIdentifier, cellType: StudentCell.self)) {item, viewModel, cell in
            cell.bindingData(student: viewModel)
        }.disposed(by: disposeBag)
        
        addBtn.rx.tap.asDriver().throttle(3)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.checkReferrence()
                self.textView.resignFirstResponder()
                self.countAge += 1
                self.countId += 1
                let newStudent = StudentModel()
                newStudent.name = self.textView.text
                newStudent.age = self.countAge + 1
                newStudent.id = self.countId + 1
                print("new student: name = \(newStudent.name), id = \(newStudent.id)")
                
                try! realm.write {
                    realm.add(newStudent)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func checkReferrence() {
        try! realm.write {
            checkStudent.name = checkStudent.name + "update"
        }
        students.value = realm.objects(StudentModel.self).compactMap { $0 as? StudentModel}
    }
}
