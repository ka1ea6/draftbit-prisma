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
    },
    right: {
      value: response.right.value,
      unit: response.right.unit->Dimension.State.stringToMeasurementUnit,
    },
    bottom: {
      value: response.bottom.value,
      unit: response.bottom.unit->Dimension.State.stringToMeasurementUnit,
    },
    left: {
      value: response.left.value,
      unit: response.left.unit->Dimension.State.stringToMeasurementUnit,
    },
  }

  normalized
}

@react.component
let make = () => {
  let (marginState, marginDispatch) = React.useReducer(
    Dimension.State.reducer,
    Dimension.State.initialValue,
  )
  let (itemId: option<int>, setItemId) = React.useState(_ => None)

  // function to fetch the item
  let fetchItem = () => {
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
  React.useEffect0(() => {
    switch Dom.Storage.getItem("itemId", Dom.Storage.localStorage) {
    | Some(item) => setItemId(_ => Belt.Int.fromString(item))
    | None => {
        let _ = fetchItem()->Js.Promise.then_(itemJson => {
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
  })
  // Js.Promise.resolve(marginDispatch(SetValue(normalizeDimensionResponse(parsed.margin))))

  React.useEffect1(() => {
    Js.Console.log("running")
    switch itemId {
    | Some(val) => {
        let _ = fetchDimensions(val)->Js.Promise.then_(dimensionsJson => {
          let parsedValue: option<dimensionResponse> = Some(Obj.magic(dimensionsJson))
          switch parsedValue {
          | Some(parsed) =>
            Js.Promise.resolve(
              parsed.margin->normalizeDimensionResponse->Initialize->marginDispatch,
            )
          | None => Js.Promise.resolve()
          }
        }, _)
      }
    | None => Js.Console.log("No item id")
    }

    None
  }, [itemId])

  <div className="prism-container">
    <div className="prism-top-row">
      <InputGroup
        initialValue=Dimension.State.initialValue.top.value
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
        initialValue=Dimension.State.initialValue.left.value
        name="ml"
        onValueChange={e =>
          marginDispatch(
            AlterValue(Left, ReactEvent.Form.currentTarget(e)["value"], marginState.left.unit),
          )}
        value={marginState.left.value}
        unit={marginState.left.unit}
        onUnitChange={option => marginDispatch(AlterValue(Left, marginState.left.value, option))}
      />
      <div className="prism-inner-box"> <Padding /> </div>
      <InputGroup
        initialValue=Dimension.State.initialValue.right.value
        name="mr"
        onValueChange={e =>
          marginDispatch(
            AlterValue(Right, ReactEvent.Form.currentTarget(e)["value"], marginState.right.unit),
          )}
        value={marginState.right.value}
        unit={marginState.right.unit}
        onUnitChange={option => marginDispatch(AlterValue(Right, marginState.right.value, option))}
      />
    </div>
    <div className="prism-bottom-row">
      <InputGroup
        initialValue=Dimension.State.initialValue.bottom.value
        name="mb"
        onValueChange={e =>
          marginDispatch(
            AlterValue(Bottom, ReactEvent.Form.currentTarget(e)["value"], marginState.bottom.unit),
          )}
        value={marginState.bottom.value}
        unit={marginState.bottom.unit}
        onUnitChange={option =>
          marginDispatch(AlterValue(Bottom, marginState.bottom.value, option))}
      />
    </div>
  </div>
}
