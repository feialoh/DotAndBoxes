//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by feialoh on 19/10/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import UIKit


protocol SidePanelViewControllerDelegate {
  func menuSelected(_ MenuItems: MenuItems)
}


func getDocumentsURL() -> URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(_ filename: String) -> String {
    
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL.path
    
}

class SidePanelViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var playerProPicBtn: UIButton!
    
    @IBOutlet weak var playerName: UILabel!
    
    
  var delegate: SidePanelViewControllerDelegate?

  var menus: Array<MenuItems>!
  
   var settingsDetails:Dictionary<String,Any>!
    let imagePicker = UIImagePickerController()
    
  struct TableView {
    struct CellIdentifiers {
      static let MenuCell = "MenuCell"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    playerProPicBtn.layer.cornerRadius = playerProPicBtn.frame.size.height/2
    playerProPicBtn.layer.borderWidth = 5
    playerProPicBtn.layer.borderColor = UIColor.white.cgColor
    playerProPicBtn.clipsToBounds = true
    
    
    imagePicker.delegate = self
    
    if Utilities.checkValueForKey(PROFILE_PIC)
    {
        let profilePic:Data = Utilities.getDefaultValue(PROFILE_PIC) as! Data
        playerProPicBtn.setImage(UIImage(data: profilePic), for:UIControl.State())
    }

    
    if Utilities.checkValueForKey(SETTINGS)
    {
        //show details
        settingsDetails = Utilities.getDefaultValue(SETTINGS) as? Dictionary<String,Any>
        
    }
    else
    {
        settingsDetails = ["single":UIDevice.current.name as AnyObject, "multiplesame":["Player1","Player2","Player3","Player4","Player5"],"startFirst":true]
    }

    playerName.text =  settingsDetails["single"] as? String
    
    tableView.reloadData()
  }
  
    @IBAction func playerBtnAction(_ sender: UIButton)
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        DispatchQueue.main.async(execute: {
        self.present(self.imagePicker, animated: true, completion: nil)
        })
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            playerProPicBtn.contentMode = .scaleAspectFit
            playerProPicBtn.setImage(pickedImage, for:UIControl.State())
            
            let myImageName = "profilepic.png"
            let imagePath = fileInDocumentsDirectory(myImageName)
            let _ = saveImage(pickedImage, path: imagePath)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func saveImage (_ image: UIImage, path: String ) -> Bool{
        
        let pngImageData = image.pngData()
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = (try? pngImageData!.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
        Utilities.storeDataToDefaults(PROFILE_PIC, data: pngImageData! as AnyObject)
        return result
        
    }
    
    func loadImageFromPath(_ path: String) -> UIImage? {
        
        var image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            Utilities.print("missing image at: \(path)")
            
            image = UIImage(named: "dummyProPic")
        }
        Utilities.print("Loading image from path: \(path)")
        return image
        
    }
}



// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menus.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.MenuCell, for: indexPath) as! MenuCell
    cell.configureForMenu(menus[(indexPath as NSIndexPath).row])
    return cell
  }
  
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedMenu = menus[(indexPath as NSIndexPath).row]
    delegate?.menuSelected(selectedMenu)
  }
  
}

class MenuCell: UITableViewCell {
  
  @IBOutlet weak var menuImageView: UIImageView!
  @IBOutlet weak var imageNameLabel: UILabel!
  
  func configureForMenu(_ menuItems: MenuItems) {
    menuImageView.image = menuItems.image
    imageNameLabel.text = menuItems.title
  }
  
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
