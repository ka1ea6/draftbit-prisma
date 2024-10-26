module State = {
  type measurementUnit = Pt | Px
  type measurementValue = int
  type side = Top | Right | Bottom | Left

  type measurement = {
    value: measurementValue,
    unit: measurementUnit,
  }

  type t = {
    top: measurement,
    right: measurement,
    bottom: measurement,
    left: measurement,
  }

  type actions = AlterValue(side, measurementValue, measurementUnit)

  let initialValue = {
    top: {value: 0, unit: Pt},
    right: {value: 0, unit: Pt},
    bottom: {value: 0, unit: Pt},
    left: {value: 0, unit: Pt},
  }

  let reducer = (state, action) => {
    switch action {
    | AlterValue(side, value, unit) =>
      switch side {
      | Top => {...state, top: {value: value, unit: unit}}
      | Right => {...state, right: {value: value, unit: unit}}
      | Bottom => {...state, bottom: {value: value, unit: unit}}
      | Left => {...state, left: {value: value, unit: unit}}
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
}
