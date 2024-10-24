@react.component
let make = (~name: string, ~value: string, ~onValueChange,~initialValue="0") => {
  let (isSelectOpen, setIsSelectOpen) = React.useState(() => false)
  let handleFocus = (event) => {    
    (event->ReactEvent.Focus.target)["select"](.)
  }


  <div className={`input-group ${isSelectOpen ? "select-open" : ""}`}>
      <input name=name type_="number" className={initialValue ==  value ? "" : "dirty-input"} value={value} onInput={onValueChange} onFocus={handleFocus}  />
      <Select options={[{displayName: "pt",value: "pt"}, {displayName: "px", value: "px"}, {displayName: "pm", value: "pm"}]} isSelectOpen setIsSelectOpen />
      // <select>
      //   <option>{React.string("pt")}</option>
      //   <option>{React.string("px")}</option>
      // </select>
  </div>

}