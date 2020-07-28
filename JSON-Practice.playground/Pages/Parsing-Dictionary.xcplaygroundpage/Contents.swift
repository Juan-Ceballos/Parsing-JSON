import Foundation
// Parsing Dictionary

// create data
let json = """
{
 "results": [
   {
     "firstName": "John",
     "lastName": "Appleseed"
   },
  {
    "firstName": "Alex",
    "lastName": "Paul"
  }
 ]
}
""".data(using: .utf8)!

// create models

// Codable: Decodable & Encodable
// Decodable: Converts json data
// Encodable

// Top level json dictionary
struct ResultsWrapper: Decodable {
    let results: [Contact]
}

struct Contact: Decodable {
    let firstName: String
    let lastName: String
}


// decode the json data to our swift model

do {
    let dictionary = try JSONDecoder().decode(ResultsWrapper.self, from: json)
    let contacts = dictionary.results
    dump(contacts)
} catch  {
    print("\(error)")
}
