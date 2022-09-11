[![Facebook](https://img.shields.io/badge/follow-facebook-4267B2)](https://www.facebook.com/Abedalkareem.Omreyh)
<a href="https://www.buymeacoffee.com/abedalkareem" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 20px !important;width: 100px !important; box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" > </a>
[![Youtube](https://img.shields.io/badge/subscribe-youtube-c4302b)](https://www.youtube.com/c/Omreyh)
[![Twitter](https://img.shields.io/badge/follow-twitter-00acee)](https://twitter.com/abedalkareemomr)

<p align="center">
 <img src="https://github.com/Abedalkareem/AMChoice/blob/master/amchoice.png" width="300" >
</p>


A custom radio buttons and check boxs for iOS 
<br>
<br>

## Screenshots

<img src="https://raw.githubusercontent.com/Abedalkareem/AMChoice/master/Screen%20Shot.png"  width="350">

## Usage

1-Add a `UIView` to your view controller and set the custom class to `AMChoice` .  

<img src="https://raw.githubusercontent.com/Abedalkareem/AMChoice/master/help1.png"  width="450">

2-Set the images for select and unselect statuses *(You can set it programmatically also)*.  

<img src="https://raw.githubusercontent.com/Abedalkareem/AMChoice/master/help2.png"  width="450">

3-Creat a new model and implement `Selectable` protocol, by implementing `Selectable` protocol you must add three variables (`title`, `isSelected`, and `isUserSelectEnable`).   
```swift
class VoteModel: NSObject, Selectable {
  var title: String
  var isSelected: Bool = false
  var isUserSelectEnable: Bool = true 
    
  init(title:String,isSelected:Bool,isUserSelectEnable:Bool) {
    self.title = title
    self.isSelected = isSelected
    self.isUserSelectEnable = isUserSelectEnable
  }
}
```

4-Set the data (`Selectable` items) for the AMChoice view.
```swift
amChoiceView.data = myItems 
```

## More

You can make any customization to the `AMChoice` view, or you can implement the `AMChoiceDelegate` protocol to get the selected index, see the comment in the code below to know more.  
```swift
class ViewController: UIViewController,AMChoiceDelegate {

  @IBOutlet weak var amChoiceView: AMChoice!
  
  let myItems = [
    VoteModel(title: "Will smith", isSelected: false, isUserSelectEnable: true),
    VoteModel(title: "Al pacino", isSelected: false, isUserSelectEnable: true),
    VoteModel(title: "Abedalkareem", isSelected: false, isUserSelectEnable: true),
  ]
    
  override func viewDidLoad() {
    super.viewDidLoad()
        
        
    amChoiceView.isRightToLeft = false // use it to support right to left language.
    amChoiceView.delegate = self // the delegate used to get the selected item when pressed.
    amChoiceView.data = myItems // fill your items.
    amChoiceView.selectionType = .single // selection type, single or multiple.
    amChoiceView.cellHeight = 50 // to set cell hight.
    amChoiceView.arrowImage = nil // use it if you want to add arrow to the cell.
        
    // you can set the selected and unselected image programmatically
    amChoiceView.selectedImage = UIImage(named: "selectedItem")
    amChoiceView.unselectedImage = UIImage(named: "unSelectedItem")
  }
    
  // get the selected item when pressed
  func didSelectRowAt(indexPath: IndexPath) {
    print("item at index \(indexPath.row) selected")
  }

  @IBAction func submit(_ sender: Any) {
    let selectedItems = amChoiceView.getSelectedItems() as! [VoteModel] // use getSelectedItems to get all selected item
    print(selectedItems)
    
     // use getSelectedItemsJoined to get all selected item joined with separator (if the selection type multiple)
    let selectedItemCommaSeparated = amChoiceView.getSelectedItemsJoined(separator: ",") 
    print("\n\n\nComma Separated: \n \(selectedItemCommaSeparated)")
  }
}
```

## Installation

AMChoice is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AMChoice'
```

## Support me 🚀  

You can support this project by:  

1- Checking my [apps](https://apps.apple.com/us/developer/id928910207).  
2- Star the repo.  
3- Share the repo with your friends.  
4- [Buy Me A Coffee](https://www.buymeacoffee.com/abedalkareem).  

## Follow me ❤️  

[Facebook](https://www.facebook.com/Abedalkareem.Omreyh/) | [Twitter](https://twitter.com/abedalkareemomr) | [Instagram](https://instagram.com/abedalkareemomreyh/) | [Youtube](https://www.youtube.com/user/AbedalkareemOmreyh)


## License

```
The MIT License (MIT)

Copyright (c) 2017 Abedalkareem

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
