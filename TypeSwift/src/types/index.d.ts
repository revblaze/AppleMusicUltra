// global types
type WKScriptMessage =
  | number
  | string
  | Date
  | Record<string, unknown>
  | Array<WKScriptMessage>
  | null;

interface Window {
  webkit: {
    messageHandlers: {
      [handlerName: string]: {
        postMessage: (message: WKScriptMessage) => void;
      };
    };
  };
}
