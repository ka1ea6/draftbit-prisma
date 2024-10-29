@react.component
let make = (
  ~paddingState: Dimension.State.t,
  ~paddingDispatch: Dimension.State.actions => unit,
) => {
  <>
    <div>
      <InputGroup
        remoteSaved=paddingState.top.remoteSaved
        name="pt"
        onValueChange={e =>
          paddingDispatch(
            AlterValue(Top, ReactEvent.Form.currentTarget(e)["value"], paddingState.top.unit),
          )}
        value={paddingState.top.value}
        unit={paddingState.top.unit}
        onUnitChange={option => paddingDispatch(AlterValue(Top, paddingState.top.value, option))}
      />
    </div>
    <div>
      <InputGroup
        remoteSaved=paddingState.left.remoteSaved
        name="pl"
        onValueChange={e =>
          paddingDispatch(
            AlterValue(Left, ReactEvent.Form.currentTarget(e)["value"], paddingState.left.unit),
          )}
        value={paddingState.left.value}
        unit={paddingState.left.unit}
        onUnitChange={option => paddingDispatch(AlterValue(Left, paddingState.left.value, option))}
      />
      <InputGroup
        remoteSaved=paddingState.right.remoteSaved
        name="pr"
        onValueChange={e =>
          paddingDispatch(
            AlterValue(Right, ReactEvent.Form.currentTarget(e)["value"], paddingState.right.unit),
          )}
        value={paddingState.right.value}
        unit={paddingState.right.unit}
        onUnitChange={option =>
          paddingDispatch(AlterValue(Right, paddingState.right.value, option))}
      />
    </div>
    <div>
      <InputGroup
        remoteSaved=paddingState.bottom.remoteSaved
        name="pb"
        onValueChange={e =>
          paddingDispatch(
            AlterValue(Bottom, ReactEvent.Form.currentTarget(e)["value"], paddingState.bottom.unit),
          )}
        value={paddingState.bottom.value}
        unit={paddingState.bottom.unit}
        onUnitChange={option =>
          paddingDispatch(AlterValue(Bottom, paddingState.bottom.value, option))}
      />
    </div>
  </>
}
