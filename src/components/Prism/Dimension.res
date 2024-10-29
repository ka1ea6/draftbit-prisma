module State = {
  type measurementUnit = Pt | Px
  type measurementValue = int
  type side = Top | Right | Bottom | Left

  type measurement = {
    value: measurementValue,
    unit: measurementUnit,
    remoteSaved: bool,
  }

  type t = {
    top: measurement,
    right: measurement,
    bottom: measurement,
    left: measurement,
  }

  type actions = AlterValue(side, measurementValue, measurementUnit) | Initialize(t) | SaveRemote

  let initialValue = {
    top: {value: 0, unit: Pt, remoteSaved: true},
    right: {value: 0, unit: Pt, remoteSaved: true},
    bottom: {value: 0, unit: Pt, remoteSaved: true},
    left: {value: 0, unit: Pt, remoteSaved: true},
  }

  let reducer = (state, action) => {
    switch action {
    | Initialize(t) => t
    | AlterValue(side, value, unit) =>
      switch side {
      | Top => {...state, top: {value: value, unit: unit, remoteSaved: false}}
      | Right => {...state, right: {value: value, unit: unit, remoteSaved: false}}
      | Bottom => {...state, bottom: {value: value, unit: unit, remoteSaved: false}}
      | Left => {...state, left: {value: value, unit: unit, remoteSaved: false}}
      }
    | SaveRemote => {
        top: {...state.top, remoteSaved: true},
        right: {...state.right, remoteSaved: true},
        bottom: {...state.bottom, remoteSaved: true},
        left: {...state.left, remoteSaved: true},
      }
    }
  }

  let allUnits: array<measurementUnit> = [Pt, Px]

  let measurementUnitToString = (unit: measurementUnit) => {
    switch unit {
    | Px => "px"
    | Pt => "pt"
    }
  }

  let stringToMeasurementUnit = (unit: string) => {
    switch unit->Js.String.toLowerCase {
    | "px" => Px
    | _ => Pt
    }
  }
}
