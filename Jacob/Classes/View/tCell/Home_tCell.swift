//
//  Home_tCell.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import UIKit
import UtilCore

class  Home_tCell: UITableViewCell {
    
    @IBOutlet weak var pdname_Lb: UILabel!
    @IBOutlet weak var desc_Lb: UILabel!
    @IBOutlet weak var attr_Lb: UILabel!
    @IBOutlet weak var imageurl_ImgV: UIImageView!
    
    var item:Home_model?{
        didSet{
            self.attr_Lb.text = item?.attr
            self.pdname_Lb.text = item?.pdname
            self.desc_Lb.text = item?.desc
            self.imageurl_ImgV.setUrlImage(item?.imageurl ?? "")
            
        }
        
    }

    override func awakeFromNib() {
        
    }
}
