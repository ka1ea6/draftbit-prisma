%%raw("import './Select.css'")

type selectOptionValue = string

type selectOption = {
  displayName: string,
  value: selectOptionValue,
}

@react.component
let make = (
  ~name: string,
  ~isSelectOpen: bool,
  ~setIsSelectOpen: (bool => bool) => unit,
  ~unit: Dimension.State.measurementUnit,
  ~onUnitChange,
) => {
  React.useEffect(() => {
    let handleClick = e => {
      let target = e->Webapi.Dom.Event.target
      let closestDropdownContainer =
        target
        ->Webapi.Dom.EventTarget.unsafeAsElement
        ->Webapi.Dom.Element.closest(`.dropdown-container#${name}`)

      switch closestDropdownContainer {
      | Some(_) => ()
      | None => setIsSelectOpen(_ => false)
      }
    }

    Webapi.Dom.window->Webapi.Dom.Window.addEventListener("click", handleClick)
    Some(() => Webapi.Dom.window->Webapi.Dom.Window.removeEventListener("click", handleClick))
  })

  <div>
    <div>
      <select className="hidden">
        {Dimension.State.allUnits
        ->Js.Array2.map(option =>
          <option
            value={option->Dimension.State.measurementUnitToString}
            key={option->Dimension.State.measurementUnitToString}>
            {option->Dimension.State.measurementUnitToString->React.string}
          </option>
        )
        ->React.array}
      </select>
    </div>
    <div className="dropdown-container" id=name>
      <button onClick={_ => setIsSelectOpen(_ => true)}>
        {unit->Dimension.State.measurementUnitToString->React.string}
      </button>
      <ul className={isSelectOpen ? "dropdown-open" : "dropdown-close"}>
        {Dimension.State.allUnits
        ->Js.Array2.map(option =>
          <li
            value={option->Dimension.State.measurementUnitToString}
            key={option->Dimension.State.measurementUnitToString}>
            <button
              onClick={_e => {
                onUnitChange(option)
                setIsSelectOpen(_ => false)
              }}>
              {React.string(option->Dimension.State.measurementUnitToString)}
            </button>
          </li>
        )
        ->React.array}
      </ul>
    </div>
  </div>
}
