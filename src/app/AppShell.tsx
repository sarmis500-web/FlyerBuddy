import React from "react";
import TopBar from "../components/TopBar";
import LeftToolbar from "../components/LeftToolbar";
import Inspector from "../components/Inspector";
import Workspace from "../components/Workspace";
import { useKeyboardShortcuts } from "../features/editor/useKeyboardShortcuts";
import { useAutosave } from "../features/storage/useAutosave";

const AppShell = () => {
  useKeyboardShortcuts();
  useAutosave();

  return (
    <div className="flex flex-col h-screen w-screen bg-gray-50 overflow-hidden text-gray-900">
      {/* Top Navigation / Controls */}
      <div className="h-14 border-b border-gray-200 bg-white flex-shrink-0 no-print">
        <TopBar />
      </div>

      {/* Main Layout Area */}
      <div className="flex flex-1 overflow-hidden">
        {/* Left Toolbar */}
        <div className="w-16 md:w-64 border-r border-gray-200 bg-white flex-shrink-0 flex flex-col no-print">
          <LeftToolbar />
        </div>

        {/* Center Workspace (Canvas) */}
        <div className="flex-1 bg-gray-100 overflow-hidden relative">
          <Workspace />
        </div>

        {/* Right Inspector */}
        <div className="w-64 border-l border-gray-200 bg-white flex-shrink-0 overflow-y-auto no-print">
          <Inspector />
        </div>
      </div>
    </div>
  );
};

export default AppShell;
