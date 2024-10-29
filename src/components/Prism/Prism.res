%%raw("import './Prism.css'")

type responseMeasurement = {
  value: Dimension.State.measurementValue,
  unit: string,
}

type responseDimensions = {
  top: responseMeasurement,
  right: responseMeasurement,
  bottom: responseMeasurement,
  left: responseMeasurement,
}

type dimensionResponse = {
  margin: responseDimensions,
  padding: responseDimensions,
}

let normalizeDimensionResponse = (response: responseDimensions): Dimension.State.t => {
  let normalized: Dimension.State.t = {
    top: {
      value: response.top.value,
      unit: response.top.unit->Dimension.State.stringToMeasurementUnit,
      remoteSaved: true,
    },
    right: {
      value: response.right.value,
      unit: response.right.unit->Dimension.State.stringToMeasurementUnit,
      remoteSaved: true,
    },
    bottom: {
      value: response.bottom.value,
      unit: response.bottom.unit->Dimension.State.stringToMeasurementUnit,
      remoteSaved: true,
    },
    left: {
      value: response.left.value,
      unit: response.left.unit->Dimension.State.stringToMeasurementUnit,
      remoteSaved: true,
    },
  }

  normalized
}
let normalizeDimensionRequest = (request: Dimension.State.t): responseDimensions => {
  let normalized: responseDimensions = {
    top: {
      value: request.top.value,
      unit: request.top.unit->Dimension.State.measurementUnitToString,
    },
    right: {
      value: request.right.value,
      unit: request.right.unit->Dimension.State.measurementUnitToString,
    },
    bottom: {
      value: request.bottom.value,
      unit: request.bottom.unit->Dimension.State.measurementUnitToString,
    },
    left: {
      value: request.left.value,
      unit: request.left.unit->Dimension.State.measurementUnitToString,
    },
  }

  normalized
}

let checkHasChanged = (dimensions: Dimension.State.t) => {
  !dimensions.top.remoteSaved ||
  !dimensions.right.remoteSaved ||
  !dimensions.bottom.remoteSaved ||
  !dimensions.left.remoteSaved
}

@react.component
let make = () => {
  let (marginState, marginDispatch) = React.useReducer(
    Dimension.State.reducer,
    Dimension.State.initialValue,
  )
  let (paddingState, paddingDispatch) = React.useReducer(
    Dimension.State.reducer,
    Dimension.State.initialValue,
  )
  let (itemId: option<int>, setItemId) = React.useState(_ => None)
  let (isItemIdValid, setIsItemIdValid) = React.useState(() => true)

  // function to fetch the item
  let createItem = () => {
    let body = switch Js.Json.stringifyAny({"name": "nameee"}) {
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
  let updateDimensions = (itemId: int) => {
    let body = switch Js.Json.stringifyAny({
      "margin": normalizeDimensionRequest(marginState),
      "padding": normalizeDimensionRequest(paddingState),
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
  let fetchDimensions = (itemId: int) => {
    Fetch.fetchJson(
      `${Fetch.base_url}/items/${itemId->Belt.Int.toString}/dimensions`,
      ~headers=Js.Dict.fromArray([
        ("Content-Type", "application/json"),
        ("Access-Control-Allow-Origin", "*"),
      ]),
      ~method=GET,
    )
  }

  // Hook for setting item Id
  React.useEffect1(() => {
    switch Dom.Storage.getItem("itemId", Dom.Storage.localStorage) {
    | Some(item) if isItemIdValid => setItemId(_ => Belt.Int.fromString(item))
    | _ => {
        let _ = createItem()->Js.Promise.then_(itemJson => {
          let itemId = Some(Obj.magic(itemJson)["id"])
          switch itemId {
          | Some(val) => {
              Dom.Storage.setItem("itemId", val, Dom.Storage.localStorage)
              Js.Promise.resolve(setItemId(_ => itemId))
            }
          | None => Js.Promise.resolve()
          }
        }, _)
      }
    }
    None
  }, [isItemIdValid])

  React.useEffect1(() => {
    switch itemId {
    | Some(val) => {
        let _ =
          fetchDimensions(val)->Js.Promise.then_(dimensionsJson => {
            let parsedValue: option<dimensionResponse> = Some(Obj.magic(dimensionsJson))
            switch parsedValue {
            | Some(parsed) => {
                parsed.margin->normalizeDimensionResponse->Initialize->marginDispatch
                parsed.padding->normalizeDimensionResponse->Initialize->paddingDispatch
                Js.Promise.resolve()
              }
            | None => Js.Promise.resolve()
            }
          }, _)
            |> Js.Promise.catch(_ => {
              Dom.Storage.removeItem("itemId", Dom.Storage.localStorage)
              setIsItemIdValid(_ => false)
              Js.Promise.resolve()
            })
      }
    | None => Js.Console.log("No item id")
    }

    None
  }, [itemId])

  let saveDimensions = _ =>
    switch itemId {
    | Some(id) if checkHasChanged(marginState) || checkHasChanged(paddingState) => {
        let _ = updateDimensions(id)->Js.Promise.then_(_ => {
          SaveRemote->marginDispatch
          SaveRemote->paddingDispatch
          Js.Promise.resolve()
        }, _)
      }
    | Some(_) => Js.Console.log("No changes to save")
    | None => Js.Console.log("No item id")
    }

  <div className="prism-outer-container">
    <div className="prism-container">
      <div className="prism-top-row">
        <InputGroup
          remoteSaved=marginState.top.remoteSaved
          name="mt"
          onValueChange={e =>
            marginDispatch(
              AlterValue(Top, ReactEvent.Form.currentTarget(e)["value"], marginState.top.unit),
            )}
          value={marginState.top.value}
          unit={marginState.top.unit}
          onUnitChange={option => marginDispatch(AlterValue(Top, marginState.top.value, option))}
        />
      </div>
      <div className="prism-middle-row">
        <InputGroup
          remoteSaved=marginState.left.remoteSaved
          name="ml"
          onValueChange={e =>
            marginDispatch(
              AlterValue(Left, ReactEvent.Form.currentTarget(e)["value"], marginState.left.unit),
            )}
          value={marginState.left.value}
          unit={marginState.left.unit}
          onUnitChange={option => marginDispatch(AlterValue(Left, marginState.left.value, option))}
        />
        <div className="prism-inner-box"> <Padding paddingDispatch paddingState /> </div>
        <InputGroup
          remoteSaved=marginState.right.remoteSaved
          name="mr"
          onValueChange={e =>
            marginDispatch(
              AlterValue(Right, ReactEvent.Form.currentTarget(e)["value"], marginState.right.unit),
            )}
          value={marginState.right.value}
          unit={marginState.right.unit}
          onUnitChange={option =>
            marginDispatch(AlterValue(Right, marginState.right.value, option))}
        />
      </div>
      <div className="prism-bottom-row">
        <InputGroup
          remoteSaved=marginState.bottom.remoteSaved
          name="mb"
          onValueChange={e =>
            marginDispatch(
              AlterValue(
                Bottom,
                ReactEvent.Form.currentTarget(e)["value"],
                marginState.bottom.unit,
              ),
            )}
          value={marginState.bottom.value}
          unit={marginState.bottom.unit}
          onUnitChange={option =>
            marginDispatch(AlterValue(Bottom, marginState.bottom.value, option))}
        />
      </div>
    </div>
    <button type_="button" onClick={saveDimensions} className="save-btn">
      {"Save"->React.string}
    </button>
  </div>
}
