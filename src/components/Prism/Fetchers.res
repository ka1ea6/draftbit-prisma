// function to fetch the item
let createItem = () => {
  let body = switch Js.Json.stringifyAny({"name": "item"}) {
  | Some(value) => value
  | None => ""
  }

  Fetch.fetchJson(
    `${Fetch.base_url}/items`,
    ~headers=Js.Dict.fromArray([
      ("Content-Type", "application/json"),
      ("Access-Control-Allow-Origin", "*"),
    ]),
    ~method=POST,
    ~body,
  )
}
// function to update the remote on the dimensions
let updateDimensions = (~itemId: int, ~marginState, ~paddingState) => {
  let body = switch Js.Json.stringifyAny({
    "margin": Dimension.State.normalizeDimensionRequest(marginState),
    "padding": Dimension.State.normalizeDimensionRequest(paddingState),
  }) {
  | Some(value) => value
  | None => ""
  }

  Fetch.fetchJson(
    `${Fetch.base_url}/items/${Belt.Int.toString(itemId)}/dimensions`,
    ~headers=Js.Dict.fromArray([
      ("Content-Type", "application/json"),
      ("Access-Control-Allow-Origin", "*"),
    ]),
    ~method=PATCH,
    ~body,
  )
}

// function to fetch dimensions for the item
let fetchDimensions = (~itemId: int) => {
  Fetch.fetchJson(
    `${Fetch.base_url}/items/${itemId->Belt.Int.toString}/dimensions`,
    ~headers=Js.Dict.fromArray([
      ("Content-Type", "application/json"),
      ("Access-Control-Allow-Origin", "*"),
    ]),
    ~method=GET,
  )
}
