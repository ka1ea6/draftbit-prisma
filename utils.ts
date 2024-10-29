export type DimensionsUnit = "pt" | "px";
export type Dimensions = {
  margin_top: number;
  margin_top_unit: DimensionsUnit;
  margin_right: number;
  margin_right_unit: DimensionsUnit;
  margin_bottom: number;
  margin_bottom_unit: DimensionsUnit;
  margin_left: number;
  margin_left_unit: DimensionsUnit;
  padding_top: number;
  padding_top_unit: DimensionsUnit;
  padding_right: number;
  padding_right_unit: DimensionsUnit;
  padding_bottom: number;
  padding_bottom_unit: DimensionsUnit;
  padding_left: number;
  padding_left_unit: DimensionsUnit;
};

export type ParsedDimensions = {
  margin: {
    top: { value: number; unit: DimensionsUnit };
    right: { value: number; unit: DimensionsUnit };
    bottom: { value: number; unit: DimensionsUnit };
    left: { value: number; unit: DimensionsUnit };
  };
  padding: {
    top: { value: number; unit: DimensionsUnit };
    right: { value: number; unit: DimensionsUnit };
    bottom: { value: number; unit: DimensionsUnit };
    left: { value: number; unit: DimensionsUnit };
  };
};

export const mapDimensions = (dimensions: Dimensions) => {
  return {
    margin: {
      top: {
        value: dimensions.margin_top,
        unit: dimensions.margin_top_unit,
      },
      right: {
        value: dimensions.margin_right,
        unit: dimensions.margin_right_unit,
      },
      bottom: {
        value: dimensions.margin_bottom,
        unit: dimensions.margin_bottom_unit,
      },
      left: {
        value: dimensions.margin_left,
        unit: dimensions.margin_left_unit,
      },
    },
    padding: {
      top: {
        value: dimensions.padding_top,
        unit: dimensions.padding_top_unit,
      },
      right: {
        value: dimensions.padding_right,
        unit: dimensions.padding_right_unit,
      },
      bottom: {
        value: dimensions.padding_bottom,
        unit: dimensions.padding_bottom_unit,
      },
      left: {
        value: dimensions.padding_left,
        unit: dimensions.padding_left_unit,
      },
    },
  };
};

export const getChangedDimensions = (dimension: ParsedDimensions) => {
  const changedItems: Partial<Dimensions> = {};
  for (let type of Object.keys(dimension)) {
    // type = margin | padding
    if (!["margin", "padding"].includes(type)) continue;

    for (let side of Object.keys(dimension[type])) {
      // side = top | right | bottom | left
      if (!["top", "right", "bottom", "left"].includes(side)) continue;

      for (let attribute of Object.keys(dimension[type][side])) {
        // attribute = value | unit

        // check to see if we got the correct values
        if (!["value", "unit"].includes(attribute)) continue;

        const itemKey = `${type}_${side}${
          attribute === "unit" ? `_${attribute}` : ""
        }`;
        changedItems[itemKey] =
          attribute === "value"
            ? parseInt(dimension[type][side][attribute])
            : dimension[type][side][attribute];
      }
    }
  }

  return changedItems;
};
