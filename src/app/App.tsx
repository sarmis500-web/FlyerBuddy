import React from "react";
import AppShell from "./AppShell";
import { EditorProvider } from "../features/editor/EditorContext";

function App() {
  return (
    <EditorProvider>
      <AppShell />
    </EditorProvider>
  );
}

export default App;
