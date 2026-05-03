import React from "react";
import { v4 as uuidv4 } from "uuid";
import { useEditor } from "../features/editor/EditorContext";
import type { TextElement, ImageElement, ShapeElement } from "../features/editor/editorTypes";

const LeftToolbar = () => {
  const { state, dispatch } = useEditor();

  const addText = () => {
    const el: TextElement = {
      id: uuidv4(),
      type: "text",
      content: "Double click to edit text",
      fontFamily: "Arial, sans-serif",
      fontSize: 32,
      fontWeight: "normal",
      fontStyle: "normal",
      underline: false,
      color: "#000000",
      backgroundColor: "transparent",
      textAlign: "left",
      lineHeight: 1.2,
      x: 100,
      y: 100,
      width: 300,
      height: 100,
      rotation: 0,
      zIndex: state.project.elements.length,
      opacity: 1,
    };
    dispatch({ type: "ADD_ELEMENT", payload: el });
  };

  const addShape = (shapeKind: ShapeElement["shapeKind"]) => {
    const el: ShapeElement = {
      id: uuidv4(),
      type: "shape",
      shapeKind,
      fillColor: shapeKind === "line" ? "transparent" : "#3b82f6",
      strokeColor: shapeKind === "line" ? "#000000" : "transparent",
      strokeWidth: shapeKind === "line" ? 2 : 0,
      borderRadius: shapeKind === "rectangle" ? 0 : undefined,
      x: 100,
      y: 200,
      width: 200,
      height: shapeKind === "line" ? 2 : 200,
      rotation: 0,
      zIndex: state.project.elements.length,
      opacity: 1,
    };
    dispatch({ type: "ADD_ELEMENT", payload: el });
  };

  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (event) => {
      const src = event.target?.result as string;
      const el: ImageElement = {
        id: uuidv4(),
        type: "image",
        src,
        name: file.name,
        borderRadius: 0,
        borderColor: "transparent",
        borderWidth: 0,
        x: 100,
        y: 100,
        width: 300,
        height: 300, // Will be updated if we implement aspect ratio preservation
        rotation: 0,
        zIndex: state.project.elements.length,
        opacity: 1,
      };
      dispatch({ type: "ADD_ELEMENT", payload: el });
    };
    reader.readAsDataURL(file);
    e.target.value = ""; // Reset file input
  };

  return (
    <div className="flex flex-col p-4 space-y-4">
      <div className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">Add</div>
      <button onClick={addText} className="flex items-center space-x-2 text-sm text-gray-700 hover:text-blue-600">
        <span>Text</span>
      </button>
      
      <label className="flex items-center space-x-2 text-sm text-gray-700 hover:text-blue-600 cursor-pointer">
        <span>Image</span>
        <input type="file" accept="image/*" className="hidden" onChange={handleImageUpload} />
      </label>
      
      <button onClick={() => addShape("rectangle")} className="flex items-center space-x-2 text-sm text-gray-700 hover:text-blue-600">
        <span>Rectangle</span>
      </button>
      <button onClick={() => addShape("ellipse")} className="flex items-center space-x-2 text-sm text-gray-700 hover:text-blue-600">
        <span>Circle</span>
      </button>
      <button onClick={() => addShape("line")} className="flex items-center space-x-2 text-sm text-gray-700 hover:text-blue-600">
        <span>Line</span>
      </button>
      <div className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 mt-6">Templates</div>
      <button onClick={() => {
        if (confirm("Replace current flyer with Print Test Template?")) {
          dispatch({
            type: "SET_PROJECT",
            payload: {
              ...state.project,
              elements: [
                {
                  id: uuidv4(),
                  type: "shape",
                  shapeKind: "rectangle",
                  fillColor: "transparent",
                  strokeColor: "#ff0000",
                  strokeWidth: 4,
                  x: 36, // 0.5 inch safe margin
                  y: 36,
                  width: 612 - 72,
                  height: 792 - 72,
                  rotation: 0,
                  zIndex: 0,
                  opacity: 1,
                },
                {
                  id: uuidv4(),
                  type: "text",
                  content: "8.5 x 11 Letter - Safe Margin Guide",
                  fontFamily: "Arial, sans-serif",
                  fontSize: 24,
                  fontWeight: "bold",
                  fontStyle: "normal",
                  underline: false,
                  color: "#ff0000",
                  backgroundColor: "transparent",
                  textAlign: "center",
                  lineHeight: 1.2,
                  x: 100,
                  y: 350,
                  width: 412,
                  height: 100,
                  rotation: 0,
                  zIndex: 1,
                  opacity: 1,
                }
              ]
            }
          });
        }
      }} className="flex items-center space-x-2 text-sm text-gray-700 hover:text-blue-600">
        <span>Print Test Page</span>
      </button>
    </div>
  );
};

export default LeftToolbar;
