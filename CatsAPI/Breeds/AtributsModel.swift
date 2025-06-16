struct Attribute {
    
    enum Parameters{
        case progres, none
    }
    
    let title: String
    let value: String
    
    let type: Parameters
}

struct AttributeFactory {
    static func makeAttributes(from breed: Breed) -> [Attribute] {
        return [
            Attribute(title: "Weight (Imperial)", value: breed.weight?.imperial ?? "none", type: .none),
                        Attribute(title: "Weight (Metric)", value: breed.weight?.metric ?? "none", type: .none),
                        Attribute(title: "Temperament", value: breed.temperament ?? "none", type: .none),
                        Attribute(title: "Origin", value: breed.origin ?? "none", type: .none),
                        Attribute(title: "Country Codes", value: breed.countryCodes ?? "none", type: .none),
                        Attribute(title: "Country Code", value: breed.countryCode ?? "none", type: .none),
                        Attribute(title: "Life Span", value: breed.lifeSpan ?? "none", type: .none),
                        Attribute(title: "Description", value: breed.description ?? "none", type: .none),
                        Attribute(title: "Alt Names", value: breed.altNames ?? "none", type: .none),

                        Attribute(title: "Intelligence", value: "\(breed.intelligence ?? 0)", type: .progres),
                        Attribute(title: "Affection Level", value: "\(breed.affectionLevel ?? 0)", type: .progres),
                        Attribute(title: "Energy Level", value: "\(breed.energyLevel ?? 0)", type: .progres),
                        Attribute(title: "Child Friendly", value: "\(breed.childFriendly ?? 0)", type: .progres),
                        Attribute(title: "Dog Friendly", value: "\(breed.dogFriendly ?? 0)", type: .progres),
                        Attribute(title: "Grooming", value: "\(breed.grooming ?? 0)", type: .progres),
                        Attribute(title: "Health Issues", value: "\(breed.healthIssues ?? 0)", type: .progres),
                        Attribute(title: "Shedding Level", value: "\(breed.sheddingLevel ?? 0)", type: .progres),
                        Attribute(title: "Social Needs", value: "\(breed.socialNeeds ?? 0)", type: .progres),
                        Attribute(title: "Stranger Friendly", value: "\(breed.strangerFriendly ?? 0)", type: .progres),
                        Attribute(title: "Vocalisation", value: "\(breed.vocalisation ?? 0)", type: .progres),
                        Attribute(title: "Lap", value: "\(breed.lap ?? 0)", type: .progres),
                        Attribute(title: "Indoor", value: "\(breed.indoor ?? 0)", type: .progres),
                        Attribute(title: "Adaptability", value: "\(breed.adaptability ?? 0)", type: .progres),
                        Attribute(title: "Hypoallergenic", value: "\(breed.hypoallergenic ?? 0)", type: .progres),
                        Attribute(title: "Natural", value: "\(breed.natural ?? 0)", type: .progres),
                        Attribute(title: "Rare", value: "\(breed.rare ?? 0)", type: .progres),
                        Attribute(title: "Rex", value: "\(breed.rex ?? 0)", type: .progres),
                        Attribute(title: "Short Legs", value: "\(breed.shortLegs ?? 0)", type: .progres),
                        Attribute(title: "Suppressed Tail", value: "\(breed.suppressedTail ?? 0)", type: .progres),
                        Attribute(title: "Experimental", value: "\(breed.experimental ?? 0)", type: .progres),

                        Attribute(title: "Wikipedia URL", value: breed.wikipediaUrl ?? "none", type: .none),
                        Attribute(title: "Vetstreet URL", value: breed.vetstreetUrl ?? "none", type: .none)
                    ]
                }
            }
