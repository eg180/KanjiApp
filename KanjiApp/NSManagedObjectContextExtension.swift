import UIKit
import CoreData

extension NSManagedObjectContext
{
    func fetchEntity<T: NSManagedObject> (entity: CoreDataEntities, _ property:EntityProperties? = nil, _ value:CVarArg = "") -> T?
    {
        let request : NSFetchRequest = NSFetchRequest(entityName: entity.description())
        
        request.returnsObjectsAsFaults = false
        
        if let p = property
        {
            request.predicate = NSPredicate(format: "\(p.description()) = %@", value)
        }
        else
        {
            request.predicate = NSPredicate()
        }
        
        var error: NSError? = nil
        
        var matches: NSArray = self.executeFetchRequest(request, error: &error)
        
        if (matches.count > 0)
        {
            return matches[0] as? T
        }
        
        let entityDescription = NSEntityDescription.entityForName(entity.description(), inManagedObjectContext: self)
        
        var card = T(entity: entityDescription, insertIntoManagedObjectContext: self)
        
        //            switch property {
        //            case .kanji:
        //                card.kanji = value
        //            default:
        //                return card
        //            }
        return card
        //        }
        //return nil
    }
    
    func fetchEntities(entity: CoreDataEntities, _ property: EntityProperties, _ value:CVarArg, _ sortProperty: EntityProperties, sortAscending: Bool = true) -> NSArray
    {
        let request : NSFetchRequest = NSFetchRequest(entityName: entity.description())
        
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "\(property.description()) = %@", value)
        
        var error: NSError? = nil
        
        var matches: NSArray = self.executeFetchRequest(request, error: &error)
        
//        if let s = sortProperty
//        {
            let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: sortProperty.description(), ascending: true)
            request.sortDescriptors = [sortDescriptor]
//        }
        return matches
        
//        if let c = matches as? [T]
//        {
//            return c
//        }
//        
//        return []
    }
    
    func fetchEntitiesGeneral (entity : CoreDataEntities, sortProperty : EntityProperties, sortAscending: Bool = true) -> [NSManagedObject]?{
        
        let entityName = entity.description()
        //let propertyName = property.description()
        
        let request :NSFetchRequest = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: sortProperty.description(), ascending: true)
        request.sortDescriptors = [sortDescriptor]
        var error: NSError? = nil
        var matches: NSArray = self.executeFetchRequest(request, error: &error)
        
        if matches.count > 0 {
            return matches as [NSManagedObject]
        }
        else {
            return nil
        }
    }

    func fetchCardByKanji(kanji: String) -> Card
    {
        var value : AnyObject? = fetchEntity(CoreDataEntities.Card, CardProperties.kanji, kanji)
        
        return value as Card
    }

    func fetchCardByIndex(index: NSNumber) -> Card
    {
        var value : AnyObject? = fetchEntity(CoreDataEntities.Card, CardProperties.index, index)
        
        return value as Card
    }
}