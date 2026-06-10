import Foundation

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    var completed: Bool
}

extension Todo {
    static let sampleData: [Todo] = [
        Todo(userId: 1, id: 1, title: "delectus aut autem", completed: false),
        Todo(userId: 1, id: 2, title: "quis ut nam facilis et officia qui", completed: false),
        Todo(userId: 1, id: 3, title: "fugiat veniam minus", completed: false),
        Todo(userId: 1, id: 4, title: "et porro tempora", completed: true)
    ]
}
