//
//  TrashCanStorage.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/03.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation
import CoreData
protocol TrashCanStorageType{
    func createTrashCan(
        _ trashCan: TrashCan,
        completion: @escaping (Result<TrashCan, Error>) -> Void
    )
    
    func fetchTrashCanList(
        completion: @escaping (Result<[TrashCan], Error>) -> Void
    )
    
    func fetchTrashCan(
        latitude: Double,
        longitude: Double,
        completion: @escaping (Result<TrashCan, Error>) -> Void
    )
    
    func fetchTrashCan(
        objectIdString: String,
        completion: @escaping (Result<TrashCan, Error>) -> Void
    )
    
    func updateTrashCan(
        objectIdString: String,
        toUpdate: TrashCan,
        completion: @escaping (Result<TrashCan, Error>) -> Void
    )
    
    func deleteTrashCan(
        trashCanObjectId: NSManagedObjectID,
        completion: @escaping (Result<Void,Error>) -> Void
    )
}

extension Storage: TrashCanStorageType{
    func createTrashCan(_ trashCan: TrashCan, completion: @escaping (Result<TrashCan, Error>) -> Void) {
        let managedTrashCan = ManagedTrashCan(context: self.context)
        managedTrashCan.fromTrashCan(trashCan)
        do{
            try self.context.save()
            completion(.success(managedTrashCan.toTrashCan()))
        }catch let error{
            completion(.failure(StorageError.create(error.localizedDescription)))
        }
    }
    
    func fetchTrashCanList(completion: @escaping (Result<[TrashCan], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<ManagedTrashCan>(entityName: "ManagedTrashCan")
        do{
            let managedTrashCanList = try self.context.fetch(fetchRequest)
            let trashCanList = managedTrashCanList.map { $0.toTrashCan() }
            completion(.success(trashCanList))
        }catch let error{
            completion(.failure(StorageError.read(error.localizedDescription)))
        }
    }
    
    func fetchTrashCan(latitude: Double, longitude: Double, completion: @escaping (Result<TrashCan, Error>) -> Void) {
        let fetchRequest = NSFetchRequest<ManagedTrashCan>(entityName: "ManagedTrashCan")
        let latitudePredicate = NSPredicate(format: "latitude == %lf", latitude)
        let longitudePredicate = NSPredicate(format: "longitude == %lf", longitude)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [latitudePredicate, longitudePredicate])
        fetchRequest.predicate = andPredicate
        do {
            if let managedTrashCan = try self.context.fetch(fetchRequest).first {
                completion(.success(managedTrashCan.toTrashCan()))
            }
        } catch let error {
            completion(.failure(StorageError.read(error.localizedDescription)))
        }
    }
    
    func fetchTrashCan(objectIdString: String, completion: @escaping (Result<TrashCan, Error>) -> Void) {
        guard let trashCanObjectId = stringToObjectId(objectIdString), let managedTrashCan = self.context.object(with: trashCanObjectId) as? ManagedTrashCan else {
            completion(.failure(StorageError.read("ObjectId 오류")))
            return
        }
        completion(.success(managedTrashCan.toTrashCan()))
    }
    
    func updateTrashCan(objectIdString: String, toUpdate: TrashCan, completion: @escaping (Result<TrashCan, Error>) -> Void) {
        guard let trashCanObjectId = stringToObjectId(objectIdString), let managedTrashCan = self.context.object(with: trashCanObjectId) as? ManagedTrashCan else {
            completion(.failure(StorageError.read("ObjectId 오류")))
            return
        }
        managedTrashCan.fromTrashCan(toUpdate)
        do{
            try self.context.save()
            let trashCan = managedTrashCan.toTrashCan()
            completion(.success(trashCan))
        }catch let error{
            completion(.failure(StorageError.update(error.localizedDescription)))
        }
    }
    
    func deleteTrashCan(trashCanObjectId: NSManagedObjectID, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let managedTrashCan = self.context.object(with: trashCanObjectId) as? ManagedTrashCan else {
            completion(.failure(StorageError.read("ObjectId 오류")))
            return
        }
        self.context.delete(managedTrashCan)
        do{
            try self.context.save()
            completion(.success(()))
        }catch let error{
            completion(.failure(StorageError.delete(error.localizedDescription)))
        }
    }
    
    
}
