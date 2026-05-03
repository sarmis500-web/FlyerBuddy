import { openDB } from 'idb';
import type { FlyerProject } from '../editor/editorTypes';

const DB_NAME = 'FlyerBuddyDB';
const STORE_NAME = 'projects';
const AUTOSAVE_KEY = 'autosave';

export const initDB = async () => {
  return openDB(DB_NAME, 1, {
    upgrade(db) {
      if (!db.objectStoreNames.contains(STORE_NAME)) {
        db.createObjectStore(STORE_NAME);
      }
    },
  });
};

export const saveProjectToDB = async (project: FlyerProject) => {
  const db = await initDB();
  await db.put(STORE_NAME, project, AUTOSAVE_KEY);
};

export const loadProjectFromDB = async (): Promise<FlyerProject | undefined> => {
  const db = await initDB();
  return db.get(STORE_NAME, AUTOSAVE_KEY);
};

export const exportProjectJSON = (project: FlyerProject) => {
  const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(project, null, 2));
  const downloadAnchorNode = document.createElement('a');
  downloadAnchorNode.setAttribute("href", dataStr);
  downloadAnchorNode.setAttribute("download", `${project.name || 'flyer'}.flyerbuddy.json`);
  document.body.appendChild(downloadAnchorNode); // required for firefox
  downloadAnchorNode.click();
  downloadAnchorNode.remove();
};
