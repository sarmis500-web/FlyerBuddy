import React from "react";
import { useEditor } from "../features/editor/EditorContext";
import ElementRenderer from "./ElementRenderer";

interface FlyerPageProps {
  zoomScale: number;
  projectOverride?: any;
}

const FlyerPage: React.FC<FlyerPageProps> = ({ zoomScale, projectOverride }) => {
  const { state } = useEditor();
  const project = projectOverride || state.project;
  const { widthPt, heightPt, backgroundColor } = project.page;
  const elements = project.elements;
  const selectedIds = projectOverride ? [] : state.selectedElementIds;


  return (
    <div 
      className="print-page bg-white relative mx-auto flyer-page-shadow"
      style={{
        width: `${widthPt}px`,
        height: `${heightPt}px`,
        backgroundColor,
      }}
      onClick={(e) => {
        // Prevent click from bubbling to workspace and deselecting
        e.stopPropagation();
      }}
    >
      {elements.map((el) => (
        <ElementRenderer 
          key={el.id} 
          element={el} 
          zoomScale={zoomScale}
          isSelected={selectedIds.includes(el.id)} 
        />
      ))}
      <div className="absolute inset-0 pointer-events-none border border-gray-100 no-print" />
    </div>
  );
};

export default FlyerPage;
