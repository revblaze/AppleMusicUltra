import { ListrRenderer, ListrTaskObject } from '../interfaces/listr.interface';
export declare class SilentRenderer implements ListrRenderer {
    tasks: ListrTaskObject<any, typeof SilentRenderer>[];
    options: typeof SilentRenderer['rendererOptions'];
    /** designates whether this renderer can output to a non-tty console */
    static nonTTY: boolean;
    /** renderer options for the silent renderer */
    static rendererOptions: never;
    /** per task options for the silent renderer */
    static rendererTaskOptions: never;
    constructor(tasks: ListrTaskObject<any, typeof SilentRenderer>[], options: typeof SilentRenderer['rendererOptions']);
    render(): void;
    end(): void;
}
