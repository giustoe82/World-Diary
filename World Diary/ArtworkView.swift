//
//  ArtworkView.swift
//  World Diary
//
//  Created by Marco Giustozzi on 2019-02-21.
//  Copyright © 2019 marcog. All rights reserved.
//

import Foundation
import MapKit

class ArtworkView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let artwork = newValue as? Artwork else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "search"), for: UIControl.State())
            rightCalloutAccessoryView = mapsButton
            // 2
            //glyphText = String(artwork.comment.first!)
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = artwork.comment
            detailCalloutAccessoryView = detailLabel
            
            
        }
    }
}
