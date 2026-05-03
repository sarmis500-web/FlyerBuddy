import React, { useState } from "react";
import { useEditor } from "../features/editor/EditorContext";
import FlyerPage from "./FlyerPage";

const Workspace = () => {
  const { state, dispatch } = useEditor();
  const [zoom, setZoom] = useState(1);

  const handleZoomIn = () => setZoom((z) => Math.min(z + 0.25, 3));
  const handleZoomOut = () => setZoom((z) => Math.max(z - 0.25, 0.25));
  const handleFitPage = () => setZoom(1); // Basic for now

  return (
    <div className="absolute inset-0 flex flex-col">
      {/* Zoom Controls */}
      <div className="absolute bottom-4 left-4 z-10 flex space-x-2 bg-white p-2 rounded shadow no-print">
        <button onClick={handleZoomOut} className="px-2 py-1 bg-gray-100 hover:bg-gray-200 rounded">-</button>
        <div className="px-2 py-1 text-sm flex items-center">{Math.round(zoom * 100)}%</div>
        <button onClick={handleZoomIn} className="px-2 py-1 bg-gray-100 hover:bg-gray-200 rounded">+</button>
        <button onClick={handleFitPage} className="px-2 py-1 text-sm bg-gray-100 hover:bg-gray-200 rounded">Fit</button>
      </div>

      {/* Canvas */}
      <div 
        className="editor-canvas-container flex-1"
        onClick={() => dispatch({ type: "SELECT_ELEMENT", payload: null })} // Deselect when clicking canvas background
      >
        <div 
          style={{
            transform: `scale(${zoom})`,
            transformOrigin: "center center",
            transition: "transform 0.2s ease-in-out"
          }}
        >
          <FlyerPage zoomScale={zoom} />
        </div>
      </div>
    </div>
  );
};

export default Workspace;
