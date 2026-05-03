import React from "react";
import { useEditor } from "../features/editor/EditorContext";
import type { FlyerElement } from "../features/editor/editorTypes";

const ColorInput = ({ label, value, onChange, allowTransparent = true }: { label: string, value: string, onChange: (val: string) => void, allowTransparent?: boolean }) => {
  const isTransparent = value === "transparent";
  const hexValue = isTransparent ? "#ffffff" : value;

  return (
    <div>
      <label className="block text-xs font-semibold text-gray-500 uppercase mb-1">{label}</label>
      <div className="flex items-center space-x-2">
        <input
          type="color"
          value={hexValue}
          onChange={(e) => onChange(e.target.value)}
          className="flex-1 h-9 p-1 border border-gray-300 rounded"
          disabled={isTransparent && allowTransparent}
        />
        {allowTransparent && (
          <label className="flex items-center space-x-1 text-sm text-gray-600 whitespace-nowrap">
            <input 
              type="checkbox" 
              checked={isTransparent} 
              onChange={(e) => onChange(e.target.checked ? "transparent" : "#ffffff")} 
            />
            <span>None</span>
          </label>
        )}
      </div>
    </div>
  );
};

const Inspector = () => {
  const { state, dispatch } = useEditor();
  const selectedElement = state.project.elements.find((el) => state.selectedElementIds.includes(el.id));

  const updateElement = (updates: Partial<FlyerElement>) => {
    if (!selectedElement) return;
    dispatch({
      type: "UPDATE_ELEMENT",
      payload: { id: selectedElement.id, updates },
    });
  };

  const renderTextControls = () => {
    if (selectedElement?.type !== "text") return null;
    return (
      <div className="space-y-4">
        <div>
          <label className="block text-xs font-semibold text-gray-500 uppercase mb-1">Content</label>
          <textarea
            value={selectedElement.content}
            onChange={(e) => updateElement({ content: e.target.value })}
            className="w-full p-2 border border-gray-300 rounded text-sm"
            rows={3}
          />
        </div>
        <div>
          <label className="block text-xs font-semibold text-gray-500 uppercase mb-1">Font Size</label>
          <input
            type="number"
            value={selectedElement.fontSize}
            onChange={(e) => updateElement({ fontSize: Number(e.target.value) })}
            className="w-full p-2 border border-gray-300 rounded text-sm"
          />
        </div>
        <div className="grid grid-cols-2 gap-2">
          <ColorInput 
            label="Text Color" 
            value={selectedElement.color} 
            onChange={(v) => updateElement({ color: v })} 
            allowTransparent={false} 
          />
          <ColorInput 
            label="Background" 
            value={selectedElement.backgroundColor} 
            onChange={(v) => updateElement({ backgroundColor: v })} 
            allowTransparent={true} 
          />
        </div>
        <div className="flex space-x-2">
          <button
            onClick={() => updateElement({ fontWeight: selectedElement.fontWeight === "bold" ? "normal" : "bold" })}
            className={`flex-1 py-1 text-sm border rounded ${selectedElement.fontWeight === "bold" ? "bg-gray-200" : ""}`}
          >
            B
          </button>
          <button
            onClick={() => updateElement({ fontStyle: selectedElement.fontStyle === "italic" ? "normal" : "italic" })}
            className={`flex-1 py-1 text-sm border rounded ${selectedElement.fontStyle === "italic" ? "bg-gray-200" : ""}`}
          >
            I
          </button>
          <button
            onClick={() => updateElement({ underline: !selectedElement.underline })}
            className={`flex-1 py-1 text-sm border rounded ${selectedElement.underline ? "bg-gray-200" : ""}`}
          >
            U
          </button>
        </div>
        <div className="flex space-x-2">
          <button onClick={() => updateElement({ textAlign: "left" })} className={`flex-1 py-1 text-sm border rounded ${selectedElement.textAlign === "left" ? "bg-gray-200" : ""}`}>Left</button>
          <button onClick={() => updateElement({ textAlign: "center" })} className={`flex-1 py-1 text-sm border rounded ${selectedElement.textAlign === "center" ? "bg-gray-200" : ""}`}>Center</button>
          <button onClick={() => updateElement({ textAlign: "right" })} className={`flex-1 py-1 text-sm border rounded ${selectedElement.textAlign === "right" ? "bg-gray-200" : ""}`}>Right</button>
        </div>
      </div>
    );
  };

  const renderShapeControls = () => {
    if (selectedElement?.type !== "shape") return null;
    return (
      <div className="space-y-4">
        {selectedElement.shapeKind !== "line" && (
          <ColorInput 
            label="Fill Color" 
            value={selectedElement.fillColor} 
            onChange={(v) => updateElement({ fillColor: v })} 
            allowTransparent={true} 
          />
        )}
        <ColorInput 
          label="Stroke Color" 
          value={selectedElement.strokeColor} 
          onChange={(v) => updateElement({ strokeColor: v })} 
          allowTransparent={true} 
        />
        <div>
          <label className="block text-xs font-semibold text-gray-500 uppercase mb-1">Stroke Width</label>
          <input
            type="range"
            min="0"
            max="20"
            value={selectedElement.strokeWidth}
            onChange={(e) => updateElement({ strokeWidth: Number(e.target.value) })}
            className="w-full"
          />
        </div>
        {selectedElement.shapeKind === "rectangle" && (
          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase mb-1">Border Radius</label>
            <input
              type="range"
              min="0"
              max="100"
              value={selectedElement.borderRadius || 0}
              onChange={(e) => updateElement({ borderRadius: Number(e.target.value) })}
              className="w-full"
            />
          </div>
        )}
      </div>
    );
  };

  const renderImageControls = () => {
    if (selectedElement?.type !== "image") return null;
    return (
      <div className="space-y-4">
        <div>
          <label className="block text-xs font-semibold text-gray-500 uppercase mb-1">Border Radius</label>
          <input
            type="range"
            min="0"
            max="150"
            value={selectedElement.borderRadius}
            onChange={(e) => updateElement({ borderRadius: Number(e.target.value) })}
            className="w-full"
          />
        </div>
        <ColorInput 
          label="Border Color" 
          value={selectedElement.borderColor} 
          onChange={(v) => updateElement({ borderColor: v })} 
          allowTransparent={true} 
        />
        <div>
          <label className="block text-xs font-semibold text-gray-500 uppercase mb-1">Border Width</label>
          <input
            type="range"
            min="0"
            max="20"
            value={selectedElement.borderWidth}
            onChange={(e) => updateElement({ borderWidth: Number(e.target.value) })}
            className="w-full"
          />
        </div>
      </div>
    );
  };

  const renderCommonControls = () => {
    if (!selectedElement) return null;
    return (
      <div className="mt-6 pt-6 border-t border-gray-200 space-y-4">
        <div>
          <label className="block text-xs font-semibold text-gray-500 uppercase mb-1">Opacity</label>
          <input
            type="range"
            min="0"
            max="1"
            step="0.1"
            value={selectedElement.opacity}
            onChange={(e) => updateElement({ opacity: Number(e.target.value) })}
            className="w-full"
          />
        </div>
      </div>
    );
  };

  return (
    <div className="p-4">
      {selectedElement ? (
        <div>
          <div className="font-semibold mb-4 text-sm uppercase text-gray-500">Edit {selectedElement.type}</div>
          {renderTextControls()}
          {renderShapeControls()}
          {renderImageControls()}
          {renderCommonControls()}
        </div>
      ) : (
        <div>
          <div className="font-semibold mb-4 text-sm uppercase text-gray-500">Page Settings</div>
          <div className="text-sm text-gray-600 space-y-4">
            <div>
              <label className="block text-xs font-semibold text-gray-500 uppercase mb-1">Flyer Name</label>
              <input
                type="text"
                value={state.project.name}
                onChange={(e) => dispatch({ type: "SET_PROJECT", payload: { ...state.project, name: e.target.value } })}
                className="w-full p-2 border border-gray-300 rounded text-sm"
              />
            </div>
            <ColorInput 
              label="Background Color" 
              value={state.project.page.backgroundColor} 
              onChange={(v) => dispatch({ type: "UPDATE_PAGE_SETTINGS", payload: { backgroundColor: v } })} 
              allowTransparent={true} 
            />
            <p className="pt-2 border-t border-gray-200"><strong>Size:</strong> 8.5" x 11"</p>
          </div>
          <div className="mt-8 bg-blue-50 p-4 rounded-md text-sm text-blue-800">
            <p className="font-semibold mb-2">Print Tips</p>
            <p>On Mac: choose your printer or "Save as PDF". Set Paper Size to Letter, Scale to 100%, and disable browser headers/footers.</p>
          </div>
        </div>
      )}
    </div>
  );
};

export default Inspector;
