//
//  CommentReplyVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/6/16.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class CommentReplyVC: UIViewController {

    var block:XNoBlock?
    
    func onSuccess(b:@escaping XNoBlock)
    {
        self.block = b
    }
    
    var model:CommentModel = CommentModel()
    
    @IBOutlet weak var content: XTextView!
    
    @IBAction func do_submit(_ sender: Any) {
        
        self.view.endEdit()
        XWaitingView.show()
        
        let sid = DataCache.Share.User.sid
        let aid = DataCache.Share.User.id
        let data_id = model.id
        let cstr = content.text!.trim()
        
        if !content.checkNull()
        {
            XMessage.show("请输入回复内容")
            return
        }
        
        Api.dp_submit(sid: sid, aid: aid, data_id: data_id, reply_content: cstr) {[weak self] (res) in
            
            if res
            {
                self?.model.reply_content = cstr
                self?.model.reply_time = "1111"
                self?.block?()
                
                XAlertView.show("回复提交成功", block: { [weak self] in
                    self?.pop()
                })
                
                
            }
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton()
        
        content.placeHolder("请输入回复")
        content.text = model.reply_content
        content.placeHolderView?.isHidden = model.reply_content != ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
