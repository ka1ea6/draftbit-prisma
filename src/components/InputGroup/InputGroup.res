@react.component
let make = (
  ~name: string,
  ~value: Margin.State.measurementValue,
  ~onValueChange,
  ~unit: Margin.State.measurementUnit,
  ~onUnitChange,
  ~initialValue: Margin.State.measurementValue,
) => {
  let (isSelectOpen, setIsSelectOpen) = React.useState(() => false)
  let handleFocus = event => {
    (event->ReactEvent.Focus.target)["select"](.)
  }

  <div className={`input-group ${isSelectOpen ? "select-open" : ""}`}>
    <input
      name
      type_="number"
      className={initialValue == value ? "" : "dirty-input"}
      value={value->Belt.Int.toString}
      onInput={e => onValueChange(e)}
      onFocus={handleFocus}
    />
    <Select
      options={[
        {displayName: "pt", value: "pt"},
        {displayName: "px", value: "px"},
        {displayName: "pm", value: "pm"},
      ]}
      isSelectOpen
      setIsSelectOpen
      unit
      onUnitChange
    />
    // <select>
    //   <option>{React.string("pt")}</option>
    //   <option>{React.string("px")}</option>
    // </select>
  </div>
}
