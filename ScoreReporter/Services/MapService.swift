//
//  MapService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import MapKit
import PINCache

typealias MapImageDownloadCompletion = (UIImage?, NSError?, NSUUID?) -> Void

class MapService {
    static var sharedInstance = MapService()
    
    private var pendingOperationIDs = [NSUUID]()
    
    func cancelImageRequestWithID(ID: NSUUID) {
        guard let index = pendingOperationIDs.indexOf(ID) else {
            return
        }
        
        pendingOperationIDs.removeAtIndex(index)
    }
    
    func imageForCoordinate(coordinate: CLLocationCoordinate2D, completion: MapImageDownloadCompletion?) -> NSUUID? {
        let cache = PINCache.sharedCache()
        let key = String(coordinate)
        
        if let image = cache.objectForKey(key) as? UIImage {
            print("Found image in cache")
            completion?(image, nil, nil)
            
            return nil
        }
        else {
            print("No image found in cache")
            
            let operationID = NSUUID()
            
            let snapshotCompletion = { [weak self] (image: UIImage?, error: NSError?) in
                guard let index = self?.pendingOperationIDs.indexOf(operationID) else {
                    return
                }
                
                self?.pendingOperationIDs.removeAtIndex(index)
                
                if let image = image {
                    cache.setObject(image, forKey: key)
                }
                
                completion?(image, error, operationID)
            }
            
            pendingOperationIDs.append(operationID)
            
            MKMapSnapshotter.imageForCoordinate(coordinate, completion: snapshotCompletion)
            
            return operationID
        }
    }
}
