//
//  AnimalDonationViewModel.swift
//  Messangel
//
//  Created by Saad on 1/7/22.
//

import SwiftUI

struct AnimalDonation: Codable {
    var id: Int?
    var single_animal: Bool?
    var single_animal_note: String?
    var animal_name: String
    var animal_name_note: String?
    var animal_contact_detail: Int?
    var animal_organization_detail: Int?
    var animal_species: String?
    var animal_species_note: String?
    var animal_photo: String?
    var animal_note: String
    var animal_note_attachment: [Int]?
    var user = getUserId()
}

struct AnimalDonationDetail: Hashable, Codable {
    var id: Int
    var single_animal: Bool
    var single_animal_note: String?
    var animal_name: String
    var animal_name_note: String?
    var animal_contact_detail: Contact?
    var animal_organization_detail: Organization?
    var animal_species: String?
    var animal_species_note: String?
    var animal_photo: String?
    var animal_note: String
    var animal_note_attachment: [Attachement]?
    var user: User
}

class AnimalDonatiopnViewModel: ObservableObject {
    @Published var attachements = [Attachement]()
    @Published var contactName = ""
    @Published var orgName = ""
    @Published var localPhoto = UIImage()
    @Published var updateRecord = false
    @Published var donations = [AnimalDonationDetail]()
    @Published var animalDonation = AnimalDonation(animal_name: "", animal_species: "", animal_note: "")
    @Published var apiResponse = APIService.APIResponse(message: "")
    @Published var apiError = APIService.APIErr(error: "", error_description: "")
    
    func attach(completion: @escaping (Bool) -> Void) {
        APIService.shared.post(model: attachements, response: attachements, endpoint: "users/note_attachment") { result in
            switch result {
            case .success(let attachements):
                DispatchQueue.main.async {
                    self.attachements = attachements
                    completion(true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.error_description)
                    self.apiError = error
                    completion(false)
                }
            }
        }
    }
    
    func create(completion: @escaping (Bool) -> Void) {
        APIService.shared.post(model: animalDonation, response: animalDonation, endpoint: "users/\(getUserId())/animal") { result in
            switch result {
            case .success(let animal):
                DispatchQueue.main.async {
                    self.animalDonation = animal
                    completion(true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.error_description)
                    self.apiError = error
                    completion(false)
                }
            }
        }
    }
    
    func getAll(completion: @escaping (Bool) -> Void) {
        APIService.shared.getJSON(model: donations, urlString: "users/\(getUserId())/animal") { result in
            switch result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.donations = items
                    completion(true)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func del(id: Int, completion: @escaping (Bool) -> Void) {
        APIService.shared.delete(endpoint: "users/\(getUserId())/animal/\(id)/animal") { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    completion(true)
                }
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func update(id: Int, completion: @escaping (Bool) -> Void) {
        APIService.shared.post(model: animalDonation, response: animalDonation, endpoint: "users/\(getUserId())/animal/\(id)/animal", method: "PUT") { result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self.animalDonation = item
                    completion(true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.error_description)
                    self.apiError = error
                    completion(false)
                }
            }
        }
    }
}
