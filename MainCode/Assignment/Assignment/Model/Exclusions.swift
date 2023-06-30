import Foundation

struct Exclusions : Codable {
	let facility_id : String?
	let options_id : String?

	enum CodingKeys: String, CodingKey {

		case facility_id = "facility_id"
		case options_id = "options_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		facility_id = try values.decodeIfPresent(String.self, forKey: .facility_id)
		options_id = try values.decodeIfPresent(String.self, forKey: .options_id)
	}

}
