import Vapor
import VaporMustache

let mustache = VaporMustache.Provider()
let app = Application(providers: [mustache])
var name = ""
var status = ""

app.get("/") { request in
    return try app.view("index.mustache", context: [
        "message": "Hello, world!"
    ])
}

app.get("/json") { request in
    return JSON([
        "string": "Hello world",
        "language": "Swift",
        "arrays": [
            "item_1": "item1",
            "item_2": "item2"
        ]
    ])
}

app.get("/form") { request in
    return try app.view("form.mustache")
}

app.get("/result") { request in
    return try app.view("result.mustache", context: [
        "name": name,
        "status": status
    ])
}

app.post("/form") { request in

    switch (request.data["is_json"].int!) {
        case 0:
            let requestName = request.data["name"].string
            name = requestName!
            if (request.data["age"].int! >= 20) {
                status = "Adult"
            } else {
                status = "Child"
            }
            return Response(redirect: "/result")
        case 1:
            return JSON([
                "name": name,
                "age": request.data["age"].int!
                ])
        default:
            return "Not Allowed Request!!"
    }
}

app.start()
