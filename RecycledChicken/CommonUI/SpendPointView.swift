//
//  SpendPointView.swift
//  RecycledChicken
//
//  Created by 林書郁 on 2023/5/11.
//

import UIKit

protocol SpendPointViewDelegate{
    func btnAction(_ sender:UIButton)
}

class SpendPointView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var confirm:UIButton!
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var itemAmount:UILabel!
    
    @IBOutlet weak var needPoint:UILabel!
    
    var delegate:SpendPointViewDelegate?
    
    var lotteryInfos:[LotteryInfo] = []
    {
        willSet{
            tableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit(){
        loadNibContent()
        tableView.setSeparatorLocation()
        tableView.register(UINib(nibName: "LotteryItemTableViewCell", bundle: nil), forCellReuseIdentifier: "LotteryItemTableViewCell")
    }
    
    @IBAction func plusBtn(_ sender:UIButton){
        
    }
    
    @IBAction func minusBtn(_ sender:UIButton){
        
    }
    
    func setConfirmBtnTitle(_ title:String){
        confirm.setTitle(title, for: .normal)
    }
    
    @IBAction func btnAction(_sender:UIButton) {
        delegate?.btnAction(_sender)
    }

}

extension SpendPointView:UITableViewDelegate {
    
}


extension SpendPointView:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lotteryInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotteryItemTableViewCell", for: indexPath) as! LotteryItemTableViewCell
        cell.setCell(lotteryInfo: lotteryInfos[indexPath.row])
        return cell
    }
    
    
}
