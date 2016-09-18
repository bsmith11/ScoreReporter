//
//  MKMapSnapshotter+Extensions.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 9/17/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import MapKit

typealias MapSnapshotCompletion = (UIImage?, NSError?) -> Void

extension MKMapSnapshotter {
    static func imageForCoordinate(coordinate: CLLocationCoordinate2D, completion: MapSnapshotCompletion?) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let size = CGSize(width: UIScreen.mainScreen().bounds.width, height: 150.0)
        
        let options = MKMapSnapshotOptions()
        options.region = region
        options.size = size
        
        let snapshotter = MKMapSnapshotter(options: options)
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        snapshotter.startWithQueue(queue, completionHandler: { (snapshot: MKMapSnapshot?, error: NSError?) in
            if let snapshot = snapshot {
                let image = snapshot.image
                let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                
                UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
                image.drawAtPoint(.zero)
                
                let visibleRect = CGRect(origin: .zero, size: image.size)
                var point = snapshot.pointForCoordinate(coordinate)
                if visibleRect.contains(point) {
                    point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2.0)
                    point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2.0)
                    pin.image?.drawAtPoint(point)
                }
                
                let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(compositeImage, nil)
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    completion?(nil, error)
                })
            }
        })
    }
}
