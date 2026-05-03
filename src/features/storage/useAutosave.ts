import { useEffect, useRef } from 'react';
import { useEditor } from '../editor/EditorContext';
import { saveProjectToDB, loadProjectFromDB } from './storageUtils';

export const useAutosave = () => {
  const { state, dispatch } = useEditor();
  const initialized = useRef(false);

  // Load on mount
  useEffect(() => {
    const load = async () => {
      try {
        const savedProject = await loadProjectFromDB();
        if (savedProject && savedProject.version === 1) {
          dispatch({ type: 'SET_PROJECT', payload: savedProject });
        }
      } catch (e) {
        console.error("Failed to load project", e);
      } finally {
        initialized.current = true;
      }
    };
    load();
  }, [dispatch]);

  // Save on change
  useEffect(() => {
    if (!initialized.current) return;
    
    const save = async () => {
      try {
        await saveProjectToDB(state.project);
      } catch (e) {
        console.error("Failed to autosave project", e);
      }
    };

    // Debounce save
    const timeout = setTimeout(save, 1000);
    return () => clearTimeout(timeout);
  }, [state.project]);
};
