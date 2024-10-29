@react.component
let make = (
  ~name: string,
  ~value: Dimension.State.measurementValue,
  ~onValueChange,
  ~unit: Dimension.State.measurementUnit,
  ~onUnitChange,
  ~remoteSaved: bool,
) => {
  let (isSelectOpen, setIsSelectOpen) = React.useState(() => false)
  let (selectShown, setSelectShown) = React.useState(() => value != 0)
  let handleFocus = event => {
    (event->ReactEvent.Focus.target)["select"](.)
    setSelectShown(_ => true)
  }

  let hideSelect = e => {
    let val = (e->ReactEvent.Focus.currentTarget)["value"]
    switch val {
    | Some(_) if val != "" => ()
    | _ => setSelectShown(_ => false)
    }
  }
  React.useEffect1(() => {
    setSelectShown(_ => value != 0)
    None
  }, [value])

  <div className={`input-group ${isSelectOpen ? "select-open" : ""}`}>
    <input
      name
      type_="number"
      placeholder="auto"
      className={!remoteSaved && selectShown ? "dirty-input" : ""}
      value={value != 0 ? value->Belt.Int.toString : ""}
      onInput={e => onValueChange(e)}
      onFocus={handleFocus}
      onBlur={hideSelect}
    />
    <Select name isSelectOpen setIsSelectOpen unit onUnitChange selectShown />
    // <select>
    //   <option>{React.string("pt")}</option>
    //   <option>{React.string("px")}</option>
    // </select>
  </div>
}
