//
//  CommentCell.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell,UICollectionViewDelegate {
    
    @IBOutlet weak var uname: UILabel!

    @IBOutlet weak var star: XStarView!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var pics: XCollectionView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var sub_name: UILabel!
    
    @IBOutlet weak var picH: NSLayoutConstraint!
    
    @IBOutlet weak var user_icon: UIImageView!
    
    @IBOutlet weak var reply: UILabel!
    
    @IBOutlet weak var replybtn: UIButton!
    
    @IBOutlet weak var replyTop: NSLayoutConstraint!
    
    @IBAction func do_reply(_ sender: Any) {
        
        let vc = "CommentReplyVC".VC(name: "Main") as! CommentReplyVC
        vc.model = model
        
        vc.onSuccess {[weak self] in
            
            if let sv = self?.viewController as? CommentListVC
            {
                if let indexPath = sv.table.indexPath(for: self!)
                {
                    sv.table.cellHDict.removeValue(forKey: indexPath)
                }
                
                sv.table.reloadData()
            }
            
        }
        
        self.viewController?.show(vc, sender: nil)
        
    }
    
    
    var imgs:[Int:UIImageView] = [:]
    
    var model:CommentModel = CommentModel()
    {
        didSet
        {
            uname.text = model.user_name
            star.num = model.point.numberValue.intValue
            time.text = model.create_time
            content.text = model.content
            user_icon.kf.setImage(with: model.avatar.url())
            icon.kf.setImage(with: model.icon.url())
            name.text = model.sub_name
            sub_name.text = model.sub_name
            
            if model.reply_time == ""
            {
                replyTop.constant = 0
                reply.text = ""
            }
            else
            {
                replyTop.constant = 10
                reply.text = "[掌柜回复]：\(model.reply_content)"
            }
            
            
            if model.images.count == 0{
                picH.constant = 0.0
                pics.httpHandle.listArr.removeAll(keepingCapacity: false)
            }
            else
            {
                picH.constant = 90.0
                pics.httpHandle.listArr = model.images as [AnyObject]
            }
            
            pics.reloadData()
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pics.ViewLayout.sectionInset.bottom = 16.0
        pics.ViewLayout.scrollDirection = .horizontal
        pics.ViewLayout.itemSize = CGSize(width: 80.0, height: 80.0)
        pics.ViewLayout.minimumLineSpacing = 8.0
        pics.ViewLayout.minimumInteritemSpacing = 8.0
        pics.CellIdentifier = "CommentPicCell"
        
        pics.Delegate(self)
        
        pics.onGetCell { [weak self](indexPath, cell) in
            
            if let c = cell as? CommentPicCell
            {
                self?.imgs[indexPath.row] = c.img
            }
            
        }
        
        user_icon.layer.masksToBounds = true
        replybtn.layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        user_icon.layer.cornerRadius = user_icon.frame.size.width * 0.5
        replybtn.layer.cornerRadius = replybtn.frame.size.height * 0.5
        reply.preferredMaxLayoutWidth = reply.frame.size.width
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! CommentPicCell
        
        var arr:[UIImageView] = []
        
        for i in 0..<imgs.count
        {
            arr.append(imgs[i]!)
        }
        
        XImageBrowse(arr: arr).show(cell.img)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
