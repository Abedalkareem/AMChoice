# AMChoice
Radio Button and check box for iOS 

<b>ScreenShots</b>

<img src="https://raw.githubusercontent.com/Abedalkareem/AMChoice/master/Screen%20Shot.png"  width="450">

<b>Usage</b>

1-Add UIView to your view controller and set custom class ``` AMChoice ``` 

<img src="https://raw.githubusercontent.com/Abedalkareem/AMChoice/master/help1.png"  width="450">

2-Set the image for select and unselect (you can set it programmatically)

<img src="https://raw.githubusercontent.com/Abedalkareem/AMChoice/master/help2.png"  width="450">

3-Creat new model and implement ``` Selectable ``` protocol , by implementing ``` Selectable ``` protocol you must add three variabel: (title,isSelected,isUserSelectEnable) 
```swift
class VoteModel: NSObject,Selectable {
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

4-Set the data (items) for AMChoice view, the item may come from server or static in your code like i have done
```swift
amChoiceView.data = myItems 
```


You can make any customise to the AMCHoice view (see ``` viewDidLoad ``` ) , or you can implement the ``` AMChoiceDelegate ``` protocol to get the selected index, see the comment in the code below to know more 
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
        
        
        amChoiceView.isRightToLeft = false // use it to support right to left language
        
        amChoiceView.delegate = self // the delegate used to get the selected item when pressed
        
        amChoiceView.data = myItems // fill your item , the item may come from server or static in your code like i have done
        
        amChoiceView.selectionType = .single // selection type , single or multiple
        
        amChoiceView.cellHeight = 50 // to set cell hight
        
        amChoiceView.arrowImage = nil // use ot if you want to add arrow to the cell
        
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
        
        let selectedItemCommaSeparated = amChoiceView.getSelectedItemsJoined(separator: ",") // use getSelectedItemsJoined to get all selected item joined with separator (if the selection type multiple)
        print("\n\n\nComma Separated: \n \(selectedItemCommaSeparated)")
    }


}
```

<b>Installation</b>

Just add ```AMChoice.swift``` in your project


<b>Note</b>

I'm going to be very happy if you give me a feedback or advice , thank you

<b>License</b>

```
The MIT License (MIT)

Copyright (c) 2014 codestergit

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
