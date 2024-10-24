%%raw("import './Select.css'")

type selectOptionValue = string

type selectOption = {
  displayName: string,
  value: selectOptionValue
}

@react.component
let make = (~options: array<selectOption>, ~isSelectOpen: bool, ~setIsSelectOpen: (bool => bool) => unit) => {

  let (selectedItem, setSelectedItem) = React.useState(() => options[0].value)

  React.useEffect(() => {
    let handleClick = (_) => {
      setIsSelectOpen(_ => false)
    }
    

    Webapi.Dom.window->Webapi.Dom.Window.addEventListener("click",handleClick)
    Some(() => Webapi.Dom.window->Webapi.Dom.Window.removeEventListener("click", handleClick))    
  })

  <div>
    <div>
      <select className="hidden">
        {         
          options
          ->Js.Array2.map(option =><option value=option.value>{React.string(`${option.displayName}`)}</option>
            )
          ->React.array
        }   
      </select>
    </div>
    <div className="dropdown-container">
      <button onClick={_ => setIsSelectOpen(_ => true)} >{React.string(selectedItem)}</button>
      <ul className={isSelectOpen ? "dropdown-open" : "dropdown-close"}>
      {         
          options
          ->Js.Array2.map(option =><li value=option.value><button onClick={_e => {
            setSelectedItem(_ => option.value)
            setIsSelectOpen(_ => false)
            }}>{React.string(`${option.displayName}`)}</button></li>
            )
          ->React.array
        }   
      </ul>
    </div>
  </div>
}