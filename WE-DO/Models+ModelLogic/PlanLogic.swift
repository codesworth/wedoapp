//
//  PlanLogic.swift
//  WE-DO
//
//  Created by Mensah Shadrach on 24/12/2018.
//  Copyright © 2018 Mensah Shadrach. All rights reserved.
//

import FirebaseFirestore
import Geofirestore



public class PlanLogic{
    
    public private (set) var planlist:[WDPlanLists]
    public private (set) var plans:[WDPlan]

    private var modeller:ListModeller
    
    private var reference:CollectionReference{
        return firestore().collection(.plans)
    }
    
    private var userRef:CollectionReference{
        return firestore().collection(.users)
    }
    
    private var locationRef:CollectionReference{
        return firestore().collection(.locations)
    }
    
    private var myInviteReference:CollectionReference{
        let uid = UserDefaults.standard.string(forKey: USER_UID)!
        return firestore().collection(.users).document(uid).collection(.invites)
    }
    
    init() {
        modeller = ListModeller()
        plans = []
        planlist = []
    }
    
    func uploadPlan(plan:WDPlan,handler:@escaping CompletionHandlers.dataservice){
        let batch = firestore().batch()
        let pref = reference.document(plan.id)
        let geofire = GeoFirestore(collectionRef: locationRef)
        
        
        batch.setData(plan.dataExport(), forDocument: pref, merge: true)
        for activity in plan.activities{
            let ref = pref.collection(References.activities.rawValue).document(String(activity.time.unix_ts))
            batch.setData(activity.databaseExport(), forDocument: ref, merge: true)
        }
        for invite in plan.invites{
            let uref = userRef.document(invite.key).collection(.invites).document(pref.documentID)
            batch.setData([Fields.status.rawValue:invite.value.rawValue,Fields.ts_ending.rawValue:plan.endDate.timeIntervalSince1970, Fields.creator.rawValue:plan.creator], forDocument: uref, merge: true)
        }
        batch.commit { (err) in
            if let err = err{
                
                geofire.setLocation(geopoint: GeoPoint(latitude: plan.activities.first!.location.lat, longitude: plan.activities.first?.location.long ?? 0), forDocumentWithID: pref.documentID)
                handler(false,err.localizedDescription)
            }else{
                handler(true,nil)
            }
        }
    }
    
    func listenForAvailablePlans(handler:@escaping CompletionHandlers.dataservice){
        var  counter = 0
        
        myInviteReference.whereField(Fields.ts_ending.rawValue, isGreaterThan: Date().timeIntervalSince1970).addSnapshotListener { (snap, err) in
            guard let m_invites = snap?.documents else{
                return
            }
            Logger.log(snap?.documents)
            for invite in m_invites{
                self.reference.document(invite.documentID).getDocument(completion: { (document, error) in
                    counter += 1
                    if let document = document{
                        document.reference.collection(.activities).getDocuments(completion: { (activitiesnap, err) in
                            var activities:[WDActivity] = []
                            if let activitiesnap = activitiesnap{
                                for snap in activitiesnap.documents{
                                    let activity = WDActivity(snap)
                                    activities.append(activity)
                                }
                                let plan = WDPlan(document, activities)
                                if (!self.plans.contains(plan)){self.plans.append(plan)}
                                
                                if counter == m_invites.count{
                                    self.planlist = self.modeller.ModelList(plans: self.plans)
                                    counter = 0
                                    handler(true,nil)
                                }
                            }else{
                                if counter == m_invites.count{
                                    counter = 0
                                    handler(false,err?.localizedDescription ?? "Unkonwn Error")
                                }
                            }
                        })
                    }
                })
            }
        }

    }
    
    
    func getAvailablePlans(handler:@escaping CompletionHandlers.dataservice){
        var counter = 0
        reference.whereField(Fields.ending.rawValue, isGreaterThan: Date()).getDocuments { (query, err) in
            if let query = query{
                for doc in query.documents{
                    doc.reference.collection(.activities).getDocuments(completion: { (sq, err) in
                        counter += 1
                        var activities:[WDActivity] = []
                        if let secquery = sq{
                            for snap in secquery.documents{
                                let activity = WDActivity(snap)
                                activities.append(activity)
                            }
                            let plan = WDPlan(doc, activities)
                            if (!self.plans.contains(plan)){self.plans.append(plan)}
                            Logger.log(query.count)
                            if counter == query.count{
                                self.planlist = self.modeller.ModelList(plans: self.plans)
                                handler(true,nil)
                            }
                        }else{
                            if counter == query.count{
                                handler(false,err?.localizedDescription ?? "Unkonwn Error")
                            }
                        }
                    })
                }
            }else{
                handler(false,err?.localizedDescription ?? "Error unknown")
            }
        }
    }
    
}


