/// <reference types="node" />
import { ListrBaseClassOptions, ListrError, ListrRendererFactory, ListrSubClassOptions, ListrTask, ListrTaskObject, ListrTaskWrapper } from '../interfaces/listr.interface';
import { StateConstants } from '../interfaces/state.constants';
import { Task } from './task';
import { Listr } from '../index';
import { PromptOptions } from '../utils/prompt.interface';
/**
 * Extend the task to have more functionality while accesing from the outside.
 */
export declare class TaskWrapper<Ctx, Renderer extends ListrRendererFactory> implements ListrTaskWrapper<Ctx, Renderer> {
    task: Task<Ctx, ListrRendererFactory>;
    errors: ListrError[];
    private options;
    constructor(task: Task<Ctx, ListrRendererFactory>, errors: ListrError[], options: ListrBaseClassOptions<Ctx, any, any>);
    set title(data: string);
    get title(): string;
    set output(data: string);
    get output(): string;
    set state(data: StateConstants);
    set message(data: ListrTaskObject<Ctx, Renderer>['message']);
    newListr(task: ListrTask<Ctx, Renderer> | ListrTask<Ctx, Renderer>[] | ((parent: this) => ListrTask<Ctx, Renderer> | ListrTask<Ctx, Renderer>[]), options?: ListrSubClassOptions<Ctx, Renderer>): Listr<Ctx, any, any>;
    report(error: Error | ListrError): void;
    cancelPrompt(throwError?: boolean): void;
    skip(message?: string): void;
    prompt<T = any>(options: PromptOptions | PromptOptions<true>[]): Promise<T>;
    stdout(): NodeJS.WriteStream & NodeJS.WritableStream;
    run(ctx: Ctx): Promise<void>;
}
