import React, { useRef } from "react";
import { useEditor } from "../features/editor/EditorContext";
import { v4 as uuidv4 } from "uuid";
import { exportProjectJSON } from "../features/storage/storageUtils";
import { createEmptyProject } from "../features/editor/editorReducer";
import type { FlyerProject } from "../features/editor/editorTypes";

const TopBar = () => {
  const { state, dispatch } = useEditor();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const selectedElement = state.project.elements.find(el => state.selectedElementIds.includes(el.id));

  const handleDuplicate = () => {
    if (!selectedElement) return;
    const newEl = {
      ...selectedElement,
      id: uuidv4(),
      x: selectedElement.x + 20,
      y: selectedElement.y + 20,
      zIndex: state.project.elements.length,
    };
    dispatch({ type: "ADD_ELEMENT", payload: newEl });
    dispatch({ type: "SELECT_ELEMENT", payload: newEl.id });
  };

  const handlePrint = () => {
    window.print();
  };

  const handleNew = () => {
    if (confirm("Are you sure you want to clear the current flyer?")) {
      dispatch({ type: "SET_PROJECT", payload: createEmptyProject() });
    }
  };

  const handleSave = () => {
    exportProjectJSON(state.project);
  };

  const handleLoadClick = () => {
    fileInputRef.current?.click();
  };

  const handleLoadFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (event) => {
      try {
        const json = event.target?.result as string;
        const project = JSON.parse(json) as FlyerProject;
        if (project.version === 1 && project.elements) {
          dispatch({ type: "SET_PROJECT", payload: project });
        } else {
          alert("Invalid FlyerBuddy project file.");
        }
      } catch (err) {
        alert("Could not load that project file.");
      }
    };
    reader.readAsText(file);
    e.target.value = "";
  };

  return (
    <div className="flex items-center justify-between px-4 h-full">
      <div className="font-semibold text-lg flex items-center space-x-4">
        <span>FlyerBuddy</span>
        <span className="text-sm text-gray-400 font-normal">{state.project.name}</span>
      </div>
      <div className="flex space-x-4">
        <div className="flex space-x-1 border-r pr-4">
          <button onClick={handleNew} className="px-3 py-1 bg-gray-100 rounded hover:bg-gray-200">New</button>
          <button onClick={handleSave} className="px-3 py-1 bg-gray-100 rounded hover:bg-gray-200">Save</button>
          <button onClick={handleLoadClick} className="px-3 py-1 bg-gray-100 rounded hover:bg-gray-200">Load</button>
          <input type="file" accept=".json" className="hidden" ref={fileInputRef} onChange={handleLoadFile} />
        </div>

        <div className="flex space-x-1 border-r pr-4">
          <button onClick={() => dispatch({ type: "UNDO" })} disabled={state.historyIndex < 0} className="px-3 py-1 bg-gray-100 rounded hover:bg-gray-200 disabled:opacity-50">Undo</button>
          <button onClick={() => dispatch({ type: "REDO" })} disabled={state.historyIndex >= state.history.length - 1} className="px-3 py-1 bg-gray-100 rounded hover:bg-gray-200 disabled:opacity-50">Redo</button>
        </div>
        
        <div className="flex space-x-1 border-r pr-4">
          <button onClick={handleDuplicate} disabled={!selectedElement} className="px-3 py-1 bg-gray-100 rounded hover:bg-gray-200 disabled:opacity-50">Duplicate</button>
          <button onClick={() => selectedElement && dispatch({ type: "BRING_FORWARD", payload: selectedElement.id })} disabled={!selectedElement} className="px-3 py-1 bg-gray-100 rounded hover:bg-gray-200 disabled:opacity-50">Bring Forward</button>
          <button onClick={() => selectedElement && dispatch({ type: "SEND_BACKWARD", payload: selectedElement.id })} disabled={!selectedElement} className="px-3 py-1 bg-gray-100 rounded hover:bg-gray-200 disabled:opacity-50">Send Backward</button>
          <button onClick={() => selectedElement && dispatch({ type: "DELETE_ELEMENT", payload: selectedElement.id })} disabled={!selectedElement} className="px-3 py-1 bg-red-100 text-red-700 rounded hover:bg-red-200 disabled:opacity-50">Delete</button>
        </div>

        <button onClick={handlePrint} className="px-4 py-1 bg-blue-500 text-white rounded hover:bg-blue-600 font-medium shadow-sm">Print / Save as PDF</button>
      </div>
    </div>
  );
};

export default TopBar;
