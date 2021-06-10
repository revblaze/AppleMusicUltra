import { ListrRenderer, ListrTaskObject } from '../interfaces/listr.interface';
import { Logger } from '../utils/logger';
export declare class VerboseRenderer implements ListrRenderer {
    tasks: ListrTaskObject<any, typeof VerboseRenderer>[];
    options: typeof VerboseRenderer['rendererOptions'];
    /** designates whether this renderer can output to a non-tty console */
    static nonTTY: boolean;
    /** renderer options for the verbose renderer */
    static rendererOptions: {
        /**
         * useIcons instead of text for log level
         * @default false
         */
        useIcons?: boolean;
        /**
         * inject a custom loger
         */
        logger?: new (...args: any) => Logger;
        /**
         * log tasks with empty titles
         * @default true
         */
        logEmptyTitle?: boolean;
        /**
         * log title changes
         * @default true
         */
        logTitleChange?: boolean;
    };
    /** per task options for the verbose renderer */
    static rendererTaskOptions: never;
    private logger;
    constructor(tasks: ListrTaskObject<any, typeof VerboseRenderer>[], options: typeof VerboseRenderer['rendererOptions']);
    render(): void;
    end(): void;
    private verboseRenderer;
}
