import React from "react";
import FlyerPage from "../components/FlyerPage";
import flyerData from "../../mexican_grocery_flyer.flyerbuddy.json";
import { EditorProvider } from "../features/editor/EditorContext";

// A simplified preview component that loads the JSON directly from disk
const Preview = () => {
  return (
    <EditorProvider>
      <div className="min-h-screen bg-gray-100 flex items-center justify-center p-8">
        <FlyerPage zoomScale={1} projectOverride={flyerData} />
      </div>
    </EditorProvider>
  );
};

export default Preview;
