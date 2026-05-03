export type PageSizeName = "letter";

export type PageSettings = {
  sizeName: PageSizeName;
  widthPt: number;
  heightPt: number;
  backgroundColor: string;
};

export type FlyerProject = {
  version: 1;
  id: string;
  name: string;
  page: PageSettings;
  elements: FlyerElement[];
  createdAt: string;
  updatedAt: string;
};

export type BaseElement = {
  id: string;
  x: number;
  y: number;
  width: number;
  height: number;
  rotation: number;
  zIndex: number;
  opacity: number;
};

export type TextElement = BaseElement & {
  type: "text";
  content: string;
  fontFamily: string;
  fontSize: number;
  fontWeight: "normal" | "bold";
  fontStyle: "normal" | "italic";
  underline: boolean;
  color: string;
  backgroundColor: string;
  textAlign: "left" | "center" | "right";
  lineHeight: number;
  curve?: number;
};

export type ImageElement = BaseElement & {
  type: "image";
  src: string;
  name?: string;
  alt?: string;
  borderRadius: number;
  borderColor: string;
  borderWidth: number;
};

export type ShapeElement = BaseElement & {
  type: "shape";
  shapeKind: "rectangle" | "ellipse" | "line";
  fillColor: string;
  strokeColor: string;
  strokeWidth: number;
  borderRadius?: number;
};

export type FlyerElement = TextElement | ImageElement | ShapeElement;

// Helper to determine element type
export const isTextElement = (el: FlyerElement): el is TextElement => el.type === "text";
export const isImageElement = (el: FlyerElement): el is ImageElement => el.type === "image";
export const isShapeElement = (el: FlyerElement): el is ShapeElement => el.type === "shape";
