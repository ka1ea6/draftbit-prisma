%%raw("import './Prism.css'")


type marginState = {top: string, right: string, bottom: string, left: string}
type paddingState = {top: string, right: string, bottom: string, left: string}


type marginAction = AlterTop(string) | AlterRight(string) | AlterBottom(string) | AlterLeft(string)

type direction = Top | Right | Bottom | Left

let marginReducer = (marginState, marginAction) => {
  switch marginAction {
    | AlterTop(value) => {...marginState, top: value}
    | AlterRight(value) => {...marginState, right: value}
    | AlterBottom(value) => {...marginState, bottom: value}
    | AlterLeft(value) => {...marginState, left: value}
  }
} 


let initialMarginValue = {top: "0", right: "0", bottom: "0", left: "0"}

@react.component
let make = () => {
  let testStr2 = React.string("auto")

  let (marginState, marginDispatch) = React.useReducer(marginReducer, initialMarginValue)

  let onMarginChange = (event, direction) => {
    let value = ReactEvent.Form.currentTarget(event)["value"]
    switch direction {
      | Top =>   marginDispatch(AlterTop(string_of_int(value)))
      | Right => marginDispatch(AlterRight(string_of_int(value)))
      | Bottom => marginDispatch(AlterBottom(string_of_int(value)))
      | Left => marginDispatch(AlterLeft(string_of_int(value))) 
    }
    // Js.Console.log(`val ${parsed}`)

  }


  <div className="prism-container">
    <div className="prism-top-row">
      <InputGroup initialValue=initialMarginValue.top name="mt" onValueChange={e => onMarginChange(e, Top)} value={marginState.top} />
    </div>
    <div className="prism-middle-row">
      <InputGroup initialValue=initialMarginValue.left name="ml" onValueChange={e => onMarginChange(e, Left)} value={marginState.left} />
      <div className="prism-inner-box">
        <div>
          <span>testStr2</span>
        </div>
        <div>
          <span>testStr2</span>
          <span>testStr2</span>
        </div>
        <div>
          <span>testStr2</span>
        </div>        
      </div>
        <InputGroup initialValue=initialMarginValue.right name="mr" onValueChange={e => onMarginChange(e, Right)} value={marginState.right} />
    </div>
    <div className="prism-bottom-row">
      <InputGroup initialValue=initialMarginValue.bottom name="mb" onValueChange={e => onMarginChange(e, Bottom)} value={marginState.bottom} />
    </div>
  </div>
}
