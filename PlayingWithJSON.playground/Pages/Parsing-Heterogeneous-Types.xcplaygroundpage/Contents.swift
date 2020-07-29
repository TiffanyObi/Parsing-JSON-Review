//Parsing Heterogeneous (mixed types)
//ex. postal code is ints and strings

import Foundation

let json = """
{
"results": [{
        "gender": "female",
        "name": {
            "title": "Mrs",
            "first": "April",
            "last": "Watts"
        },
        "location": {
            "street": {
                "number": 6533,
                "name": "E North St"
            },
            "city": "Kansas City",
            "state": "Oklahoma",
            "country": "United States",
            "postcode": 83696,
            "coordinates": {
                "latitude": "80.0183",
                "longitude": "82.3050"
            },
            "timezone": {
                "offset": "-8:00",
                "description": "Pacific Time (US & Canada)"
            }
        },
        "email": "april.watts@example.com",
        "login": {
            "uuid": "1f72a37b-dad7-42c0-8f38-c61c8cc16fb3",
            "username": "orangerabbit451",
            "password": "colt",
            "salt": "P1EkWcX0",
            "md5": "5fd24b5b5533c30092525a7b625aeaa8",
            "sha1": "834dff83eea9a0243edfa9ce3cbaf4da2806630e",
            "sha256": "b81912ada362314edb0681234bc29792a872025a89b4f1bf7d83f63203feaeb7"
        },
        "dob": {
            "date": "1948-10-23T16:57:10.463Z",
            "age": 72
        },
        "registered": {
            "date": "2015-07-27T15:43:32.525Z",
            "age": 5
        },
        "phone": "(880)-397-2424",
        "cell": "(681)-007-8567",
        "id": {
            "name": "SSN",
            "value": "901-71-3377"
        },
        "picture": {
            "large": "https://randomuser.me/api/portraits/women/51.jpg",
            "medium": "https://randomuser.me/api/portraits/med/women/51.jpg",
            "thumbnail": "https://randomuser.me/api/portraits/thumb/women/51.jpg"
        },
        "nat": "US"
    },
    {
        "gender": "female",
        "name": {
            "title": "Ms",
            "first": "Sofia",
            "last": "Gill"
        },
        "location": {
            "street": {
                "number": 7310,
                "name": "Frederick Ave"
            },
            "city": "Georgetown",
            "state": "Nova Scotia",
            "country": "Canada",
            "postcode": "Y5N 0E9",
            "coordinates": {
                "latitude": "-0.1529",
                "longitude": "-79.4845"
            },
            "timezone": {
                "offset": "-1:00",
                "description": "Azores, Cape Verde Islands"
            }
        },
        "email": "sofia.gill@example.com",
        "login": {
            "uuid": "6ad311bd-8acf-401c-a66c-b28e5e6b7570",
            "username": "bluedog205",
            "password": "boating",
            "salt": "XtuMADSl",
            "md5": "142db797c2bc687900db98629f78a435",
            "sha1": "d71acef64a75c5cb72c4439cbdd313f4f1a3593b",
            "sha256": "1ac31d458590319d68de43a7fd8f5e0b4d91f18f48182e6b3feab263bf96ea98"
        },
        "dob": {
            "date": "1978-06-12T22:45:12.529Z",
            "age": 42
        },
        "registered": {
            "date": "2009-10-16T05:54:27.726Z",
            "age": 11
        },
        "phone": "818-113-5421",
        "cell": "824-320-7893",
        "id": {
            "name": "",
            "value": null
        },
        "picture": {
            "large": "https://randomuser.me/api/portraits/women/92.jpg",
            "medium": "https://randomuser.me/api/portraits/med/women/92.jpg",
            "thumbnail": "https://randomuser.me/api/portraits/thumb/women/92.jpg"
        },
        "nat": "CA"
    }
]
}
""".data(using: .utf8)!

//Swift Models

struct ResultsWrapper: Decodable {
    let results: [Person]
}

struct Person: Decodable {
    let gender:String
    let location: Location
}

struct Location: Decodable{
    let city: String
    let country:String
    let postcode:Postcode
}

enum AppError:Error {
    case missingValue
}
//create a custon objects to be the data type
enum Postcode:Decodable {
    //handle the 2 case in the json "postcode" property
    //where the postcide can be an int or a string
    
    //we will also use associative values to capture the value of postcode
    //ex. if its an int we will capture the Int value

    case int(Int)
    case string(String)
    
    //also have to override the init(from decoder:) initializer
    init(from decoder: Decoder) throws {
        //handle the two cases
        //int or string
        //if its not either type throw error
        
        if let intValue = try? decoder.singleValueContainer().decode(Int.self){
            self = .int(intValue)
            return
        }
        
        if let stringValue = try? decoder.singleValueContainer().decode(String.self){
            self = .string(stringValue)
            return
        }
        
        throw AppError.missingValue // was not an int or a string
    }
}

//Decoding Json to swift objects

do{
    let dictionary = try JSONDecoder().decode(ResultsWrapper.self, from: json)
    let people = dictionary.results
  let firstPerson = people[0]
    let _ = people[1]
    let postcode = firstPerson.location.postcode
    
    switch  postcode {
    case .int(let intValue):
        print("postcode is \(intValue)")
    case .string(let stringValue):
        print("postcode is \(stringValue)")
    }
} catch {
    dump(error)
}
