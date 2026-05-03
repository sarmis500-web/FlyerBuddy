import React, { createContext, useContext, useReducer } from "react";
import type { ReactNode, Dispatch } from "react";
import type { EditorState, EditorAction } from "./editorReducer";
import { editorReducer, initialEditorState } from "./editorReducer";

type EditorContextType = {
  state: EditorState;
  dispatch: Dispatch<EditorAction>;
};

const EditorContext = createContext<EditorContextType | undefined>(undefined);

export const EditorProvider = ({ children }: { children: ReactNode }) => {
  const [state, dispatch] = useReducer(editorReducer, initialEditorState);

  return (
    <EditorContext.Provider value={{ state, dispatch }}>
      {children}
    </EditorContext.Provider>
  );
};

export const useEditor = () => {
  const context = useContext(EditorContext);
  if (context === undefined) {
    throw new Error("useEditor must be used within an EditorProvider");
  }
  return context;
};
