import Foundation

struct BaseModel : Codable {
	var facilities : [Facilities]?
	let exclusions : [[Exclusions]]?

	enum CodingKeys: String, CodingKey {

		case facilities = "facilities"
		case exclusions = "exclusions"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		facilities = try values.decodeIfPresent([Facilities].self, forKey: .facilities)
		exclusions = try values.decodeIfPresent([[Exclusions]].self, forKey: .exclusions)
	}

}
