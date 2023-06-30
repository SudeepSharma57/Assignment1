import Foundation

struct Facilities : Codable {
	let facility_id : String?
	let name : String?
	var options : [Options]?

	enum CodingKeys: String, CodingKey {

		case facility_id = "facility_id"
		case name = "name"
		case options = "options"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		facility_id = try values.decodeIfPresent(String.self, forKey: .facility_id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		options = try values.decodeIfPresent([Options].self, forKey: .options)
	}

}
