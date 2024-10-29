module Response = {
  type t

  @send
  external json: t => Js.Promise.t<Js.Json.t> = "json"

  @send
  external text: t => Js.Promise.t<string> = "text"

  @get
  external ok: t => bool = "ok"

  @get
  external status: t => int = "status"

  @get
  external statusText: t => string = "statusText"
}

type methods = GET | POST | PUT | PATCH | DELETE

type options = {headers: Js.Dict.t<string>, method: string, body: option<string>}

@val
external fetch: (string, options) => Js.Promise.t<Response.t> = "fetch"

let base_url = "http://localhost:12346"

let fetchJson = (~headers=Js.Dict.empty(), ~method=GET, ~body=?, url: string): Js.Promise.t<
  Js.Json.t,
> => {
  let methodToString = switch method {
  | GET => "GET"
  | POST => "POST"
  | PUT => "PUT"
  | PATCH => "PATCH"
  | DELETE => "DELETE"
  }

  let init = {
    method: methodToString,
    headers: headers,
    body: body,
  }
  fetch(url, init) |> Js.Promise.then_(res =>
    if !Response.ok(res) {
      res->Response.text->Js.Promise.then_(text => {
        let msg = `${res->Response.status->Js.Int.toString} ${res->Response.statusText}: ${text}`
        Js.Exn.raiseError(msg)
      }, _)
    } else {
      res->Response.json
    }
  )
}
