type DimensionsUnit = "pt" | "px";
type Dimensions = {
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
    },
  };
};
