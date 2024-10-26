%%raw("import './Select.css'")

type selectOptionValue = string

type selectOption = {
  displayName: string,
  value: selectOptionValue,
}

@react.component
let make = (
  ~options: array<selectOption>,
  ~isSelectOpen: bool,
  ~setIsSelectOpen: (bool => bool) => unit,
  ~unit: Margin.State.measurementUnit,
  ~onUnitChange,
) => {
  // React.useEffect(() => {
  //   let handleClick = _ => {
  //     setIsSelectOpen(_ => false)
  //   }

  //   Webapi.Dom.window->Webapi.Dom.Window.addEventListener("click", handleClick)
  //   Some(() => Webapi.Dom.window->Webapi.Dom.Window.removeEventListener("click", handleClick))
  // })

  <div>
    <div>
      <select className="hidden">
        {options
        ->Js.Array2.map(option =>
          <option value=option.value key={option.value}>
            {React.string(option.displayName)}
          </option>
        )
        ->React.array}
      </select>
    </div>
    <div className="dropdown-container">
      <button onClick={_ => setIsSelectOpen(_ => true)}>
        {unit->Margin.State.measurementUnitToString->React.string}
      </button>
      <ul className={isSelectOpen ? "dropdown-open" : "dropdown-close"}>
        {Margin.State.allUnits
        ->Js.Array2.map(option =>
          <li
            value={option->Margin.State.measurementUnitToString}
            key={option->Margin.State.measurementUnitToString}>
            <button
              onClick={_e => {
                onUnitChange(option)
                setIsSelectOpen(_ => false)
              }}>
              {React.string(option->Margin.State.measurementUnitToString)}
            </button>
          </li>
        )
        ->React.array}
      </ul>
    </div>
  </div>
}
