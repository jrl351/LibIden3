import Foundation

extension Decodable {
    init?(json: String,
          decoder: JSONDecoder = JSONDecoder()) {
        guard let data = json.data(using: .utf8),
              let obj = try? decoder.decode(Self.self, from: data) else {
            return nil
        }
        
        self = obj
    }
}

extension Encodable {
    func toJson(encoder: JSONEncoder = JSONEncoder()) -> String? {
        guard let data = try? encoder.encode(self),
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
}
