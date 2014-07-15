import Foundation
import UIKit
import CoreData

class AddFromList: CustomUIViewController
{
    @IBOutlet var jlptLevel : UISegmentedControl
    @IBOutlet var isOnlyKanji : UISwitch
    @IBOutlet var addAmount : UITextField
    @IBOutlet var addButton : UIButton
    
    var settings: Settings {
    get {
        return managedObjectContext.fetchEntity(CoreDataEntities.Settings, SettingsProperties.userName, "default")! as Settings
    }
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
        var settings = managedObjectContext.fetchEntity(.Settings, SettingsProperties.userName, "default")! as Settings
        
        settings.userName = "default"
        
        saveContext()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        jlptLevel.selectedSegmentIndex = settings.jlptLevel.integerValue
        isOnlyKanji.on = settings.onlyStudyKanji.boolValue
        addAmount.text = settings.cardAddAmount.stringValue
    }
    
    @IBAction func onAddTouch(sender: AnyObject)
    {
        println("button")
    }
    
    @IBAction func onJlptLevelChanged(sender : AnyObject)
    {
        settings.jlptLevel = jlptLevel.selectedSegmentIndex
        
        saveContext()
    }
    
    @IBAction func isOnlyKanjiChanged(sender : AnyObject)
    {
        settings.onlyStudyKanji = isOnlyKanji.on
        
        saveContext()
    }
    
    @IBAction func addAmountChanged(sender : AnyObject)
    {
        var amount = addAmount.text.toInt()
        
        println(amount)
        
        if var castAmount = amount
        {
            settings.cardAddAmount = castAmount
        }
        else
        {
            addAmount.text = settings.cardAddAmount.stringValue
        }
    }
}
