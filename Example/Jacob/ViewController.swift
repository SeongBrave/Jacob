//
//  ViewController.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import RxSwift
import UtilCore
import Alamofire
import ModelProtocol
import NetWorkCore

class ViewController: Base_Vc {
    
    /****************************Storyboard UI设置区域****************************/
    
    @IBOutlet weak var test_Btn: UIButton!
    
    /*----------------------------   自定义属性区域    ----------------------------*/
    
    
    /****************************Storyboard 绑定方法区域****************************/
    
    
    
    /**************************** 以下是方法区域 ****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    /**
     界面基础设置
     */
    override func setupUI() {
        
    }
    /**
     app 主题 设置
     */
    override func setViewTheme(){
        
    }
    /**
     绑定到viewmodel 设置
     */
    override func bindToViewModel(){
        
        self.test_Btn
            .rx.tap
            .map { _ in Api.products}
            .emeRequestApiForJson()
            .subscribe(onNext: {(result) in
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
    }
}


public enum Api{
    /// 获取文章列表
    case products
    
}
extension Api: TargetType {
    
    //商品数据
    public var path: String {
        switch self {
        case .products:
            return "/api/v1/products"
        }
    }
    
    //设置请求方式 get post等
    public var method: HTTPMethod {
        switch self {
        default :
            return .get
            
        }
    }
    /// 设置请求参数
    public var parameters: Parameters? {
        switch self {
        default :
            return nil
        }
    }
    
}
