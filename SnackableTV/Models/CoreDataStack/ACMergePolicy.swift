//
//  ACMergePolicy.swift
//  <?>App
//
//  Created by Austin Chen on 2016-04-28.
//

import CoreData

open class ACMergePolicy : NSMergePolicy {
    public enum MergeMode {
        case remote
        case local
        
        fileprivate var mergeType: NSMergePolicyType {
            switch self {
            case .remote: return .mergeByPropertyObjectTrumpMergePolicyType
            case .local: return .mergeByPropertyStoreTrumpMergePolicyType
            }
        }
    }

    required public init(mode: MergeMode) {
        super.init(merge: mode.mergeType)
    }
}

extension Sequence where Iterator.Element == NSMergeConflict {
    func conflictsAndObjectsWithType<T>(_ cls: T.Type) -> [(NSMergeConflict, T)] {
        return filter { $0.sourceObject is T }.map { ($0, $0.sourceObject as! T) }
    }
}

