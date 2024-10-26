%%raw("import './Prism.css'")

@react.component
let make = () => {
  let testStr2 = React.string("auto")

  let (marginState, marginDispatch) = React.useReducer(
    Margin.State.reducer,
    Margin.State.initialValue,
  )

  <div className="prism-container">
    <div className="prism-top-row">
      <InputGroup
        initialValue=Margin.State.initialValue.top.value
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
        initialValue=Margin.State.initialValue.left.value
        name="ml"
        onValueChange={e =>
          marginDispatch(
            AlterValue(Left, ReactEvent.Form.currentTarget(e)["value"], marginState.left.unit),
          )}
        value={marginState.left.value}
        unit={marginState.left.unit}
        onUnitChange={option => marginDispatch(AlterValue(Left, marginState.left.value, option))}
      />
      <div className="prism-inner-box">
        <div> <span> testStr2 </span> </div>
        <div> <span> testStr2 </span> <span> testStr2 </span> </div>
        <div> <span> testStr2 </span> </div>
      </div>
      <InputGroup
        initialValue=Margin.State.initialValue.right.value
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
        initialValue=Margin.State.initialValue.bottom.value
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
