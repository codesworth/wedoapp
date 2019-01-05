//
//  WDPlanLists.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 26/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import IGListKit

public class WDPlanLists:ListDiffable,Equatable{
    public func diffIdentifier() -> NSObjectProtocol {
        return headertitle as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? WDPlanLists else { return false }
        return sectionType == object.sectionType
    }
    
    public static func == (lhs: WDPlanLists, rhs: WDPlanLists) -> Bool {
        return lhs.sectionType == rhs.sectionType && lhs.headertitle == rhs.headertitle
    }
    
    
    public private (set) var sectionType:SectionType
    public private (set) var list:[WDPlan]
    public private (set) var headertitle:String
    
    
    init(type:SectionType,list:[WDPlan]) {
        self.list = list
        sectionType = type
        switch type {
        case .active:
            headertitle = "Active Plans"
            break
        case .invites:
            headertitle = "Pending Invites"
            break
        default:
            headertitle = "Plans"
            break
        }
    }
}


class ListModeller{
    
    
    
    func ModelList(plans:[WDPlan])->[WDPlanLists]{
        
        var acL:[WDPlan] = []
        var ivL:[WDPlan] = []
        var fvL:[WDPlan] = []
        for plan in plans {
            switch determineSection(plan: plan){
            case .active:
                acL.append(plan)
                break
            case .invites:
                ivL.append(plan)
                break
            case .future:
                fvL.append(plan)
                break
            default:
                break
            }
            
        }
        let active = WDPlanLists(type: .active, list: acL)
        let invites = WDPlanLists(type: .invites, list: ivL)
        let future = WDPlanLists(type: .future, list: fvL)
       
        return [active,invites,future]
    }
    
    func determineSection(plan:WDPlan)->SectionType{
        
        
        let uid =  UserDefaults.standard.string(forKey: USER_UID)!
        let status = plan.invites[uid] ?? .uninvited
        if plan.endDate.timeIntervalSince1970 < Date().timeIntervalSince1970{
            return .dead
        }else{
            if status == .uninvited{
                return .dead
            }
            if status == .invited{
                return .invites
            }else{
                let date = Date().timeIntervalSince1970
                if date > plan.startDate.timeIntervalSince1970 && date < plan.endDate.timeIntervalSince1970{
                    return .active
                }else{
                    return .future
                }
            }
        }
        
    }
}
