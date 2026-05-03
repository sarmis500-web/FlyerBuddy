export const LETTER_WIDTH_PT = 612;
export const LETTER_HEIGHT_PT = 792;
export const POINTS_PER_INCH = 72;

/**
 * Convert points to inches
 */
export const ptToInch = (pt: number): number => {
  return pt / POINTS_PER_INCH;
};

/**
 * Convert inches to points
 */
export const inchToPt = (inch: number): number => {
  return inch * POINTS_PER_INCH;
};

/**
 * Calculate the pixel size of an element based on the current zoom scale
 */
export const ptToPx = (pt: number, scale: number): number => {
  return pt * scale;
};

/**
 * Calculate points from screen pixels and zoom scale
 */
export const pxToPt = (px: number, scale: number): number => {
  return px / scale;
};
