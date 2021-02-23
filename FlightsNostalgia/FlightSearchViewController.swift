//
//  FlightSearchViewController.swift
//  FlightsNostalgia
//
//  Created by hyperactive on 04/02/2021.
//

import UIKit

class FlightSearchViewController: UIViewController {

    var originTextField : UITextField = {
        let tf = UITextField()
        tf.text = "TLV"
        return tf
    }()
    
    var destinationTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Destination"
        return tf
    }()
    
    var departureDatePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.minimumDate = Date()
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .date
        return dp
    }()
    
    var returnDatePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.minimumDate = Date()
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .date
        return dp
    }()
    
    var search : UIButton = {
        let b = UIButton()
        b.setTitle("Search", for: .normal)
        b.layer.cornerRadius = 10
        b.layer.masksToBounds = true
        b.backgroundColor = .magenta
        return b
    }()
    
    var destinationPickerView: UIPickerView = {
        let pv = UIPickerView()
        return pv
    }()
    
    var formItems: [UIView] = []
    var isSearching = false
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // MARK: configuration for UI
        
        view.backgroundColor = .white
        configureForm()
        configureAirportPicker()
        
        search.addTarget(self, action: #selector(searchFlights), for: .touchUpInside)
    }
    
    @objc func availibleDatesObserver(notification: Notification) {
        if notification.object != nil {
            do {
                let json = try JSONSerialization.jsonObject(with: (notification.object as! Data?)!, options: [.allowFragments])
                
                print((json))
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func configureAirportPicker() {
        destinationPickerView.delegate = self
        destinationPickerView.dataSource = self
    }
    
    func configureForm() {
        formItems = [originTextField, destinationPickerView, departureDatePicker, search]
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(FormItemCollectionViewCell.self, forCellWithReuseIdentifier: "formItem")
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.pin(view: collectionView, with: .zero)
    }
    
    // MARK: - compare dates to be correct in range e.g departureDate < returnDate, remmember to check the inputs for correctness, not to search again while already searching, etc...

    func makeInfoForSearch() -> [[String: Any]]? {
        let departureDateComponents = departureDatePicker.calendar.dateComponents([.year, .month, .day], from: departureDatePicker.date)
        
        let returnDateComponents = returnDatePicker.calendar.dateComponents([.year,.month,.day], from: returnDatePicker.date)
        
        guard let departureDate = makeTextFromDateComponents(departureDateComponents) else { return nil }
        
        guard let returnDate = makeTextFromDateComponents(returnDateComponents) else { return nil }
        
        let origin = originTextField.text!
        
        let destination = Airports.allCases[destinationPickerView.selectedRow(inComponent: 0)].rawValue
        
        print(destination)
        
        let info: [[String: Any]] = [["origin": origin, "destination" : destination, "departureDate": departureDate, "returnDate": returnDate]]
        
        return info
    }
    
    func makeTextFromDateComponents(_ components: DateComponents) -> String? {
        guard let month = components.month else { return nil }
        guard let day = components.day else { return nil }
        
        let monthStr = month < 10 ? "0\(month)" : "\(month)"
        let dayStr = day < 10 ? "0\(day)" : "\(day)"
        
        let str = "\(components.year!)-\(monthStr)-\(dayStr)"
        
        return str
    }
    
    @objc func searchFlights() {
        
        isSearching = true
        guard let info = makeInfoForSearch() else { return }
        
        FlightsServer.shared.post(req: .flights, info: info) { [weak self] (data) in
            if data != nil {
                DispatchQueue.main.async { [weak self] in
                    let fdvc = FlightsDisplayViewController()
                    fdvc.parseJSON(data!)
                    self?.navigationController?.show(fdvc, sender: nil)
                }
            }
        }
    }
}

extension FlightSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return formItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "formItem", for: indexPath) as! FormItemCollectionViewCell
        
        if cell.formItem == nil { cell.formItem = formItems[indexPath.row] }
        cell.accessories = [.disclosureIndicator()]
        
        return cell
    }
    
}

extension FlightSearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 44.0
        
        switch indexPath.item {
        case 0: height = 200.0
        case 2: height = 200.0
        case 3: height = 200.0
        default: break
        }
        
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: -10, right: -10)
    }
}

extension FlightSearchViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: Airports.allCases[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Airports.allCases.count
    }
}

extension FlightSearchViewController: UICollectionViewDelegate { }

extension FlightSearchViewController: UIPickerViewDelegate { }
