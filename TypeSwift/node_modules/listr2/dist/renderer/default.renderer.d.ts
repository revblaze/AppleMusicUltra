import { ListrRenderer, ListrTaskObject } from '../interfaces/listr.interface';
/** Default updating renderer for Listr2 */
export declare class DefaultRenderer implements ListrRenderer {
    tasks: ListrTaskObject<any, typeof DefaultRenderer>[];
    options: typeof DefaultRenderer['rendererOptions'];
    renderHook$?: ListrTaskObject<any, any>['renderHook$'];
    /** designates whether this renderer can output to a non-tty console */
    static nonTTY: boolean;
    /** renderer options for the defauult renderer */
    static rendererOptions: {
        /**
         * indentation per level of subtask
         * @default 2
         */
        indentation?: number;
        /**
         * clear output when task finishes
         * @default false
         */
        clearOutput?: boolean;
        /**
         * show the subtasks of the current task if it returns a new listr
         * @default true
         */
        showSubtasks?: boolean;
        /**
         * collapse subtasks after finish
         * @default true
         */
        collapse?: boolean;
        /**
         * collapse skip messages in to single message and override the task title
         * @default true
         */
        collapseSkips?: boolean;
        /**
         * show skip messages or show the original title of the task, this will also disable collapseSkips mode
         *
         * You can disable showing the skip messages, eventhough you passed in a message by settings this option,
         * if you want to keep the original task title intacted.
         * @default true
         */
        showSkipMessage?: boolean;
        /**
         * suffix skip messages with [SKIPPED] when in collapseSkips mode
         * @default true
         */
        suffixSkips?: boolean;
        /**
         * collapse error messages in to single message in task title
         * @default true
         */
        collapseErrors?: boolean;
        /**
         * shows the thrown error message or show the original title of the task, this will also disable collapseErrors mode
         * You can disable showing the error messages, eventhough you passed in a message by settings this option,
         * if you want to keep the original task title intacted.
         * @default true
         */
        showErrorMessage?: boolean;
        /**
         * only update via renderhook
         *
         * useful for tests and stuff. this will disable showing spinner and only update the screen if the something else has
         * happened in the task worthy to show
         * @default false
         */
        lazy?: boolean;
        /**
         * show duration for all tasks
         *
         * overwrites per task renderer options
         * @default false
         */
        showTimer?: boolean;
    };
    /** per task options for the default renderer */
    static rendererTaskOptions: {
        /**
         * write task output to bottom bar instead of the gap under the task title itself.
         * useful for stream of data.
         * @default false
         *
         * `true` only keep 1 line of latest data outputted by the task.
         * `false` only keep 1 line of latest data outputted by the task.
         * `number` will keep designated data of latest data outputted by the task.
         */
        bottomBar?: boolean | number;
        /**
         * keep output after task finishes
         * @default false
         *
         * works both for bottom bar and the default behavior
         */
        persistentOutput?: boolean;
        /**
         * show the task time if it was succesful
         */
        showTimer?: boolean;
    };
    private id?;
    private bottomBar;
    private promptBar;
    private spinner;
    private spinnerPosition;
    constructor(tasks: ListrTaskObject<any, typeof DefaultRenderer>[], options: typeof DefaultRenderer['rendererOptions'], renderHook$?: ListrTaskObject<any, any>['renderHook$']);
    getTaskOptions(task: ListrTaskObject<any, typeof DefaultRenderer>): typeof DefaultRenderer['rendererTaskOptions'];
    isBottomBar(task: ListrTaskObject<any, typeof DefaultRenderer>): boolean;
    hasPersistentOutput(task: ListrTaskObject<any, typeof DefaultRenderer>): boolean;
    hasTimer(task: ListrTaskObject<any, typeof DefaultRenderer>): boolean;
    getTaskTime(task: ListrTaskObject<any, typeof DefaultRenderer>): string;
    createRender(options?: {
        tasks?: boolean;
        bottomBar?: boolean;
        prompt?: boolean;
    }): string;
    render(): void;
    end(): void;
    private multiLineRenderer;
    private renderBottomBar;
    private renderPrompt;
    private dumpData;
    private formatString;
    private getSymbol;
}
