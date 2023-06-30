//
//  ViewController.swift
//  Assignment
//
//  Created by Sudeep Sharma on 29/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var facilityNameLbl: [UILabel]!
    @IBOutlet var facilityOptionsCV: [UICollectionView]!
    @IBOutlet weak var subOptionsSV: UIStackView!
    @IBOutlet var loader:UIActivityIndicatorView!
    @IBOutlet var finalSelectionView:UIView!
    @IBOutlet var finalSelectionLbl:UILabel!
    
    var viewModel :ViewModel?
    var screenData:BaseModel!
    var primarySelectedFacilityId, secondarySelectedFacilityId, thirdSelectedFacilityId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getData()
    }
    
    func getData() {
        loader.startAnimating()
        viewModel = ViewModel()
        viewModel?.dataSendToController = { [unowned self] responseType in
            DispatchQueue.main.async { [unowned self] in
                loader.stopAnimating()
                loader.isHidden = true
                if responseType == .success{
                    screenData = viewModel?.screenData
                    updateUI()
                }else{
                    //Handle error case
                    debugPrint("Data not found")
                }
            }
        }
    }
    
    func updateUI() {
        self.facilityNameLbl.first?.text = screenData.facilities?.first?.name
        self.facilityOptionsCV.first?.dataSource = self
        self.facilityOptionsCV.first?.reloadData()
        
        self.facilityNameLbl[1].text = screenData.facilities?[1].name
        self.facilityOptionsCV[1].dataSource = self
        self.facilityOptionsCV[1].reloadData()
        
        self.facilityNameLbl[2].text = screenData.facilities?[2].name
        self.facilityOptionsCV[2].dataSource = self
        self.facilityOptionsCV[2].reloadData()
    }
    
    func reloadData(){
        self.facilityOptionsCV.first?.reloadData()
        self.facilityOptionsCV[1].reloadData()
        self.facilityOptionsCV[2].reloadData()
    }
    
    @IBAction func facilityOptionBtn(_ sender:UIButton){
        switch sender.tag{
        case 100:
            primarySelectedFacilityId = screenData.facilities?[0].facility_id
        case 200:
            secondarySelectedFacilityId = screenData.facilities?[1].facility_id
        case 300:
            thirdSelectedFacilityId = screenData.facilities?[2].facility_id
        default:break
        }
        if var options = screenData.facilities?[sender.tag/100-1].options {
            for index in 0..<options.count{
                var option = options[index]
                option.isSelected = option.name == sender.title(for: .normal)
                options[index] = option
            }
            screenData.facilities?[sender.tag/100-1].options = options
            switch sender.tag {
            case 100:
                subOptionsSV.isHidden = false
            case 300:
                finalSelectionView.isHidden = false
                setFinalSelection()
            default:break
            }
            reloadData()
        }
    }
    
    func disableFacilitiesAsPerSelectedFacility()  {
        if let primaryId = primarySelectedFacilityId, let primaryOption = screenData.facilities?.filter({ facility in
            return facility.facility_id == primaryId
        }).first?.options?.filter({ option in
            return option.isSelected
        }).first{
            let exclusions = screenData.exclusions?[0].filter({ exclusion in
                return exclusion.facility_id == primaryId && exclusion.options_id == primaryOption.id
            })
            if let needToExcludeOptions = exclusions?.filter({ exclusion in
                return exclusion.facility_id != primaryId
            }){
                for excludeOption in needToExcludeOptions{
                    if var facility = screenData.facilities?.filter({ facility in
                        return facility.facility_id == excludeOption.facility_id
                    }).first{
                        if var options = facility.options?.filter({ option in
                            return option.id == excludeOption.options_id
                        }){
                            options[0].disable = true
                            facility.options = options
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func resetOption(){
        resetAllFacilitiesOptions()
        subOptionsSV.isHidden = true
        finalSelectionView.isHidden = true
        reloadData()
    }
    
    func setFinalSelection(){
        var finalSelectedItems = ""
        if let primarySelectionOption = screenData.facilities?.filter({ facility in
            return facility.facility_id == primarySelectedFacilityId
        }).first?.options?.filter({ option in
            return option.isSelected
        }).first{
            finalSelectedItems.append("\(primarySelectionOption.name ?? "")")
        }
        if let secondarySelectionOption = screenData.facilities?.filter({ facility in
            return facility.facility_id == secondarySelectedFacilityId
        }).first?.options?.filter({ option in
            return option.isSelected
        }).first{
            finalSelectedItems.append(", \(secondarySelectionOption.name ?? "")")
        }
        if let thirdSelectionOption = screenData.facilities?.filter({ facility in
            return facility.facility_id == thirdSelectedFacilityId
        }).first?.options?.filter({ option in
            return option.isSelected
        }).first{
            finalSelectedItems.append(", \(thirdSelectionOption.name ?? "")")
        }
        finalSelectionLbl.text = finalSelectedItems
    }
    
    func resetAllFacilitiesOptions() {
        if var facilities = screenData.facilities{
            for facilityIndex in 0..<facilities.count{
                var facility = facilities[facilityIndex]
                if var options = facility.options {
                    for index in 0..<options.count {
                        var option = options[index]
                        option.isSelected = false
                        options[index] = option
                    }
                    facility.options = options
                }
                facilities[facilityIndex] = facility
            }
            screenData.facilities = facilities
        }
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case facilityOptionsCV[0]:
            return screenData.facilities?.first?.options?.count ?? 0
        case facilityOptionsCV[1]:
            return screenData.facilities?[1].options?.count ?? 0
        case facilityOptionsCV[2]:
            return screenData.facilities?[2].options?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let button:UIButton!
        let facilityOption:Options?
        if collectionView == facilityOptionsCV.first{
            facilityOption = screenData.facilities?.first?.options?[indexPath.row]
            button = cell.viewWithTag(100) as? UIButton
            button.setTitleColor(facilityOption!.isSelected ? .green : .white, for: .normal)
        }else if collectionView ==  facilityOptionsCV[1]{
            facilityOption = screenData.facilities?[1].options?[indexPath.row]
            button = cell.viewWithTag(200) as? UIButton
            button.setTitleColor(facilityOption!.isSelected ? .green : .white, for: .normal)
            button.isEnabled = true
            if let primarySelectionOption = screenData.facilities?.filter({ facility in
                return facility.facility_id == primarySelectedFacilityId
            }).first?.options?.filter({ option in
                return option.isSelected
            }).first{
                if primarySelectionOption.id == "4", let facilityOptionId = facilityOption?.id, facilityOptionId == "6"{
                    button.isEnabled = false
                    button.setTitleColor(.gray, for: .normal)
                }
            }
            
        }else{
            facilityOption = screenData.facilities?[2].options?[indexPath.row]
            button = cell.viewWithTag(300) as? UIButton
            button.setTitleColor(facilityOption!.isSelected ? .green : .white, for: .normal)
            button.isEnabled = true
            if let primarySelectionOption = screenData.facilities?.filter({ facility in
                return facility.facility_id == primarySelectedFacilityId
            }).first?.options?.filter({ option in
                return option.isSelected
            }).first{
                if primarySelectionOption.id == "3", let facilityOptionId = facilityOption?.id, facilityOptionId == "12"{
                    button.isEnabled = false
                    button.setTitleColor(.gray, for: .normal)
                }
            }
        }
        button.setTitle(facilityOption?.name, for: .normal)
        button.setImage(UIImage(named: facilityOption?.icon ?? "rooms"), for: .normal)
        return cell
    }
    
    
}

