import type { FlyerProject, FlyerElement, PageSettings } from "./editorTypes";
import { v4 as uuidv4 } from "uuid";

export type EditorState = {
  project: FlyerProject;
  selectedElementIds: string[];
  zoomScale: number;
  history: FlyerProject[];
  historyIndex: number;
};

export type EditorAction =
  | { type: "SET_PROJECT"; payload: FlyerProject }
  | { type: "ADD_ELEMENT"; payload: FlyerElement }
  | { type: "UPDATE_ELEMENT"; payload: { id: string; updates: Partial<FlyerElement> } }
  | { type: "DELETE_ELEMENT"; payload: string }
  | { type: "SELECT_ELEMENT"; payload: string | null }
  | { type: "SET_ZOOM"; payload: number }
  | { type: "UNDO" }
  | { type: "REDO" }
  | { type: "BRING_FORWARD"; payload: string }
  | { type: "SEND_BACKWARD"; payload: string }
  | { type: "UPDATE_PAGE_SETTINGS"; payload: Partial<PageSettings> };

const MAX_HISTORY = 50;

const saveHistory = (state: EditorState, newProject: FlyerProject): EditorState => {
  const newHistory = state.history.slice(0, state.historyIndex + 1);
  newHistory.push(state.project);
  if (newHistory.length > MAX_HISTORY) {
    newHistory.shift();
  }
  return {
    ...state,
    project: newProject,
    history: newHistory,
    historyIndex: newHistory.length,
  };
};

export const editorReducer = (state: EditorState, action: EditorAction): EditorState => {
  switch (action.type) {
    case "SET_PROJECT":
      return {
        ...state,
        project: action.payload,
        selectedElementIds: [],
        history: [],
        historyIndex: -1,
      };

    case "ADD_ELEMENT": {
      const newProject = {
        ...state.project,
        elements: [...state.project.elements, action.payload],
        updatedAt: new Date().toISOString(),
      };
      return saveHistory(state, newProject);
    }

    case "UPDATE_ELEMENT": {
      const newElements = state.project.elements.map((el) =>
        el.id === action.payload.id ? { ...el, ...action.payload.updates } : el
      ) as FlyerElement[];
      const newProject = { ...state.project, elements: newElements, updatedAt: new Date().toISOString() };
      return saveHistory(state, newProject);
    }

    case "DELETE_ELEMENT": {
      const newElements = state.project.elements.filter((el) => el.id !== action.payload);
      const newProject = { ...state.project, elements: newElements, updatedAt: new Date().toISOString() };
      return saveHistory({
        ...state,
        selectedElementIds: state.selectedElementIds.filter(id => id !== action.payload)
      }, newProject);
    }

    case "SELECT_ELEMENT":
      return {
        ...state,
        selectedElementIds: action.payload ? [action.payload] : [],
      };

    case "SET_ZOOM":
      return { ...state, zoomScale: action.payload };

    case "UNDO": {
      if (state.historyIndex >= 0) {
        const prevProject = state.history[state.historyIndex];
        return {
          ...state,
          project: prevProject,
          historyIndex: state.historyIndex - 1,
        };
      }
      return state;
    }

    case "REDO": {
      if (state.historyIndex < state.history.length - 1) {
        const nextProject = state.history[state.historyIndex + 1];
        return {
          ...state,
          project: nextProject,
          historyIndex: state.historyIndex + 1,
        };
      }
      return state;
    }

    case "BRING_FORWARD": {
      const elements = [...state.project.elements];
      const index = elements.findIndex(el => el.id === action.payload);
      if (index >= 0 && index < elements.length - 1) {
        const temp = elements[index];
        elements[index] = elements[index + 1];
        elements[index + 1] = temp;
        // Reassign zIndex to match array order
        elements.forEach((el, i) => el.zIndex = i);
        return saveHistory(state, { ...state.project, elements, updatedAt: new Date().toISOString() });
      }
      return state;
    }

    case "SEND_BACKWARD": {
      const elements = [...state.project.elements];
      const index = elements.findIndex(el => el.id === action.payload);
      if (index > 0) {
        const temp = elements[index];
        elements[index] = elements[index - 1];
        elements[index - 1] = temp;
        elements.forEach((el, i) => el.zIndex = i);
        return saveHistory(state, { ...state.project, elements, updatedAt: new Date().toISOString() });
      }
      return state;
    }

    case "UPDATE_PAGE_SETTINGS": {
      const newProject = {
        ...state.project,
        page: { ...state.project.page, ...action.payload },
        updatedAt: new Date().toISOString()
      };
      return saveHistory(state, newProject);
    }

    default:
      return state;
  }
};

// Initial empty project
export const createEmptyProject = (): FlyerProject => ({
  version: 1,
  id: uuidv4(),
  name: "Untitled Flyer",
  createdAt: new Date().toISOString(),
  updatedAt: new Date().toISOString(),
  page: {
    sizeName: "letter",
    widthPt: 612,
    heightPt: 792,
    backgroundColor: "#ffffff",
  },
  elements: [],
});

export const initialEditorState: EditorState = {
  project: createEmptyProject(),
  selectedElementIds: [],
  zoomScale: 1,
  history: [],
  historyIndex: -1,
};
