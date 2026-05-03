import React from "react";
import { Rnd } from "react-rnd";
import type { FlyerElement } from "../features/editor/editorTypes";
import { useEditor } from "../features/editor/EditorContext";

interface RndElementWrapperProps {
  element: FlyerElement;
  zoomScale: number;
  isSelected: boolean;
  children: React.ReactNode;
}

const RndElementWrapper: React.FC<RndElementWrapperProps> = ({
  element,
  zoomScale,
  isSelected,
  children,
}) => {
  const { dispatch } = useEditor();

  return (
    <Rnd
      size={{ width: element.width, height: element.height }}
      position={{ x: element.x, y: element.y }}
      scale={zoomScale}
      bounds="parent" // Keep within the letter page
      className={`absolute ${isSelected ? "ring-2 ring-blue-500 z-50" : ""}`}
      style={{
        zIndex: element.zIndex,
        opacity: element.opacity,
        transform: `translate(${element.x}px, ${element.y}px) rotate(${element.rotation}deg)`,
      }}
      onDragStart={() => dispatch({ type: "SELECT_ELEMENT", payload: element.id })}
      onDragStop={(e, d) => {
        dispatch({
          type: "UPDATE_ELEMENT",
          payload: { id: element.id, updates: { x: d.x, y: d.y } },
        });
      }}
      onResizeStart={() => dispatch({ type: "SELECT_ELEMENT", payload: element.id })}
      onResizeStop={(e, direction, ref, delta, position) => {
        dispatch({
          type: "UPDATE_ELEMENT",
          payload: {
            id: element.id,
            updates: {
              width: parseInt(ref.style.width, 10),
              height: parseInt(ref.style.height, 10),
              ...position,
            },
          },
        });
      }}
      // Print specific styling to remove rnd wrappers in print mode
      // or just ensure they render as simple divs during print
      disableDragging={false} // Would disable during print if we wanted, but we use CSS for print
      enableResizing={isSelected} // Only show resize handles if selected
    >
      <div 
        className="w-full h-full cursor-move overflow-hidden"
        onMouseDown={(e) => {
          e.stopPropagation();
          dispatch({ type: "SELECT_ELEMENT", payload: element.id });
        }}
      >
        {children}
      </div>
    </Rnd>
  );
};

export default RndElementWrapper;
