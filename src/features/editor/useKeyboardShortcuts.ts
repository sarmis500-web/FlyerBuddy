import { useEffect } from "react";
import { useEditor } from "./EditorContext";

export const useKeyboardShortcuts = () => {
  const { state, dispatch } = useEditor();

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      // Don't intercept if user is typing in an input or contenteditable
      if (
        e.target instanceof HTMLInputElement ||
        e.target instanceof HTMLTextAreaElement ||
        (e.target as HTMLElement).isContentEditable
      ) {
        return;
      }

      // Delete / Backspace
      if (e.key === "Delete" || e.key === "Backspace") {
        if (state.selectedElementIds.length > 0) {
          dispatch({ type: "DELETE_ELEMENT", payload: state.selectedElementIds[0] });
        }
      }

      // Undo (Cmd/Ctrl + Z)
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "z" && !e.shiftKey) {
        e.preventDefault();
        dispatch({ type: "UNDO" });
      }

      // Redo (Cmd/Ctrl + Shift + Z)
      if ((e.metaKey || e.ctrlKey) && e.shiftKey && e.key.toLowerCase() === "z") {
        e.preventDefault();
        dispatch({ type: "REDO" });
      }

      // Deselect (Escape)
      if (e.key === "Escape") {
        dispatch({ type: "SELECT_ELEMENT", payload: null });
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [state.selectedElementIds, dispatch]);
};
