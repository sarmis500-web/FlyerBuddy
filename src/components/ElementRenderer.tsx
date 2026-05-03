import React from "react";
import type { FlyerElement } from "../features/editor/editorTypes";
import RndElementWrapper from "./RndElementWrapper";

interface ElementRendererProps {
  element: FlyerElement;
  zoomScale: number;
  isSelected: boolean;
}

const ElementRenderer: React.FC<ElementRendererProps> = ({ element, zoomScale, isSelected }) => {
  const renderContent = () => {
    switch (element.type) {
      case "text":
        return (
          <div
            style={{
              width: "100%",
              height: "100%",
              fontFamily: element.fontFamily,
              fontSize: `${element.fontSize}px`,
              fontWeight: element.fontWeight,
              fontStyle: element.fontStyle,
              textDecoration: element.underline ? "underline" : "none",
              color: element.color,
              backgroundColor: element.backgroundColor,
              textAlign: element.textAlign,
              lineHeight: element.lineHeight,
              display: "flex",
              flexDirection: "column",
              justifyContent: "flex-start",
              wordBreak: "break-word",
            }}
          >
            {element.content || "Double click to edit"}
          </div>
        );

      case "image":
        return (
          <img
            src={element.src}
            alt={element.alt || "Product"}
            className="element-shadow"
            style={{
              width: "100%",
              height: "100%",
              objectFit: "cover",
              borderRadius: `${element.borderRadius}px`,
              borderColor: element.borderColor,
              borderWidth: `${element.borderWidth}px`,
              borderStyle: element.borderWidth > 0 ? "solid" : "none",
            }}
            draggable={false}
          />
        );

      case "shape":
        if (element.shapeKind === "rectangle") {
          return (
            <div
              className={element.type === "shape" && element.id.includes("tag") ? "element-shadow" : ""}
              style={{
                width: "100%",
                height: "100%",
                backgroundColor: element.fillColor,
                borderColor: element.strokeColor,
                borderWidth: `${element.strokeWidth}px`,
                borderStyle: element.strokeWidth > 0 ? "solid" : "none",
                borderRadius: `${element.borderRadius || 0}px`,
              }}
            />
          );
        } else if (element.shapeKind === "ellipse") {
          return (
            <div
              style={{
                width: "100%",
                height: "100%",
                backgroundColor: element.fillColor,
                borderColor: element.strokeColor,
                borderWidth: `${element.strokeWidth}px`,
                borderStyle: element.strokeWidth > 0 ? "solid" : "none",
                borderRadius: "50%",
              }}
            />
          );
        } else if (element.shapeKind === "line") {
          return (
            <div
              style={{
                width: "100%",
                height: `${element.strokeWidth}px`,
                backgroundColor: element.strokeColor,
                position: "absolute",
                top: "50%",
                transform: "translateY(-50%)",
              }}
            />
          );
        }
        return null;

      default:
        return null;
    }
  };

  return (
    <RndElementWrapper element={element} zoomScale={zoomScale} isSelected={isSelected}>
      {renderContent()}
    </RndElementWrapper>
  );
};

export default ElementRenderer;
