//
//  UIImageView+Map.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import UIKit
import CoreLocation

extension UIImageView {
    func setMapImageWithCoordinate(coordinate: CLLocationCoordinate2D?, placeholderImage: UIImage? = nil) {
        cancelMapImageDownload()
        
        if let placeholderImage = placeholderImage {
            image = placeholderImage
        }
        
        guard let coordinate = coordinate else {
            if placeholderImage == nil {
                image = nil
                setNeedsLayout()
            }
            
            return
        }
        
        let completion = { [weak self] (image: UIImage?, error: NSError?, operationID: NSUUID?) in
            let block = {
                if self?.mapImageDownloadOperationUUID != operationID && operationID != nil {
                    return
                }
                
                self?.mapImageDownloadOperationUUID = nil
                
                guard error == nil else {
                    return
                }
                
                self?.image = image
                self?.setNeedsLayout()
            }
            
            if NSThread.isMainThread() {
                block()
            }
            else {
                dispatch_async(dispatch_get_main_queue(), block)
            }
        }
        
        mapImageDownloadOperationUUID = MapService.sharedInstance.imageForCoordinate(coordinate, completion: completion)
    }
    
    func cancelMapImageDownload() {
        guard let operationID = mapImageDownloadOperationUUID else {
            return
        }
        
        MapService.sharedInstance.cancelImageRequestWithID(operationID)
        mapImageDownloadOperationUUID = nil
    }
}

// MARK: - Private

private extension UIImageView {
    static var mapImageDownloadOperationAssociatedKey = "com.bradsmith.scorereporter.mapImageDownloadOperationAssociatedKey"
    
    var mapImageDownloadOperationUUID: NSUUID? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.mapImageDownloadOperationAssociatedKey) as? NSUUID
        }
        
        set {
            objc_setAssociatedObject(self, &UIImageView.mapImageDownloadOperationAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
