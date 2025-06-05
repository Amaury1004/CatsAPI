struct Attribute {
    let title: String
    let value: String
}

struct AttributeFactory {
    static func makeAttributes(from breed: Breed) -> [Attribute] {
        return [
            Attribute(title: "Weight (Imperial)", value: breed.weight?.imperial ?? "none"),
            Attribute(title: "Weight (Metric)", value: breed.weight?.metric ?? "none"),
            Attribute(title: "Temperament", value: breed.temperament ?? "none"),
            Attribute(title: "Origin", value: breed.origin ?? "none"),
            Attribute(title: "Country Codes", value: breed.countryCodes ?? "none"),
            Attribute(title: "Country Code", value: breed.countryCode ?? "none"),
            Attribute(title: "Life Span", value: breed.lifeSpan ?? "none"),
            Attribute(title: "Description", value: breed.description ?? "none"),
            Attribute(title: "Alt Names", value: breed.altNames ?? "none"),
            Attribute(title: "Intelligence", value: "\(breed.intelligence ?? 0)"),
            Attribute(title: "Affection Level", value: "\(breed.affectionLevel ?? 0)"),
            Attribute(title: "Energy Level", value: "\(breed.energyLevel ?? 0)"),
            Attribute(title: "Child Friendly", value: "\(breed.childFriendly ?? 0)"),
            Attribute(title: "Dog Friendly", value: "\(breed.dogFriendly ?? 0)"),
            Attribute(title: "Grooming", value: "\(breed.grooming ?? 0)"),
            Attribute(title: "Health Issues", value: "\(breed.healthIssues ?? 0)"),
            Attribute(title: "Shedding Level", value: "\(breed.sheddingLevel ?? 0)"),
            Attribute(title: "Social Needs", value: "\(breed.socialNeeds ?? 0)"),
            Attribute(title: "Stranger Friendly", value: "\(breed.strangerFriendly ?? 0)"),
            Attribute(title: "Vocalisation", value: "\(breed.vocalisation ?? 0)"),
            Attribute(title: "Lap", value: "\(breed.lap ?? 0)"),
            Attribute(title: "Indoor", value: "\(breed.indoor ?? 0)"),
            Attribute(title: "Adaptability", value: "\(breed.adaptability ?? 0)"),
            Attribute(title: "Hypoallergenic", value: "\(breed.hypoallergenic ?? 0)"),
            Attribute(title: "Natural", value: "\(breed.natural ?? 0)"),
            Attribute(title: "Rare", value: "\(breed.rare ?? 0)"),
            Attribute(title: "Rex", value: "\(breed.rex ?? 0)"),
            Attribute(title: "Short Legs", value: "\(breed.shortLegs ?? 0)"),
            Attribute(title: "Suppressed Tail", value: "\(breed.suppressedTail ?? 0)"),
            Attribute(title: "Experimental", value: "\(breed.experimental ?? 0)"),
            Attribute(title: "Wikipedia URL", value: breed.wikipediaUrl ?? "none"),
            Attribute(title: "Vetstreet URL", value: breed.vetstreetUrl ?? "none")
        ]
    }
}
