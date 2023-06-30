import Foundation

struct Options : Codable {
	let name : String?
	let icon : String?
	let id : String?
    var isSelected :Bool
    var disable:Bool

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case icon = "icon"
		case id = "id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
		id = try values.decodeIfPresent(String.self, forKey: .id)
        isSelected = false
        disable = false
	}

}
