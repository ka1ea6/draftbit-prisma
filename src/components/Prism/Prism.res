%%raw("import './Prism.css'")

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

  // Hook for setting item Id
  React.useEffect1(() => {
    switch Dom.Storage.getItem("itemId", Dom.Storage.localStorage) {
    | Some(item) if isItemIdValid => setItemId(_ => Belt.Int.fromString(item))
    | _ => {
        let _ =
          Fetchers.createItem()->Js.Promise.then_(itemJson => {
            let itemId = Some(Obj.magic(itemJson)["id"])
            switch itemId {
            | Some(val) => {
                Dom.Storage.setItem("itemId", val, Dom.Storage.localStorage)
                Js.Promise.resolve(setItemId(_ => itemId))
              }
            | None => Js.Promise.resolve()
            }
          }, _)
            |> Js.Promise.catch(_ => {
              Js.Console.error("Error fetching")
              Js.Promise.resolve()
            })
      }
    }
    None
  }, [isItemIdValid])

  React.useEffect1(() => {
    switch itemId {
    | Some(val) => {
        let _ =
          Fetchers.fetchDimensions(~itemId=val)->Js.Promise.then_(dimensionsJson => {
            let parsedValue: option<Dimension.State.dimensionResponse> = Some(
              Obj.magic(dimensionsJson),
            )
            switch parsedValue {
            | Some(parsed) => {
                parsed.margin
                ->Dimension.State.normalizeDimensionResponse
                ->Initialize
                ->marginDispatch
                parsed.padding
                ->Dimension.State.normalizeDimensionResponse
                ->Initialize
                ->paddingDispatch
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
    | Some(id)
      if Dimension.State.checkHasChanged(marginState) ||
      Dimension.State.checkHasChanged(paddingState) => {
        let _ =
          Fetchers.updateDimensions(
            ~itemId=id,
            ~marginState,
            ~paddingState,
          )->Js.Promise.then_(_ => {
            SaveRemote->marginDispatch
            SaveRemote->paddingDispatch
            Js.Promise.resolve()
          }, _)
            |> Js.Promise.catch(_ => {
              Js.Console.error("Error fetching")
              Js.Promise.resolve()
            })
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
